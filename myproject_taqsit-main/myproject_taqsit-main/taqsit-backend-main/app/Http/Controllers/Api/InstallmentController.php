<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\{Installment, User, Bank, Transaction};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class InstallmentController extends Controller
{
    /**
     * عرض جميع أقساط المستخدم (مدفوعة وغير مدفوعة)
     */
    public function myInstallments($userId)
    {
        // جلب الأقساط مباشرة عبر user_id الذي أضفناه للجدول لسرعة الاستعلام
        $installments = Installment::where('user_id', $userId)
            ->with('order.product') 
            ->orderBy('due_date', 'asc')
            ->get();

        // حساب إجمالي المبالغ المتبقية غير المدفوعة
        $remainingTotal = $installments->where('status', 'pending')->sum('amount');

        return response()->json([
            'status' => 'success',
            'user_id' => $userId,
            'remaining_total' => $remainingTotal,
            'installments' => $installments->map(function ($item) {
                return [
                    'id' => $item->id,
                    'product_name' => $item->order->product->product_name, // الحقل المعدل
                    'amount' => $item->amount,
                    'due_date' => $item->due_date,
                    'status' => $item->status, 
                    'is_late' => Carbon::now()->gt($item->due_date) && $item->status != 'paid',
                ];
            })
        ]);
    }

    /**
     * عملية تسديد القسط من قبل العميل
     */
    public function payInstallment(Request $request)
    {
        $request->validate([
            'installment_id' => 'required|exists:installments,id',
            'user_id' => 'required|exists:users,id',
        ]);

        $installment = Installment::findOrFail($request->installment_id);
        $user = User::findOrFail($request->user_id);

        // 1. التأكد أن القسط غير مدفوع أصلاً
        if ($installment->status == 'paid') {
            return response()->json(['message' => 'هذا القسط مدفوع مسبقاً.'], 400);
        }

        // 2. التحقق من الرصيد في جدول البنك (المصدر المالي)
        $bankAccount = Bank::where('phone_number', $user->phone_number)->first();
        
        if (!$bankAccount || $bankAccount->balance < $installment->amount) {
            return response()->json(['message' => 'رصيدك البنكي غير كافٍ لسداد القسط.'], 400);
        }

        return DB::transaction(function () use ($installment, $user, $bankAccount) {
            // أ- الخصم من رصيد البنك
            $bankAccount->decrement('balance', $installment->amount);

            // ب- تحديث حالة القسط وتاريخ السداد الفعلي
            $installment->update([
                'status' => 'paid',
                'paid_at' => Carbon::now()
            ]);

            // ج- تسجيل حركة مالية (Transaction) للأرشفة
            Transaction::create([
                'user_id' => $user->id,
                'order_id' => $installment->order_id,
                'type' => 'installment_payment',
                'amount' => $installment->amount,
                'from_party' => 'Customer Account',
                'to_party' => 'Smart Installment System',
            ]);

            // د- فحص الأقساط المتأخرة لفك الحظر تلقائياً
            $overdueCount = Installment::where('user_id', $user->id)
                ->where('status', '!=', 'paid')
                ->where('due_date', '<', Carbon::now())
                ->count();

            if ($overdueCount == 0) {
                $user->update(['is_blocked' => false]);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'تم تسديد القسط بنجاح' . ($overdueCount == 0 ? ' وتم فك الحظر عن حسابك.' : ''),
                'new_balance' => $bankAccount->balance
            ]);
        });
    }
}
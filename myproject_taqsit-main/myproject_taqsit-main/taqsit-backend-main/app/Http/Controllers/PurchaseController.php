<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\{User, Product, Order, Installment, Merchant, Bank, Transaction};
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PurchaseController extends Controller
{
    /**
     * معالجة عملية الشراء والتقسيط الآمنة لتطبيق فلاتر
     */
    public function purchase(Request $request)
    {
        // 1. التحقق من صحة المنتج فقط (تم إلغاء user_id للحماية من التلاعب)
        $request->validate([
            'product_id'       => 'required|exists:products,id',
            'installment_plan' => 'nullable|integer|min:1|max:12'
        ]);

        // جلب المستخدم المصادق عليه آلياً عبر التوكن الآمن للـ API
        $user = $request->user(); 
        
        if (!$user) {
            return response()->json(['status' => 'error', 'message' => 'غير مصرح للوصول.'], 401);
        }

        $product = Product::find($request->product_id);

        if ($user->is_blocked || !$user->is_active) {
            return response()->json(['status' => 'error', 'message' => 'حسابك مقيد حالياً.'], 403);
        }

        // حساب التقسيمات المالية
        $downPayment = $product->price * 0.50;
        $financedAmount = $product->price - $downPayment;

        // 2. تنفيذ المعاملة المالية الآمنة باستخدام قفل البيانات (Database Lock)
        try {
            return DB::transaction(function () use ($user, $product, $downPayment, $financedAmount, $request) {
                
                // جلب الحساب البنكي مع تفعيل lockForUpdate لمنع ثغرات التزامن (Race Conditions)
                $bankAccount = Bank::where('phone_number', $user->phone_number)->lockForUpdate()->first();

                if (!$bankAccount) {
                    throw new \Exception('عذراً، لا يوجد حساب بنكي مرتبط برقم هاتف هذا الحساب.');
                }

                // فحص القيود المالية داخل القفل لضمان دقة الرصيد الحقيقي
                if ($bankAccount->max_credit_limit < $financedAmount) {
                    throw new \Exception('المبلغ المطلوب تقسيطه يتجاوز سقف الائتمان المسموح به.');
                }

                if ($bankAccount->balance < $downPayment) {
                    throw new \Exception('رصيدك البنكي لا يكفي لخصم المقدم (50%).');
                }

                // أ- التحديث في جدول البنك
                $bankAccount->decrement('balance', $downPayment);
                $bankAccount->decrement('max_credit_limit', $financedAmount);

                // ب- تحويل المستحقات للتاجر بعد خصم العمولة 2%
                $commission = $product->price * 0.02;
                $netForMerchant = $product->price - $commission;
                
                $merchant = Merchant::find($product->merchant_id);
                if ($merchant) {
                    $merchant->increment('bank_balance', $netForMerchant);
                }

                // ج- تسجيل الطلب الرئيسي
                $order = Order::create([
                    'user_id'           => $user->id,
                    'merchant_id'       => $product->merchant_id,
                    'product_id'        => $product->id,
                    'total_amount'      => $product->price,
                    'down_payment'      => $downPayment,
                    'remaining_amount'  => $financedAmount,
                    'commission_amount' => $commission,
                    'status'            => 'approved'
                ]);

                // د- تسجيل الحركة في سجل المعاملات
                Transaction::create([
                    'user_id'    => $user->id,
                    'order_id'   => $order->id,
                    'type'       => 'purchase_down_payment',
                    'amount'     => $downPayment,
                    'from_party' => 'حساب العميل: ' . $user->full_name, 
                    'to_party'   => 'متجر التاجر: ' . ($merchant->store_name ?? 'التاجر'),
                ]);

                // هـ- جدولة الأقساط الشهرية
                $months = $request->input('installment_plan', 3); 
                $installmentAmount = $financedAmount / $months;

                for ($i = 1; $i <= $months; $i++) {
                    Installment::create([
                        'order_id' => $order->id,
                        'user_id'  => $user->id,
                        'amount'   => $installmentAmount,
                        'due_date' => Carbon::now()->addMonths($i),
                        'status'   => 'pending' 
                    ]);
                }

                return response()->json([
                    'status' => 'success',
                    'message' => 'تمت العملية بنجاح!',
                    'data' => [
                        'order_id'     => $order->id,
                        'customer'     => $user->full_name,
                        'installments' => $months,
                        'next_payment' => Carbon::now()->addMonth()->toDateString()
                    ]
                ], 200);
            });
        } catch (\Exception $e) {
            Log::error("Purchase Failed: " . $e->getMessage());
            return response()->json(['status' => 'error', 'message' => 'فشلت العملية: ' . $e->getMessage()], 400);
        }
    }

    /**
     * سداد قسط محدد (تم تأمين الرصيد عبر القفل)
     */
    public function payInstallment(Request $request)
    {
        $request->validate([
            'installment_id' => 'required|exists:installments,id',
        ]);

        $currentUser = $request->user(); 
        $installment = Installment::find($request->installment_id);

        if ($installment->user_id !== $currentUser->id) {
            return response()->json(['status' => 'error', 'message' => 'عذراً، هذا القسط لا يخص حسابك.'], 403);
        }

        if ($installment->status === 'paid') {
            return response()->json(['status' => 'error', 'message' => 'هذا القسط مدفوع بالفعل.'], 400);
        }

        try {
            return DB::transaction(function () use ($installment, $currentUser) {
                
                // جلب الحساب البنكي مباشرة داخل الترانزاكشن مع تفعيل قفل السجل لضمان الحماية المالية
                $bankAccount = Bank::where('phone_number', $currentUser->phone_number)->lockForUpdate()->first();

                if (!$bankAccount) {
                    throw new \Exception("لم يتم العثور على الحساب البنكي");
                }

                if ($bankAccount->balance < $installment->amount) {
                    throw new \Exception("عذراً، رصيدك البنكي لا يكفي لسداد القسط.");
                }


// 1. حساب النقاط بناءً على التاريخ
if (now()->lessThanOrEqualTo($installment->due_date)) {
    // السداد في موعده أو قبله: إضافة 2
    $bankAccount->increment('credit_score', 2);
} else {
    // السداد متأخر: خصم 2
    $bankAccount->decrement('credit_score', 2);
}

// 2. تحديث الرصيد (موجود مسبقاً لديك)
$bankAccount->decrement('balance', $installment->amount);
$bankAccount->increment('max_credit_limit', $installment->amount);


                // تحديث حالة القسط
                $installment->update([
                    'status'  => 'paid',
                    'paid_at' => now()
                ]);

                // تسجيل العملية المالية
                Transaction::create([
                    'user_id'    => $currentUser->id,
                    'order_id'   => $installment->order_id,
                    'type'       => 'installment_payment',
                    'amount'     => $installment->amount,
                    'from_party' => 'حساب العميل: ' . $currentUser->full_name,
                    'to_party'   => 'البنك المركزي',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'تم سداد القسط بنجاح!',
                    'debug_info' => [
                        'new_balance' => $bankAccount->fresh()->balance,
                        'new_score'   => $bankAccount->fresh()->credit_score
                    ]
                ]);
            });
        } catch (\Exception $e) {
            return response()->json(['status' => 'error', 'message' => $e->getMessage()], 400);
        }
    }

    public function getUserTransactions(Request $request)
    {
        $transactions = Transaction::where('user_id', $request->user()->id)
            ->with('order.product') 
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'count'  => $transactions->count(),
            'data'   => $transactions
        ], 200);
    }

 public function showBankDashboard(Request $request)
{
    $stats = [
        'total_sales' => Order::sum('total_amount'),
        'overdue' => Installment::where('status', 'pending')->where('due_date', '<', now())->sum('amount'),
        'merchants_count' => Merchant::count(),
        'users_count' => User::count(),
    ];
    
    $search = $request->input('search');

    $recentTransactions = Transaction::with('user', 'order')
        ->when($search, function ($query) use ($search) {
            return $query->where('type', 'like', "%{$search}%")
                         ->orWhere('from_party', 'like', "%{$search}%")
                         ->orWhere('to_party', 'like', "%{$search}%")
                         ->orWhere('amount', 'like', "%{$search}%")
                         ->orWhereHas('user', function ($q) use ($search) {
                             $q->where('full_name', 'like', "%{$search}%")
                               ->orWhere('phone_number', 'like', "%{$search}%");
                         });
        })
        ->latest()
        ->take(15)
        ->get();

    return view('bank.dashboard', compact('stats', 'recentTransactions'));
}
}
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Installment; 
use App\Models\Order;
use App\Models\Merchant; 
use App\Models\User;     

class BankController extends Controller
{
    // دالة لوحة التحكم الرئيسية
    public function index()
    {
        $installments = Installment::with(['user', 'product.merchant'])->latest()->get();
        $merchants = Merchant::all();
        
        // الحسابات المالية التي يطلبها الـ Blade
        $total_financed = Installment::sum('amount');
        $total_paid = Installment::where('status', 'paid')->sum('amount');
        $total_pending = Installment::where('status', 'pending')->sum('amount');
        $late_payments_count = Installment::where('status', 'late')->count();

        return view('bank.dashboard', compact(
            'installments', 'merchants', 'total_financed', 
            'total_paid', 'total_pending', 'late_payments_count'
        ));
    }

    // دالة صفحة التقارير الشاملة
    public function reports()
    {
        // جلب البيانات اللازمة لجدول التقارير والفلترة
        $installments = Installment::with(['user', 'product.merchant'])->latest()->get();
        $merchants = Merchant::all();

        return view('bank.reports', compact('installments', 'merchants'));
    }

  public function search(Request $request)
{
    $query = $request->input('query');

    if (!$query) {
        return redirect()->back()->with('error', 'الرجاء إدخال نص للبحث.');
    }

    // 1. البحث في جدول العملاء
    $user = User::where('full_name', 'LIKE', "%{$query}%")
                ->orWhere('phone_number', 'LIKE', "%{$query}%")
                ->first();

    // 2. البحث في جدول التجار
    $merchant = Merchant::where('store_name', 'LIKE', "%{$query}%")
                        ->orWhere('commercial_reg', 'LIKE', "%{$query}%")
                        ->first();

    if ($user) {
        // إذا كان عميلاً، نجلب أقساطه
        $installments = Installment::with(['product.merchant'])->where('user_id', $user->id)->get();
        $type = 'user';
        $data = $user;
    } elseif ($merchant) {
        // إذا كان تاجراً، قمنا بتحديد الجدول بوضوح (products.merchant_id) لمنع التداخل والخطأ
        $installments = Installment::whereHas('product', function($q) use ($merchant) {
            $q->where('products.merchant_id', $merchant->id); 
        })->with(['user', 'product'])->get();
        $type = 'merchant';
        $data = $merchant;
    } else {
        // إذا لم يتم العثور على أي مستخدم أو تاجر بهذا الاسم، نعود للخلف مع رسالة تنبيهية نظيفة
        return redirect()->back()->with('error', 'عذراً، لا توجد بيانات مطابقة لهذا الاسم في النظام.');
    }

    return view('bank.search_results', compact('data', 'type', 'installments', 'query'));
}
}
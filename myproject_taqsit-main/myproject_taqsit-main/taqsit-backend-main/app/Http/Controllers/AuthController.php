<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Merchant;
use App\Models\Bank;

class AuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        // 1. مسار دخول مدير البنك (البيانات الثابتة كما هي)
        $adminEmail = "admin@bank.com"; 
        $adminPass  = "bank123";         

        if ($request->email === $adminEmail && $request->password === $adminPass) {
            // نأخذ أول سجل كمدير للبنك
            $bank = Bank::first(); 
            if ($bank) {
                Auth::guard('bank')->login($bank);
                return redirect()->route('bank.dashboard');
            }
        }

        // 2. مسار دخول التاجر (باستخدام اسم المتجر والسجل التجاري)
        if ($request->has('store_name') && $request->has('commercial_reg')) {
            $merchant = Merchant::where('store_name', $request->store_name)
                                ->where('commercial_reg', $request->commercial_reg)
                                ->first();

            if ($merchant) {
                Auth::guard('merchant')->login($merchant);
                return redirect()->route('merchant.dashboard');
            }
        }

        // 3. مسار دخول العميل (التحقق من الهاتف وباسورد البنك)
        // يتم التحقق من رقم الهاتف وكلمة السر ضد جدول 'banks'
        if ($request->has('phone_number') && $request->has('password')) {
            $credentials = $request->only('phone_number', 'password');

            // محاولة تسجيل الدخول باستخدام حارس البنك 'bank'
            if (Auth::guard('bank')->attempt($credentials)) {
                // إذا نجح، يتم توجيهه لصفحة العميل الرئيسية
                return redirect()->route('home'); 
            }
        }

        return back()->withErrors(['error' => 'بيانات الدخول غير صحيحة أو غير مسجلة في النظام البنكي']);
    }

    public function logout(Request $request)
    {
        // تسجيل الخروج من جميع الحراس لضمان الأمان
        Auth::guard('bank')->logout();
        Auth::guard('merchant')->logout();
        Auth::guard('web')->logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/login');
    }
}
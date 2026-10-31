<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Bank;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    /**
     * تسجيل الدخول عبر التحقق من سجلات البنك ومزامنة البيانات
     */
    public function login(Request $request)
    {
        // 1. التحقق من صحة المدخلات
        $request->validate([
            'phone_number' => 'required|string',
            'password'     => 'required|string',
        ]);

        try {
            // 2. البحث في جدول "البنك" (المصدر الموثوق للهوية)
            $bankAccount = Bank::where('phone_number', $request->phone_number)->first();

            // 3. التأكد من مطابقة سجلات البنك وكلمة السر المشفرة
            if (!$bankAccount || !Hash::check($request->password, $bankAccount->password)) {
                return response()->json([
                    'status'  => 'error',
                    'message' => 'بيانات الدخول غير مطابقة لسجلات البنك الموحدة!'
                ], 401);
            }

            // 4. مزامنة البيانات مع نظام التقسيط (إنشاء مستخدم أو جلب الحالي)
            // نستخدم phone_number كمعرف وحيد للربط بين النظامين
            $user = User::firstOrCreate(
                ['phone_number' => $bankAccount->phone_number],
                [
                    'full_name'    => $bankAccount->full_name,
                    'password'     => $bankAccount->password, // كلمة سر موحدة للأمان
                    'is_active'    => true,
                    'is_blocked'   => false,
                ]
            );

            // 5. التحقق من حالة الحظر (Block Status) داخل نظام التقسيط
            if ($user->is_blocked) {
                return response()->json([
                    'status'  => 'blocked',
                    'message' => 'عذراً، هذا الحساب مقيد حالياً في نظام التقسيط.'
                ], 403);
            }

            // 6. إصدار التوكن (Sanctum Token) ليتمكن Flutter من حفظ الجلسة
            $token = $user->createToken('auth_token')->plainTextToken;

            // 7. الرد النهائي مع بيانات العميل والبيانات المالية من البنك
            return response()->json([
                'status'  => 'success',
                'message' => 'تم التحقق ومزامنة بياناتك المالية بنجاح',
                'access_token' => $token,
                'token_type'   => 'Bearer',
                'data'    => [
                    'user_id'      => $user->id,
                    'full_name'    => $user->full_name,
                    'phone'        => $user->phone_number,
                    'bank_details' => [
                        'account_no'   => $bankAccount->account_number,
                        'balance'      => $bankAccount->balance,
                        'credit_limit' => $bankAccount->max_credit_limit,
                        'credit_score' => $bankAccount->credit_score
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            Log::error("Login Error: " . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ غير متوقع في الخادم'], 500);
        }
    }
}
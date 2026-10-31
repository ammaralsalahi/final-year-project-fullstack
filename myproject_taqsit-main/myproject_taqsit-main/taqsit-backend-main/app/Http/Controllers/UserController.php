<?php

namespace App\Http\Controllers;

use App\Models\Bank;
use App\Models\User; // لا تنسَ استيراد الموديل
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB; // استيراد فئة قاعدة البيانات للتعامل مع العمليات المتزامنة
use Illuminate\Support\Str;

class userController extends Controller
{
    // عرض صفحة الإضافة
    public function create() {
        return view('bank.create');
    }

    // حفظ العميل الجديد
    public function store(Request $request) {
        $request->validate([
            'identity_number' => 'required|unique:banks,identity_number|digits:10',
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:banks,email',
            'phone_number' => 'required', // سنسمح بالتكرار هنا إذا كان المستخدم موجوداً مسبقاً
            'password' => 'required|min:6',
            'balance' => 'required|numeric',
            'max_credit_limit' => 'required|numeric',
        ]);

        DB::transaction(function () use ($request) {
            // 1. التحقق إذا كان المستخدم موجوداً في جدول users، وإذا لم يكن، نضيفه
            $user = User::firstOrCreate(
                ['phone_number' => $request->phone_number],
                [
                    'full_name' => $request->full_name,
                    'password' => Hash::make($request->password),
                    'is_active' => 1,
                    'is_blocked' => 0,
                ]
            );

            // 2. إضافة البيانات إلى جدول banks
            Bank::create([
                'identity_number' => $request->identity_number,
                'full_name' => $request->full_name,
                'email' => $request->email,
                'phone_number' => $request->phone_number, // هذا الحقل مرتبط بـ users
                'password' => Hash::make($request->password),
                'account_number' => 'ACC-' . date('Y') . '-' . strtoupper(Str::random(3)),
                'balance' => $request->balance,
                'credit_score' => 0,
                'max_credit_limit' => $request->max_credit_limit,
            ]);
        });

        return redirect()->back()->with('success', 'تم إضافة العميل وربطه بنظام البنك بنجاح!');
    }


//     public function updateCreditScore($bankId, $isPaidOnTime) {
//     $bank = Bank::find($bankId);
    
//     if ($isPaidOnTime) {
//         // العميل التزم بالسداد، نزيد نقاطه
//         $bank->credit_score += 5; 
//     } else {
//         // العميل تأخر، نخصم من نقاطه
//         $bank->credit_score -= 10;
//     }
    
//     $bank->save();
// }
}


<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\{User, Bank};
use Illuminate\Support\Facades\Hash;

class BankSeeder extends Seeder
{
    public function run()
    {
        // مصفوفة العملاء مع إضافة كلمة سر خاصة لكل واحد
        $customers = [
            [
                'name'     => 'عمار ياسر الصلاحي',
                'phone'    => '777123456',
                'password' => 'ammar2026', // كلمة سر خاصة
                'email'    => 'ammar@example.com',
                'identity' => '1001001001',
                'acc_no'   => 'ACC-2026-001',
                'balance'  => 50000.00,
                'score'    => 100,
                'limit'    => 10000.00
            ],
            [
                'name'     => 'محمد أحمد الحضرمي',
                'phone'    => '770111222',
                'password' => 'mohammed770', 
                'email'    => 'mohammed@example.com',
                'identity' => '1001001002',
                'acc_no'   => 'ACC-2026-002',
                'balance'  => 15000.00,
                'score'    => 85,
                'limit'    => 3000.00
            ],
            [
                'name'     => 'صالح علي اليافعي',
                'phone'    => '771333444',
                'password' => 'saleh123',
                'email'    => 'saleh@example.com',
                'identity' => '1001001003',
                'acc_no'   => 'ACC-2026-003',
                'balance'  => 8000.00,
                'score'    => 70,
                'limit'    => 1500.00
            ],
            [
                'name'     => 'فؤاد حسن التزي',
                'phone'    => '772555666',
                'password' => 'fouad99',
                'email'    => 'fouad@example.com',
                'identity' => '1001001004',
                'acc_no'   => 'ACC-2026-004',
                'balance'  => 25000.00,
                'score'    => 90,
                'limit'    => 5000.00
            ],
            [
                'name'     => 'ناصر عبده الريمي',
                'phone'    => '773777888',
                'password' => 'nasser888',
                'email'    => 'nasser@example.com',
                'identity' => '1001001005',
                'acc_no'   => 'ACC-2026-005',
                'balance'  => 3000.00,
                'score'  => 45,
                'limit'    => 500.00
            ],
        ];

        foreach ($customers as $c) {
            // تشفير كلمة السر الخاصة بالعميل الحالي
            $hashedPassword = Hash::make($c['password']);

            // إنشاء/تحديث المستخدم
            User::updateOrCreate(
                ['phone_number' => $c['phone']],
                [
                    'full_name' => $c['name'], 
                    'password'  => $hashedPassword // استخدام الباسورد المشفر الخاص به
                ]
            );

            // إنشاء/تحديث سجل البنك
            Bank::updateOrCreate(
                ['phone_number' => $c['phone']],
                [
                    'identity_number' => $c['identity'],
                    'full_name'       => $c['name'],
                    'email'           => $c['email'],
                    'password'        => $hashedPassword, // تخزين نفس الباسورد في جدول البنك للتحقق
                    'account_number'  => $c['acc_no'],
                    'balance'         => $c['balance'],
                    'credit_score'    => $c['score'],
                    'max_credit_limit'=> $c['limit'],
                ]
            );
        }
    }
}
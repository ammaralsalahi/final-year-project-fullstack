<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\{User, Product, Merchant, Bank, Order, Installment};
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class SystemDemoSeeder extends Seeder
{
    public function run()
    {
        $commonPassword = Hash::make('123456');

        // 1. إنشاء المستخدم (عمار)
        $user = User::updateOrCreate(
            ['phone_number' => '777123456'],
            ['full_name' => 'عمار ياسر الصلاحي', 'password' => $commonPassword]
        );

        // 2. إنشاء البنك
        Bank::updateOrCreate(
            ['phone_number' => '777123456'],
            [
                'email' => 'ammar@example.com',
                'identity_number' => '1010203040',
                'full_name' => 'عمار ياسر الصلاحي',
                'password' => $commonPassword,
                'account_number' => 'ACC-99887766',
                'balance' => 50000000.00,
                'credit_score' => 100,
                'max_credit_limit' => 1000000.00,
            ]
        );

        // 3. بيانات التجار والمنتجات
        $merchantsData = [
            [
                'store_name' => 'المحضار للسيارات',
                'commercial_reg' => 'CR-2024-001',
                'bank_account_number' => 'BANK-01',
                'phone' => '770000001',
                'product_name' => 'تويوتا كامري 2024',
                'price' => 100000 // السعر الإجمالي
            ],
            [
                'store_name' => 'عالم الإلكترونيات',
                'commercial_reg' => 'CR-2024-002',
                'bank_account_number' => 'BANK-02',
                'phone' => '770000002',
                'product_name' => 'iPhone 15 Pro Max',
                'price' => 6000
            ]
        ];

        foreach ($merchantsData as $data) {
            // أ - إنشاء التاجر
            $merchant = Merchant::create([
                'store_name' => $data['store_name'],
                'commercial_reg' => $data['commercial_reg'],
                'bank_account_number' => $data['bank_account_number'],
                'phone' => $data['phone'],
                'bank_balance' => 0.00,
            ]);

            // ب - إنشاء المنتج
            $product = Product::create([
                'merchant_id' => $merchant->id,
                'product_name' => $data['product_name'],
                'description' => 'منتج متاح بنظام التقسيط الذكي',
                'price' => $data['price'],
                'allow_installment' => true,
                'image' => 'default.jpg',
            ]);

            // حسابات الطلب بناءً على الميجريشن الخاص بك
            $total = $data['price'];
            $downPayment = $total * 0.5; // الدفعة المقدمة 50%
            $remaining = $total - $downPayment; // المبلغ المتبقي
            $commission = $total * 0.03; // عمولة البنك 3%

            // ج - إنشاء الطلب (كل الحقول مطابقة للميجريشن الآن)
            $order = Order::create([
                'user_id'           => $user->id,
                'merchant_id'       => $merchant->id,
                'product_id'        => $product->id,
                'total_amount'      => $total,
                'down_payment'      => $downPayment,
                'remaining_amount'  => $remaining,
                'commission_amount' => $commission,
                'status'            => 'approved',
            ]);

            // د - إنشاء الأقساط (3 أقساط للمبلغ المتبقي)
            $installmentAmount = $remaining / 3;

            for ($i = 1; $i <= 3; $i++) {
                Installment::create([
                    'order_id' => $order->id,
                    'user_id'  => $user->id,
                    'amount'   => $installmentAmount,
                    'due_date' => Carbon::now()->addMonths($i),
                    'status'   => ($i == 1) ? 'paid' : 'pending',
                    'paid_at'  => ($i == 1) ? Carbon::now() : null,
                ]);
            }
        }
    }
}
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // العميل
            $table->foreignId('merchant_id')->constrained('merchants')->onDelete('cascade'); // التاجر
            $table->foreignId('product_id')->constrained('products')->onDelete('cascade'); // المنتج
            
            // التفاصيل المالية
            $table->decimal('total_amount', 15, 2); // القيمة الإجمالية
            $table->decimal('down_payment', 15, 2); // الـ 50% المدفوعة مقدماً
            $table->decimal('remaining_amount', 15, 2); // المبلغ المتبقي (ليتم تقسيطه)
            $table->decimal('commission_amount', 15, 2)->default(0.00); // عمولة النظام/البنك
            
            // حالة الطلب
            $table->enum('status', ['pending', 'approved', 'rejected', 'completed', 'cancelled'])->default('pending');
            
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('orders');
    }
};
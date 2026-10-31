<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('installments', function (Blueprint $table) {
            $table->id();
            // يتبع لطلب محدد
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade'); 
            // يتبع لمستخدم محدد (لتسهيل جلب الأقساط في Flutter)
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); 
            
            $table->decimal('amount', 15, 2); // مبلغ القسط الشهري بدقة عالية
            $table->date('due_date'); // تاريخ الاستحقاق
            $table->enum('status', ['pending', 'paid', 'late'])->default('pending'); // حالة القسط
            $table->timestamp('paid_at')->nullable(); // توثيق وقت السداد الفعلي
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('installments');
    }
};
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            // ربط العملية بالمستخدم لسهولة العرض في التطبيق
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); 
            
            // ربط العملية بالطلب (اختياري لكنه مفيد جداً للتدقيق)
            $table->foreignId('order_id')->nullable()->constrained()->onDelete('cascade');
            
            $table->string('type'); // 'down_payment', 'installment', 'refund'
            $table->decimal('amount', 15, 2); // زيادة الدقة لـ 15
            
            $table->string('from_party'); // مثل: 'User'
            $table->string('to_party');   // مثل: 'Merchant'
            
            // حقل المرجع (Reference) لربط العملية برقم القسط مثلاً
            $table->unsignedBigInteger('reference_id')->nullable(); 
            
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
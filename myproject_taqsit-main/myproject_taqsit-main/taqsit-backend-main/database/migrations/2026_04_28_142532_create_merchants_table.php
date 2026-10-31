<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('merchants', function (Blueprint $table) {
            $table->id();
            $table->string('store_name'); // اسم المتجر
            $table->string('commercial_reg')->unique(); // السجل التجاري
            $table->string('bank_account_number')->unique(); // حساب استلام الأموال
            $table->string('phone');
            
            // إضافة رصيد المتجر هنا لضمان استلام أموال المنتجات فوراً
            $table->decimal('bank_balance', 15, 2)->default(0.00); 
            
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('merchants');
    }
};
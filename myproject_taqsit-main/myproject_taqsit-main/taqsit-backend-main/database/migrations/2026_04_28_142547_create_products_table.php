<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            // ربط المنتج بالتاجر الذي يملكه
            $table->foreignId('merchant_id')->constrained('merchants')->onDelete('cascade'); 
            
            $table->string('product_name');
            $table->text('description')->nullable(); // وصف المنتج (مفيد للعرض في Flutter)
            $table->decimal('price', 15, 2); // سعر المنتج بدقة عالية
            
            // ميزة تحديد قابلية التقسيط
            $table->boolean('allow_installment')->default(true); 
            $table->string('image')->nullable(); // مسار صورة المنتج (اختياري)
            
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('products');
    }
};
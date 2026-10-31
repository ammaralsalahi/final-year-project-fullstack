<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
 public function up(): void
{
    Schema::create('banks', function (Blueprint $table) {
        $table->id();
        $table->string('identity_number')->unique();
        $table->string('full_name');
        $table->string('email')->unique();
        $table->string('phone_number')->unique();
        $table->string('password'); 
        $table->string('account_number')->unique();
        $table->decimal('balance', 15, 2)->default(10000.00);
        $table->integer('credit_score')->default(100);
        $table->decimal('max_credit_limit', 10, 2)->default(5000.00);
        $table->timestamps();

        // إضافة هذا السطر لضمان أن رقم الهاتف المسجل في البنك ينتمي لمستخدم موجود فعلياً
        $table->foreign('phone_number')->references('phone_number')->on('users')->onDelete('cascade');
    });
}
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('banks');
    }
};

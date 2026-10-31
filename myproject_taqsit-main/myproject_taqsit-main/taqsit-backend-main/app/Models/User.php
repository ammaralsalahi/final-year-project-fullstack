<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;

    protected $fillable = ['full_name', 'phone_number', 'password', 'address', 'is_active', 'is_blocked'];

    // لكي يرى تطبيق فلاتر البيانات المالية داخل اليوزر
    protected $appends = ['bank_balance', 'available_limit', 'trust_score'];

    // العلاقة مع جدول البنك (عبر رقم الهاتف)
    public function bank()
    {
        return $this->hasOne(Bank::class, 'phone_number', 'phone_number');
    }

    // Accessors لجلب البيانات من جدول البنك فوراً
    public function getBankBalanceAttribute() {
        return $this->bank ? $this->bank->balance : 0;
    }

    public function getAvailableLimitAttribute() {
        return $this->bank ? $this->bank->max_credit_limit : 0;
    }

    public function getTrustScoreAttribute() {
        return $this->bank ? $this->bank->credit_score : 0;
    }

    // علاقة المستخدم بالأقساط
    public function installments() {
        return $this->hasMany(Installment::class);
    }
}
<?php

namespace App\Models;

// 1. التعديل الأهم: استيراد فئة الـ Authenticatable
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;

class Bank extends Authenticatable // 2. تغيير الوراثة هنا لتصبح Authenticatable
{
    use HasFactory, Notifiable;

    protected $table = 'banks';

    protected $fillable = [
        'identity_number', 
        'full_name', 
        'email', 
        'phone_number', 
        'password', 
        'account_number', 
        'balance', 
        'credit_score', 
        'max_credit_limit'
    ];

    /**
     * أخبر لارافيل أن الحقل المسؤول عن كلمة السر هو password
     */
    public function getAuthPassword()
    {
        return $this->password;
    }

    /**
     * علاقتك مع جدول المستخدمين (العملاء) بناءً على رقم الهاتف
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'phone_number', 'phone_number');
    }
}
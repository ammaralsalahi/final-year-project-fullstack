<?php

namespace App\Models;

// 1. تغيير الاستيراد ليصبح Authenticatable بدلاً من Model العادي
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;

class Merchant extends Authenticatable // تغيير الوراثة هنا
{
    use HasFactory, Notifiable;

    protected $table = 'merchants'; // التأكد من اسم الجدول

    protected $fillable = [
        'store_name', 
        'commercial_reg', 
        'bank_account_number', 
        'phone', 
        'bank_balance'
    ];

    /**
     * أخبر لارافيل أن السجل التجاري هو بمثابة كلمة المرور للتحقق
     */
    public function getAuthPassword()
    {
        return $this->commercial_reg;
    }

    public function products() 
    { 
        return $this->hasMany(Product::class); 
    }
}
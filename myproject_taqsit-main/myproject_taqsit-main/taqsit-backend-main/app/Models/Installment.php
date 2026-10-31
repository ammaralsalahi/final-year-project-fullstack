<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Installment extends Model
{
    protected $fillable = [
        'order_id', 
        'user_id', 
        'amount', 
        'due_date', 
        'status', 
        'paid_at'
    ];

    // علاقة القسط بالطلب (أساسية جداً)
    public function order() { 
        return $this->belongsTo(Order::class); 
    }

    // علاقة القسط بالمستخدم (العميل الذي يدفع)
    public function user() { 
        return $this->belongsTo(User::class); 
    }

    // الوصول للمنتج عبر الطلب (الطريقة الأكثر دقة برمجياً)
    public function product()
    {
        return $this->hasOneThrough(
            Product::class, // الموديل الهدف
            Order::class,   // الموديل الوسيط
            'id',           // المفتاح الغريب في جدول Orders (يشير للقسط)
            'id',           // المفتاح الغريب في جدول Products
            'order_id',     // المفتاح المحلي في جدول Installments
            'product_id'    // المفتاح المحلي في جدول Orders
        );
    }
    
    // دالة مساعدة لمعرفة هل القسط متأخر (جميلة جداً للعرض في الواجهة)
    public function isOverdue() {
        return $this->due_date < now() && $this->status !== 'paid';
    }
}
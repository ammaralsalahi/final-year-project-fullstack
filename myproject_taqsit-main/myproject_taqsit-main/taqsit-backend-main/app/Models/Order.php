<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'user_id', 'merchant_id', 'product_id', 'total_amount', 
        'down_payment', 'remaining_amount', 'commission_amount', 'status'
    ];

    // العلاقات الأساسية
    public function user() { return $this->belongsTo(User::class); }
    public function merchant() { return $this->belongsTo(Merchant::class); }
    public function product() { return $this->belongsTo(Product::class); }
    
    // جلب الأقساط الخاصة بهذا الطلب
    public function installments() {
        return $this->hasMany(Installment::class);
    }

    // حالات الطلب (مفيد للمناقشة)
    public function scopePending($query) { return $query->where('status', 'pending'); }
    public function scopeApproved($query) { return $query->where('status', 'approved'); }
}
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Transaction extends Model {
    use HasFactory;

    protected $fillable = [
        'user_id', 
        'order_id', 
        'type', 
        'amount', 
        'from_party', 
        'to_party', 
        'reference_id'
    ];

    // علاقة المستخدم (موجودة لديك)
    public function user() { 
        return $this->belongsTo(User::class); 
    }

    // علاقة الطلب (هذه هي الدالة التي كانت تنقصك وتسببت في الخطأ 500)
    public function order() { 
        return $this->belongsTo(Order::class); 
    }
}
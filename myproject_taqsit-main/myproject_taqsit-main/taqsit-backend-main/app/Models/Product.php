<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Product extends Model {
    use HasFactory;

    // أضفنا 'image' هنا لكي يسمح النظام بحفظه
    protected $fillable = [
        'merchant_id', 
        'product_name', 
        'description', 
        'price', 
        'image', // <--- هذا هو الحقل الناقص
        'allow_installment'
    ];

    public function merchant() { 
        return $this->belongsTo(Merchant::class); 
    }
}
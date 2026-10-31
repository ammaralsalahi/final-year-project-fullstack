<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{PurchaseController, ProductController, MerchantController};
use App\Http\Controllers\Api\{InstallmentController, AuthController};

// مسارات عامة
Route::post('/login', [AuthController::class, 'login']);
Route::get('/products', [ProductController::class, 'getProductsForFlutter']);

// مسارات محمية
Route::middleware('auth:sanctum')->group(function () {
    // الشراء والأقساط
    Route::post('/purchase', [PurchaseController::class, 'purchase']);
    Route::get('/installments/{userId}', [InstallmentController::class, 'myInstallments']);
    Route::post('/installments/pay', [InstallmentController::class, 'payInstallment']);

    // التاجر وسجل الحركات
    Route::get('/merchant/orders', [MerchantController::class, 'getOrders']);
    Route::get('/user/transactions', [PurchaseController::class, 'getUserTransactions']);
    //التحقق من بيانات العميل بواسطة رقم الهويه 
Route::post('/check-eligibility', [PurchaseController::class, 'checkEligibility']);
    // الملف الشخصي المدمج مع بيانات البنك
    Route::get('/user/profile', function (Request $request) {
        return response()->json([
            'status' => 'success',
            'user' => $request->user(),
            'bank' => \App\Models\Bank::where('phone_number', $request->user()->phone_number)->first()
        ]);
    });
});
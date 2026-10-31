<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MerchantController;
use App\Http\Controllers\BankController;
use App\Http\Controllers\PurchaseController;

/*
|--------------------------------------------------------------------------
| الصفحة الرئيسية
|--------------------------------------------------------------------------
*/
// بدلاً من التوجيه لصفحة الـ login العامة، نوجه الزائر ليختار بوابته
Route::get('/', function () {
    return view('welcome'); // أو صفحة بسيطة فيها زر "أنا تاجر" وزر "أنا بنك"
});

/*
|--------------------------------------------------------------------------
| Authentication (بوابات الدخول)
|--------------------------------------------------------------------------
*/

// 1. بوابة البنك
Route::get('/bank/login', function () {
    return view('auth.bank_login');
})->name('bank.login.page');

// 2. بوابة التجار (دخول + إنشاء حساب)
Route::get('/merchant/login', function () {
    return view('auth.merchant_auth');
})->name('merchant.login.page');

// مسار معالجة تسجيل الدخول (مشترك لجميع البوابات كما برمجناه في الـ Controller)
Route::post('/login', [AuthController::class, 'login'])->name('login');

// مسار إنشاء حساب تاجر جديد
Route::post('/merchant/register', [MerchantController::class, 'register'])->name('merchant.register');

// تسجيل الخروج
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

use App\Http\Controllers\userController; // تأكد من اسم الكلاس

Route::get('/bank/create', [userController::class, 'create'])->name('banks.create');
Route::post('/bank/store', [userController::class, 'store'])->name('banks.store');
/*
|--------------------------------------------------------------------------
| Merchant Routes (لوحة تحكم التاجر)
|--------------------------------------------------------------------------
*/
Route::prefix('merchant')
    ->name('merchant.')
    ->middleware('auth:merchant')
    ->group(function () {

        // Dashboard
        Route::get('/dashboard', [MerchantController::class, 'index'])->name('dashboard');

        // Products (CRUD)
        Route::prefix('products')->name('products.')->group(function () {
            Route::get('/', [MerchantController::class, 'indexProducts'])->name('index');
            Route::post('/store', [MerchantController::class, 'storeProduct'])->name('store');
            Route::get('/edit/{id}', [MerchantController::class, 'editProduct'])->name('edit');
            Route::put('/update/{id}', [MerchantController::class, 'updateProduct'])->name('update');
            Route::delete('/delete/{id}', [MerchantController::class, 'destroyProduct'])->name('delete');
        });
    });

/*
|--------------------------------------------------------------------------
| Bank Routes (لوحة تحكم البنك)
|--------------------------------------------------------------------------
*/
Route::prefix('bank')
    ->name('bank.')
    ->middleware('auth:bank')
    ->group(function () {
        Route::get('/dashboard', [BankController::class, 'index'])->name('dashboard');
        Route::get('/reports', [BankController::class, 'reports'])->name('reports');
        // هذا هو المسار الجديد الخاص بالبحث
        Route::get('/search', [BankController::class, 'search'])->name('search'); 
    });
/*
|--------------------------------------------------------------------------
| Purchases (العملاء - عبر الـ Flutter أو الويب)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:bank')->group(function () {
    Route::post('/purchase', [PurchaseController::class, 'purchase'])->name('purchase.web');
});
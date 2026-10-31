<?php

use App\Models\User;
use App\Models\Merchant;
use App\Models\Bank;

return [

    'defaults' => [
        'guard' => env('AUTH_GUARD', 'web'),
        'passwords' => env('AUTH_PASSWORD_BROKER', 'users'),
    ],

    'guards' => [
        // 1. الحارس الافتراضي (للعملاء فقط - جدول users)
        'web' => [
            'driver' => 'session',
            'provider' => 'users',
        ],

        // 2. حارس التجار (جدول merchants)
        'merchant' => [
            'driver' => 'session',
            'provider' => 'merchants',
        ],

        // --- التعديل الجديد: إضافة حارس البنك ---
        'bank' => [
            'driver' => 'session',
            'provider' => 'banks',
        ],
    ],

    'providers' => [
        // مزود بيانات العملاء
        'users' => [
            'driver' => 'eloquent',
            'model' => env('AUTH_MODEL', User::class),
        ],

        // مزود بيانات التجار
        'merchants' => [
            'driver' => 'eloquent',
            'model' => Merchant::class,
        ],

        // --- التعديل الجديد: إضافة مزود بيانات البنك ---
        'banks' => [
            'driver' => 'eloquent',
            'model' => Bank::class,
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table' => env('AUTH_PASSWORD_RESET_TOKEN_TABLE', 'password_reset_tokens'),
            'expire' => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => env('AUTH_PASSWORD_TIMEOUT', 10800),

];
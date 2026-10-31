@extends('layout.app')
@section('title', 'تسجيل الدخول')
@section('content')
<div class="flex flex-col md:flex-row gap-8 justify-center items-stretch mt-10">
    <!-- بطاقة البنك -->
    <div class="bg-white shadow-2xl rounded-2xl p-8 border-t-4 border-blue-600 w-full max-w-md">
        <h2 class="text-2xl font-bold text-slate-800 mb-6 text-center">دخول إدارة البنك</h2>
        <form action="{{ url('/login') }}" method="POST" class="space-y-4">
            @csrf
            <div>
                <label class="block text-sm font-medium text-gray-700">البريد الإلكتروني</label>
                <input type="email" name="email" class="w-full mt-1 p-3 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="admin@bank.com">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">كلمة المرور</label>
                <input type="password" name="password" class="w-full mt-1 p-3 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-xl font-bold hover:bg-blue-700 transition shadow-lg">دخول النظام</button>
        </form>
    </div>

    <!-- بطاقة التاجر -->
    <div class="bg-white shadow-2xl rounded-2xl p-8 border-t-4 border-emerald-500 w-full max-w-md">
        <h2 class="text-2xl font-bold text-slate-800 mb-6 text-center">دخول مركز التجار</h2>
        <form action="{{ url('/login') }}" method="POST" class="space-y-4">
            @csrf
            <div>
                <label class="block text-sm font-medium text-gray-700">اسم المتجر</label>
                <input type="text" name="store_name" class="w-full mt-1 p-3 border rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">رقم السجل التجاري</label>
                <input type="text" name="commercial_reg" class="w-full mt-1 p-3 border rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none">
            </div>
            <button type="submit" class="w-full bg-emerald-600 text-white py-3 rounded-xl font-bold hover:bg-emerald-700 transition shadow-lg">دخول التاجر</button>
        </form>
    </div>
</div>
@endsection
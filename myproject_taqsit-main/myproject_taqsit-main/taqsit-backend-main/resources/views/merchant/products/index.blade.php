@extends('layout.merchant')

@section('title', 'إدارة المنتجات')

@section('content')

<div class="max-w-7xl mx-auto space-y-8">

    <!-- Navigation -->
    <div class="flex items-center gap-3">

        <a href="{{ route('merchant.dashboard') }}"
           class="bg-slate-900 text-white px-5 py-3 rounded-2xl font-bold hover:bg-slate-800 transition">
            🏠 لوحة التحكم
        </a>

    </div>

    <!-- Header -->
    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">

        <div>
            <h1 class="text-4xl font-black text-slate-800">
                إدارة المنتجات
            </h1>

            <p class="text-slate-500 mt-2">
                إضافة وتعديل وحذف منتجات المتجر
            </p>
        </div>

    </div>

    <!-- Add Product Form -->
    <div class="bg-white rounded-[32px] shadow-2xl border border-slate-100 overflow-hidden">

        <div class="bg-gradient-to-r from-slate-900 to-slate-800 p-6">
            <h2 class="text-2xl font-black text-white">
                إضافة منتج جديد
            </h2>
        </div>

        <form action="{{ route('merchant.products.store') }}"
              method="POST"
              enctype="multipart/form-data"
              class="p-6 grid grid-cols-1 md:grid-cols-2 gap-4">

            @csrf

            <input type="text" name="product_name"
                   placeholder="اسم المنتج"
                   class="p-4 rounded-2xl border">

            <input type="number" name="price"
                   placeholder="السعر"
                   class="p-4 rounded-2xl border">

            <textarea name="description"
                      class="md:col-span-2 p-4 rounded-2xl border"
                      placeholder="الوصف"></textarea>

            <input type="file" name="image"
                   class="md:col-span-2">

            <label class="flex items-center gap-2 md:col-span-2">
                <input type="checkbox" name="allow_installment" value="1" checked>
                السماح بالتقسيط
            </label>

            <button class="md:col-span-2 bg-emerald-600 text-white p-4 rounded-2xl font-bold hover:bg-emerald-700 transition">
                حفظ المنتج
            </button>

        </form>

    </div>

    <!-- Products List -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">

        @forelse($products as $product)

        <div class="bg-white rounded-3xl shadow-xl overflow-hidden">

            <img src="{{ asset('images/' . ($product->image ?? 'default.jpg')) }}"
                 class="h-52 w-full object-cover">

            <div class="p-5 space-y-3">

                <h3 class="font-black text-xl">
                    {{ $product->product_name }}
                </h3>

                <p class="text-slate-500">
                    {{ $product->description }}
                </p>

                <div class="flex justify-between items-center">

                    <span class="font-black text-blue-700">
                        {{ number_format($product->price) }} ر.ي
                    </span>

                    <div class="flex gap-3">

                        <a href="{{ route('merchant.products.edit', $product->id) }}"
                           class="text-amber-600 font-bold hover:underline">
                            تعديل
                        </a>

                        <form method="POST"
                              action="{{ route('merchant.products.delete', $product->id) }}">

                            @csrf
                            @method('DELETE')

                            <button onclick="return confirm('هل أنت متأكد من حذف المنتج؟')"
                                    class="text-red-500 font-bold hover:underline">
                                حذف
                            </button>

                        </form>

                    </div>

                </div>

            </div>

        </div>

        @empty

        <div class="col-span-3 text-center text-slate-400 py-10">
            لا توجد منتجات حالياً
        </div>

        @endforelse

    </div>

</div>

@endsection
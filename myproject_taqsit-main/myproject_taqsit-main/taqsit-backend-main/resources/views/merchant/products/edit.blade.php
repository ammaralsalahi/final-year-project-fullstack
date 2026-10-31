@extends('layout.merchant')

@section('title', 'تعديل المنتج')

@section('content')

<div class="max-w-3xl mx-auto bg-white p-8 rounded-3xl shadow-xl space-y-6">

    <h1 class="text-3xl font-black text-slate-800">
        تعديل المنتج
    </h1>

    <form action="{{ route('merchant.products.update', $product->id) }}"
          method="POST"
          enctype="multipart/form-data"
          class="space-y-5">

        @csrf
        @method('PUT')

        <input type="text"
               name="product_name"
               value="{{ $product->product_name }}"
               class="w-full p-4 border rounded-2xl">

        <input type="number"
               name="price"
               value="{{ $product->price }}"
               class="w-full p-4 border rounded-2xl">

        <textarea name="description"
                  class="w-full p-4 border rounded-2xl">{{ $product->description }}</textarea>

        <div class="flex items-center gap-4">

            <img src="{{ asset('images/' . ($product->image ?? 'default.jpg')) }}"
                 class="w-20 h-20 rounded-xl object-cover">

            <input type="file" name="image">

        </div>

        <label class="flex items-center gap-2">
            <input type="checkbox"
                   name="allow_installment"
                   value="1"
                   {{ $product->allow_installment ? 'checked' : '' }}>
            تقسيط
        </label>

        <div class="flex gap-4">

            <button class="flex-1 bg-slate-900 text-white p-4 rounded-2xl font-bold">
                تحديث
            </button>

            <a href="{{ route('merchant.products.index') }}"
               class="flex-1 bg-gray-100 p-4 rounded-2xl text-center font-bold">
                إلغاء
            </a>

        </div>

    </form>

</div>

@endsection
@extends('layout.app')

@section('title', 'لوحة التحكم - ' . Auth::guard('merchant')->user()->store_name)

@section('content')

<div class="space-y-8">

    <!-- Header -->
    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">

        <div>
            <h1 class="text-4xl font-black text-slate-800">
                لوحة تحكم التاجر
            </h1>

            <p class="text-slate-500 mt-2">
                إدارة المبيعات بالتقسيط ومتابعة الطلبات المالية
            </p>
        </div>

        <!-- Navigation (FIXED) -->
        <div class="flex items-center gap-3">

            <!-- Dashboard -->
            <a href="{{ route('merchant.dashboard') }}"
               class="bg-slate-900 text-white px-5 py-3 rounded-2xl font-bold shadow-lg hover:bg-slate-800 transition">
                🏪 لوحة التاجر
            </a>

            <!-- Products Page -->
            <a href="{{ route('merchant.products.index') }}"
               class="bg-white border border-slate-200 hover:border-blue-500 hover:text-blue-600 transition px-5 py-3 rounded-2xl font-bold shadow-sm text-slate-700">
                📦 إدارة المنتجات
            </a>

        </div>

    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">

        <!-- Store Info -->
        <div class="bg-gradient-to-br from-slate-900 to-slate-800 p-7 rounded-3xl text-white shadow-2xl">

            <div class="flex items-start justify-between">

                <div>
                    <p class="text-slate-400 font-semibold">
                        اسم المتجر
                    </p>

                    <h3 class="text-3xl font-black mt-3">
                        {{ Auth::guard('merchant')->user()->store_name }}
                    </h3>

                    <p class="text-sm mt-4 text-emerald-400 font-bold">
                        الرصيد البنكي:
                        {{ number_format(Auth::guard('merchant')->user()->bank_balance, 2) }} ر.ي
                    </p>
                </div>

                <div class="text-5xl opacity-20">
                    🏪
                </div>

            </div>

        </div>

        <!-- Commercial Register -->
        <div class="bg-white p-7 rounded-3xl shadow-xl border border-slate-100">

            <div class="flex items-start justify-between">

                <div>
                    <p class="text-slate-500 font-bold text-sm">
                        السجل التجاري
                    </p>

                    <h3 class="text-2xl font-black text-slate-800 uppercase mt-3 break-all">
                        {{ Auth::guard('merchant')->user()->commercial_reg }}
                    </h3>
                </div>

                <div class="text-5xl opacity-10">
                    📄
                </div>

            </div>

        </div>

        <!-- Orders Count -->
        <div class="bg-gradient-to-br from-blue-600 to-blue-800 p-7 rounded-3xl text-white shadow-2xl">

            <div class="flex items-start justify-between">

                <div>

                    <p class="text-blue-100 font-semibold">
                        إجمالي الطلبات
                    </p>

                    <h3 class="text-4xl font-black mt-3">
                        {{ $myOrders->count() }}
                    </h3>

                </div>

                <div class="text-5xl opacity-20">
                    📊
                </div>

            </div>

        </div>

    </div>

    <!-- Sales Table -->
    <div id="sales"
         class="bg-white rounded-[30px] shadow-2xl border border-slate-100 overflow-hidden">

        <!-- Header -->
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5 p-8 border-b border-slate-100">

            <div>
                <h2 class="text-3xl font-black text-slate-800">
                    سجل مبيعات التقسيط
                </h2>

                <p class="text-slate-500 mt-2">
                    جميع عمليات التقسيط الخاصة بمتجرك
                </p>
            </div>

        </div>

        <!-- Table -->
        <div class="overflow-x-auto">

            <table class="w-full">

                <thead class="bg-slate-100">

                    <tr class="text-right text-slate-600 text-sm uppercase">

                        <th class="p-6 font-black">العميل</th>
                        <th class="p-6 font-black">المنتج</th>
                        <th class="p-6 font-black">الإجمالي</th>
                        <th class="p-6 font-black">المتبقي</th>
                        <th class="p-6 font-black">الحالة</th>

                    </tr>

                </thead>

                <tbody class="divide-y divide-slate-100">

                    @forelse($myOrders as $order)

                    <tr class="hover:bg-blue-50 transition">

                        <td class="p-6 font-bold text-slate-800">
                            {{ $order->user->full_name }}
                        </td>

                        <td class="p-6 text-blue-700 font-bold">
                            {{ $order->product->product_name }}
                        </td>

                        <td class="p-6 font-black">
                            {{ number_format($order->total_amount, 2) }} ر.ي
                        </td>

                        <td class="p-6 text-red-600 font-black">
                            {{ number_format($order->remaining_amount, 2) }} ر.ي
                        </td>

                        <td class="p-6">

                            @if($order->status == 'approved')

                                <span class="bg-emerald-100 text-emerald-700 px-3 py-1 rounded-full text-xs font-black">
                                    معتمد
                                </span>

                            @elseif($order->status == 'rejected')

                                <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-black">
                                    مرفوض
                                </span>

                            @else

                                <span class="bg-amber-100 text-amber-700 px-3 py-1 rounded-full text-xs font-black">
                                    قيد الانتظار
                                </span>

                            @endif

                        </td>

                    </tr>

                    @empty

                    <tr>
                        <td colspan="5" class="p-10 text-center text-slate-400">
                            لا توجد مبيعات حالياً
                        </td>
                    </tr>

                    @endforelse

                </tbody>

            </table>

        </div>

    </div>

</div>

@endsection
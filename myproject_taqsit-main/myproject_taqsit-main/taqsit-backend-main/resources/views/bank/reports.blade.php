@extends('layout.app')

@section('title', 'تقارير البنك')

@section('content')

<div class="space-y-8">

    <!-- Top Navigation -->
    <div class="flex flex-wrap items-center justify-between gap-4">

        <div>
            <h1 class="text-4xl font-black text-slate-800">
                تقارير البنك
            </h1>

            <p class="text-slate-500 mt-2">
                مراقبة شاملة لجميع العمليات المالية والتمويلات
            </p>
        </div>

        <!-- Navigation Buttons -->
        <div class="flex items-center gap-3">

            <a href="{{ route('bank.dashboard') }}"
               class="bg-white border border-slate-200 hover:border-blue-500 hover:text-blue-600 transition px-5 py-3 rounded-2xl font-bold shadow-sm text-slate-700">
                🏠 لوحة التحكم
            </a>

            <a href="{{ route('bank.reports') }}"
               class="bg-blue-600 hover:bg-blue-700 transition text-white px-5 py-3 rounded-2xl font-bold shadow-lg">
                📊 التقارير
            </a>

        </div>
    </div>

    <!-- Main Card -->
    <div class="bg-white rounded-[30px] shadow-2xl border border-slate-100 overflow-hidden">

        <!-- Header -->
        <div class="bg-gradient-to-r from-slate-900 to-slate-800 p-8">

            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">

                <div>
                    <h2 class="text-3xl font-black text-white">
                        سجل العمليات المالية
                    </h2>

                    <p class="text-slate-400 mt-2">
                        عرض تفصيلي لتدفق الأموال بين العملاء والتجار
                    </p>
                </div>

                <button
                    onclick="window.print()"
                    class="bg-emerald-500 hover:bg-emerald-600 transition text-white px-6 py-3 rounded-2xl font-bold shadow-xl"
                >
                    🖨️ طباعة التقارير
                </button>

            </div>
        </div>

        <!-- Filters -->
        <div class="p-6 bg-slate-50 border-b border-slate-200">

            <form action="" method="GET"
                  class="grid grid-cols-1 md:grid-cols-3 gap-4">

                <!-- Merchant Filter -->
                <div>

                    <label class="block text-sm font-bold text-slate-600 mb-2">
                        التاجر
                    </label>

                    <select
                        name="merchant_id"
                        class="w-full p-4 rounded-2xl border border-slate-200 bg-white outline-none focus:ring-4 focus:ring-blue-100 focus:border-blue-500 transition"
                    >
                        <option value="">جميع التجار</option>

                        @foreach($merchants as $merchant)

                            <option value="{{ $merchant->id }}">
                                {{ $merchant->store_name }}
                            </option>

                        @endforeach

                    </select>

                </div>

                <!-- Status Filter -->
                <div>

                    <label class="block text-sm font-bold text-slate-600 mb-2">
                        حالة القسط
                    </label>

                    <select
                        name="status"
                        class="w-full p-4 rounded-2xl border border-slate-200 bg-white outline-none focus:ring-4 focus:ring-blue-100 focus:border-blue-500 transition"
                    >
                        <option value="">كل الحالات</option>
                        <option value="paid">مكتمل</option>
                        <option value="pending">قيد الانتظار</option>
                        <option value="late">متعثر</option>
                    </select>

                </div>

                <!-- Submit -->
                <div class="flex items-end">

                    <button
                        type="submit"
                        class="w-full bg-slate-900 hover:bg-slate-800 transition text-white py-4 rounded-2xl font-bold shadow-lg"
                    >
                        🔍 تصفية النتائج
                    </button>

                </div>

            </form>
        </div>

        <!-- Table -->
        <div class="overflow-x-auto">

            <table class="w-full">

                <thead class="bg-slate-100">

                    <tr class="text-right text-slate-600 text-sm uppercase">

                        <th class="p-6 font-black">
                            تاريخ الاستحقاق
                        </th>

                        <th class="p-6 font-black">
                            التاجر المستفيد
                        </th>

                        <th class="p-6 font-black">
                            العميل
                        </th>

                        <th class="p-6 font-black">
                            مبلغ القسط
                        </th>

                        <th class="p-6 font-black">
                            عمولة البنك
                        </th>

                        <th class="p-6 font-black">
                            حالة المخاطر
                        </th>

                    </tr>

                </thead>

                <tbody class="divide-y divide-slate-100">

                    @forelse($installments as $installment)

                    <tr class="hover:bg-blue-50 transition duration-200">

                        <!-- Due Date -->
                        <td class="p-6 text-sm text-slate-600 whitespace-nowrap">

                            {{ $installment->due_date
                                ? \Carbon\Carbon::parse($installment->due_date)->format('Y/m/d')
                                : 'غير محدد'
                            }}

                        </td>

                        <!-- Merchant -->
                        <td class="p-6">

                            <div class="flex items-center gap-3">

                                <div class="w-11 h-11 rounded-2xl bg-blue-100 flex items-center justify-center">
                                    🏪
                                </div>

                                <div class="font-bold text-slate-800">

                                    {{ $installment->order->product->merchant->store_name ?? 'تاجر غير مسجل' }}

                                </div>

                            </div>

                        </td>

                        <!-- Customer -->
                        <td class="p-6 text-slate-700 font-semibold">

                            {{ $installment->user->full_name ?? 'عميل غير معروف' }}

                        </td>

                        <!-- Amount -->
                        <td class="p-6">

                            <span class="font-black text-lg text-blue-900">

                                {{ number_format($installment->amount, 2) }} ر.ي

                            </span>

                        </td>

                        <!-- Commission -->
                        <td class="p-6">

                            <span class="bg-emerald-100 text-emerald-700 px-4 py-2 rounded-full text-sm font-black">

                                +{{ number_format($installment->amount * 0.03, 2) }} ر.ي

                            </span>

                        </td>

                        <!-- Status -->
                        <td class="p-6">

                            @if($installment->status == 'late')

                                <span class="bg-red-100 text-red-700 px-4 py-2 rounded-full text-xs font-black">
                                    ⚠️ عالي المخاطر
                                </span>

                            @elseif($installment->status == 'paid')

                                <span class="bg-emerald-100 text-emerald-700 px-4 py-2 rounded-full text-xs font-black">
                                    ✅ آمن
                                </span>

                            @else

                                <span class="bg-blue-100 text-blue-700 px-4 py-2 rounded-full text-xs font-black">
                                    ⏳ قيد السداد
                                </span>

                            @endif

                        </td>

                    </tr>

                    @empty

                    <tr>

                        <td colspan="6" class="p-16 text-center">

                            <div class="flex flex-col items-center gap-4">

                                <div class="text-6xl opacity-40">
                                    📭
                                </div>

                                <div>

                                    <h3 class="text-xl font-black text-slate-700">
                                        لا توجد عمليات مالية
                                    </h3>

                                    <p class="text-slate-400 mt-2">
                                        لم يتم العثور على أي بيانات حالياً
                                    </p>

                                </div>

                            </div>

                        </td>

                    </tr>

                    @endforelse

                </tbody>

            </table>

        </div>

    </div>

</div>

@endsection
@extends('layout.app')

@section('title', 'لوحة تحكم البنك')

@section('content')
@if(session('error'))
    <div class="bg-red-50 border border-red-200 text-red-700 px-5 py-4 rounded-2xl mb-4 text-right flex items-center gap-3 shadow-sm">
        <span class="text-xl">⚠️</span>
        <span class="font-medium text-sm">{{ session('error') }}</span>
    </div>
@endif
<div class="space-y-8">

    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-4xl font-black text-slate-800">
                نظام الرقابة الائتمانية
            </h1>
            <p class="text-slate-500 mt-2">
                متابعة التمويلات والأقساط والتجار المعتمدين
            </p>
        </div>

        <div class="flex items-center gap-3">
            <button class="bg-blue-600 hover:bg-blue-700 transition text-white px-5 py-3 rounded-2xl shadow-lg font-bold">
                + إنشاء تقرير
            </button>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6">

        <!-- Total Financed -->
        <div class="bg-gradient-to-br from-blue-700 to-blue-900 text-white p-6 rounded-3xl shadow-2xl hover:scale-[1.02] transition duration-300">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-blue-100 font-semibold">
                        إجمالي المبالغ الممولة
                    </p>

                    <h3 class="text-3xl font-black mt-3">
                        {{ number_format($total_financed) }}
                    </h3>

                    <span class="text-sm text-blue-200">
                        ريال يمني
                    </span>
                </div>

                <div class="text-5xl opacity-20">
                    💰
                </div>
            </div>
        </div>

        <!-- Pending -->
        <div class="bg-gradient-to-br from-amber-400 to-orange-500 text-white p-6 rounded-3xl shadow-2xl hover:scale-[1.02] transition duration-300">
            <div class="flex items-center justify-between">
                <div>
                    <p class="font-semibold text-orange-100">
                        مبالغ قيد الانتظار
                    </p>

                    <h3 class="text-3xl font-black mt-3">
                        {{ number_format($total_pending) }}
                    </h3>

                    <span class="text-sm text-orange-100">
                        ريال يمني
                    </span>
                </div>

                <div class="text-5xl opacity-20">
                    ⏳
                </div>
            </div>
        </div>

        <!-- Merchants -->
        <div class="bg-gradient-to-br from-emerald-500 to-emerald-700 text-white p-6 rounded-3xl shadow-2xl hover:scale-[1.02] transition duration-300">
            <div class="flex items-center justify-between">
                <div>
                    <p class="font-semibold text-emerald-100">
                        التجار المعتمدون
                    </p>

                    <h3 class="text-3xl font-black mt-3">
                        {{ $merchants->count() }}
                    </h3>

                    <span class="text-sm text-emerald-100">
                        تاجر
                    </span>
                </div>

                <div class="text-5xl opacity-20">
                    🏪
                </div>
            </div>
        </div>

        <!-- Late Payments -->
        <div class="bg-gradient-to-br from-red-500 to-rose-700 text-white p-6 rounded-3xl shadow-2xl hover:scale-[1.02] transition duration-300">
            <div class="flex items-center justify-between">
                <div>
                    <p class="font-semibold text-red-100">
                        الأقساط المتأخرة
                    </p>

                    <h3 class="text-3xl font-black mt-3">
                        {{ $late_payments_count }}
                    </h3>

                    <span class="text-sm text-red-100">
                        حالة
                    </span>
                </div>

                <div class="text-5xl opacity-20">
                    ⚠️
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">

        <!-- Latest Installments -->
        <div class="xl:col-span-2 bg-white rounded-3xl shadow-xl border border-slate-100 overflow-hidden">

            <div class="flex items-center justify-between p-6 border-b border-slate-100">
                <div>
                    <h2 class="text-2xl font-black text-slate-800">
                        أحدث التمويلات
                    </h2>

                    <p class="text-slate-500 text-sm mt-1">
                        آخر عمليات التقسيط المضافة للنظام
                    </p>
                </div>

                <a href="{{ route('bank.reports') }}"
                   class="text-blue-600 hover:text-blue-800 font-bold text-sm">
                    عرض الكل
                </a>
            </div>

            <div class="divide-y divide-slate-100">

                @forelse($installments->take(5) as $installment)

                <div class="p-6 hover:bg-slate-50 transition">

                    <div class="flex items-center justify-between">

                        <div class="flex items-center gap-4">

                            <div class="w-14 h-14 rounded-2xl bg-blue-100 flex items-center justify-center text-2xl">
                                📦
                            </div>

                            <div>
                                <h3 class="font-black text-slate-800 text-lg">
                                    {{ $installment->product->product_name ?? 'تمويل عام' }}
                                </h3>

                                <p class="text-slate-500 text-sm mt-1">
                                    العميل:
                                    {{ $installment->user->name ?? 'غير معروف' }}
                                </p>
                            </div>
                        </div>

                        <div class="text-left">

                            <h3 class="font-black text-xl text-slate-800">
                                {{ number_format($installment->amount) }} ر.ي
                            </h3>

                            @if($installment->status == 'late')

                                <span class="inline-block mt-2 bg-red-100 text-red-700 text-xs px-4 py-2 rounded-full font-bold">
                                    متأخر
                                </span>

                            @elseif($installment->status == 'paid')

                                <span class="inline-block mt-2 bg-emerald-100 text-emerald-700 text-xs px-4 py-2 rounded-full font-bold">
                                    مدفوع
                                </span>

                            @else

                                <span class="inline-block mt-2 bg-blue-100 text-blue-700 text-xs px-4 py-2 rounded-full font-bold">
                                    بانتظار القسط
                                </span>

                            @endif

                        </div>
                    </div>
                </div>

                @empty

                <div class="p-10 text-center">
                    <p class="text-slate-500">
                        لا توجد بيانات تمويل حالياً
                    </p>
                </div>

                @endforelse

            </div>
        </div>

        <!-- Quick Search -->
     <div class="card mb-4 border-0 shadow-sm" style="border-radius: 12px; background-color: #ffffff;">
    <div class="card-body p-4">
       <form action="{{ route('bank.search') }}" method="GET" class="space-y-5">
    <div class="relative">
        <input
            type="text"
            name="query"
            required
            placeholder="أدخل اسم، أو هاتف العميل/التاجر..."
            class="w-full bg-slate-50 border border-slate-200 rounded-2xl p-4 pr-12 outline-none focus:ring-4 focus:ring-blue-100 focus:border-blue-500 transition"
        >
        <span class="absolute right-4 top-4 text-xl text-slate-400">
            🔍
        </span>
    </div>

    <button
        type="submit"
        class="w-full bg-slate-900 hover:bg-slate-800 transition text-white py-4 rounded-2xl font-bold shadow-lg"
    >
        تنفيذ البحث
    </button>
</form>
    </div>
</div>            <!-- Info Box -->
            <div class="mt-8 bg-blue-50 border border-blue-100 rounded-2xl p-5">

                <div class="flex items-start gap-3">

                    <div class="text-2xl">
                        ℹ️
                    </div>

                    <p class="text-sm text-blue-900 leading-relaxed">
                        يمكنك كمدير للبنك الاطلاع على السجل الائتماني
                        لأي مستخدم قبل الموافقة على طلبات التقسيط الجديدة.
                    </p>

                </div>
            </div>

        </div>

    </div>
</div>

@endsection
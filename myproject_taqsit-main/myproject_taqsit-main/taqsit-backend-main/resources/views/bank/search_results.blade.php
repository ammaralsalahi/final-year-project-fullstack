@extends('layout.app')

@section('title', 'نتائج البحث والطباعة')

@section('content')

<div class="space-y-8">
    <div class="print:hidden flex justify-between items-center bg-white p-4 rounded-2xl shadow-sm border border-slate-100">
        <a href="{{ route('bank.dashboard') }}" class="text-slate-500 hover:text-slate-800 font-bold transition">
            &rarr; العودة للوحة التحكم
        </a>
        <button onclick="window.print()" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-xl font-bold shadow-lg transition flex items-center gap-2">
            🖨️ طباعة التقرير
        </button>
    </div>

    <div class="bg-white rounded-3xl shadow-xl border border-slate-100 overflow-hidden p-8 print:shadow-none print:border-none print:p-0">
        
        <div class="text-center border-b-2 border-slate-200 pb-6 mb-6">
            <h1 class="text-3xl font-black text-slate-800">تقرير كشف حساب</h1>
            <p class="text-slate-500 mt-2">تاريخ الإصدار: {{ now()->format('Y/m/d') }}</p>
        </div>

        <div class="bg-slate-50 rounded-2xl p-6 mb-8 border border-slate-100">
            <h2 class="text-xl font-bold text-slate-800 mb-4 border-b border-slate-200 pb-2">
                بيانات {{ $type == 'user' ? 'العميل' : 'التاجر' }}
            </h2>
            <div class="grid grid-cols-2 gap-4 text-slate-700">
                @if($type == 'user')
                    <p><strong>الاسم:</strong> {{ $data->full_name }}</p>
                    <p><strong>رقم الهاتف:</strong> {{ $data->phone_number }}</p>
                    <p><strong>حالة الحساب:</strong> {{ $data->is_active ? 'نشط' : 'غير نشط' }}</p>
                @else
                    <p><strong>اسم المتجر:</strong> {{ $data->store_name }}</p>
                    <p><strong>السجل التجاري:</strong> {{ $data->commercial_reg }}</p>
                    <p><strong>رقم الهاتف:</strong> {{ $data->phone }}</p>
                @endif
            </div>
        </div>

        <h2 class="text-xl font-bold text-slate-800 mb-4">السجل المالي والأقساط</h2>
        <div class="overflow-x-auto border border-slate-200 rounded-xl">
            <table class="w-full text-right">
                <thead class="bg-slate-100 text-slate-700 font-bold">
                    <tr>
                        <th class="p-4 border-b border-slate-200">المنتج</th>
                        <th class="p-4 border-b border-slate-200">الطرف الآخر</th>
                        <th class="p-4 border-b border-slate-200">تاريخ الاستحقاق</th>
                        <th class="p-4 border-b border-slate-200">المبلغ</th>
                        <th class="p-4 border-b border-slate-200">الحالة</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 text-slate-600">
                    @forelse($installments as $inst)
                        <tr>
                            <td class="p-4 font-bold">{{ $inst->product->product_name ?? 'غير معروف' }}</td>
                            <td class="p-4">
                                {{ $type == 'user' ? ($inst->product->merchant->store_name ?? 'غير معروف') : ($inst->user->full_name ?? 'غير معروف') }}
                            </td>
                            <td class="p-4">{{ $inst->due_date ? \Carbon\Carbon::parse($inst->due_date)->format('Y/m/d') : '-' }}</td>
                            <td class="p-4 font-bold text-slate-800">{{ number_format($inst->amount) }} ر.ي</td>
                            <td class="p-4">
                                @if($inst->status == 'paid') <span class="text-emerald-600 font-bold">مدفوع</span>
                                @elseif($inst->status == 'late') <span class="text-red-600 font-bold">متأخر</span>
                                @else <span class="text-blue-600 font-bold">قيد الانتظار</span>
                                @endif
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="p-8 text-center text-slate-400">لا توجد عمليات مالية مسجلة.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>

@endsection
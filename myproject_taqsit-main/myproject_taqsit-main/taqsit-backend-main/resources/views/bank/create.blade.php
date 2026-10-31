<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>إضافة عميل جديد</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 py-10">

    <div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
        <h2 class="text-2xl font-bold mb-6 text-gray-800">إضافة عميل جديد</h2>
        
        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-4 mb-4 rounded">{{ session('success') }}</div>
        @endif
        @if ($errors->any())
    <div class="bg-red-100 text-red-700 p-4 mb-4 rounded border border-red-200">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

        @if ($errors->any())
            <div class="bg-red-100 text-red-700 p-4 mb-4 rounded border border-red-200">
                <ul class="list-disc list-inside">
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        <form action="{{ route('banks.store') }}" method="POST">
            @csrf
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-medium mb-1">الاسم الكامل</label>
                    <input type="text" name="full_name" value="{{ old('full_name') }}" class="w-full border p-2 rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">رقم الهوية</label>
                    <input type="text" name="identity_number" value="{{ old('identity_number') }}" class="w-full border p-2 rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">البريد الإلكتروني</label>
                    <input type="email" name="email" value="{{ old('email') }}" class="w-full border p-2 rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">رقم الهاتف</label>
                    <input type="text" name="phone_number" value="{{ old('phone_number') }}" class="w-full border p-2 rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">الرصيد النقدي</label>
                    <input type="number" step="0.01" name="balance" value="{{ old('balance') }}" class="w-full border p-2 rounded" required>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">الحد الائتماني</label>
                    <input type="number" step="0.01" name="max_credit_limit" value="{{ old('max_credit_limit') }}" class="w-full border p-2 rounded" required>
                </div>
                <div class="col-span-2">
                    <label class="block text-sm font-medium mb-1">كلمة المرور</label>
                    <input type="password" name="password" class="w-full border p-2 rounded" required>
                </div>
            </div>
            <button type="submit" class="mt-6 bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 w-full md:w-auto">حفظ العميل</button>
        </form>
    </div>

</body>
</html>
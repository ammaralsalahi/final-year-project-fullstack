<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>نظام التقسيط الذكي - @yield('title')</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Cairo', sans-serif; background-color: #f8fafc; }
    </style>
</head>
<body>
    <nav class="bg-slate-900 text-white shadow-lg p-4">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-xl font-bold text-blue-400">Smart Installment</h1>
            <form action="{{ route('logout') }}" method="POST">
                @csrf
                <button class="bg-red-500 hover:bg-red-600 px-4 py-2 rounded-lg text-sm transition">تسجيل الخروج</button>
            </form>
        </div>
    </nav>

    <main class="container mx-auto p-6">
        @yield('content')
    </main>
</body>
</html>
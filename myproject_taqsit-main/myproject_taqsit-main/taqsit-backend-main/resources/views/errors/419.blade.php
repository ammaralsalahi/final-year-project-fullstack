<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>انتهت الجلسة - 419</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Cairo', sans-serif; }
    </style>
</head>
<body class="bg-slate-50 flex items-center justify-center h-screen">
    <div class="text-center p-8 max-w-lg">
        <!-- أيقونة الساعة للتعبير عن الوقت المستنفذ -->
        <div class="inline-flex items-center justify-center w-24 h-24 bg-amber-100 text-amber-600 rounded-full mb-6">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
        
        <h1 class="text-6xl font-black text-slate-800 mb-4">419</h1>
        <h2 class="text-2xl font-bold text-slate-700 mb-4">انتهت صلاحية الصفحة</h2>
        <p class="text-gray-500 mb-8 leading-relaxed">
            عذراً، يبدو أنك قضيت وقتاً طويلاً دون نشاط، أو تم إرسال البيانات بشكل غير آمن. يرجى تحديث الصفحة والمحاولة مرة أخرى.
        </p>
        
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <button onclick="location.reload()" class="bg-blue-600 text-white px-8 py-3 rounded-xl font-bold hover:bg-blue-700 transition shadow-lg">
                تحديث الصفحة
            </button>
            <a href="{{ url('/login') }}" class="bg-white text-slate-700 border border-slate-200 px-8 py-3 rounded-xl font-bold hover:bg-slate-100 transition">
                العودة لتسجيل الدخول
            </a>
        </div>
    </div>
</body>
</html>
<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title')</title>

</head>

<body class="bg-slate-100 min-h-screen">

    <!-- Navbar -->
    <div class="bg-white border-b border-slate-200 shadow-sm">

        <div class="max-w-7xl mx-auto px-6">

            <div class="flex flex-wrap items-center justify-between py-4 gap-4">

                <!-- Bank -->
                <div class="flex items-center gap-4">

                    <div class="w-12 h-12 rounded-2xl bg-blue-700 text-white flex items-center justify-center text-xl shadow-lg">
                        🏦
                    </div>

                    <div>

                        <h2 class="font-black text-slate-800">
                            لوحة تحكم البنك
                        </h2>

                        <p class="text-sm text-slate-400">
                            نظام الرقابة الائتمانية
                        </p>

                    </div>

                </div>

                <!-- Links -->
                <div class="flex flex-wrap items-center gap-3">

                    <a href="{{ route('bank.dashboard') }}"
                       class="px-5 py-3 rounded-2xl font-bold transition
                       {{ request()->routeIs('bank.dashboard')
                            ? 'bg-blue-700 text-white shadow-lg'
                            : 'bg-slate-100 hover:bg-slate-200 text-slate-700' }}">

                        📊 الرئيسية

                    </a>

                    <a href="{{ route('bank.reports') }}"
                       class="px-5 py-3 rounded-2xl font-bold transition
                       {{ request()->routeIs('bank.reports')
                            ? 'bg-blue-700 text-white shadow-lg'
                            : 'bg-slate-100 hover:bg-slate-200 text-slate-700' }}">

                        📑 التقارير

                    </a>

                    <button onclick="window.print()"
                            class="px-5 py-3 rounded-2xl font-bold bg-emerald-500 hover:bg-emerald-600 text-white shadow-lg transition">

                        🖨️ طباعة

                    </button>

                    <form action="{{ route('bank.logout') }}" method="POST">

                        @csrf

                        <button
                            class="px-5 py-3 rounded-2xl font-bold bg-red-100 hover:bg-red-200 text-red-700 transition">

                            🚪 تسجيل الخروج

                        </button>

                    </form>

                </div>

            </div>

        </div>

    </div>

    <!-- Content -->
    <div class="max-w-7xl mx-auto p-6">

        @yield('content')

    </div>

</body>

</html>
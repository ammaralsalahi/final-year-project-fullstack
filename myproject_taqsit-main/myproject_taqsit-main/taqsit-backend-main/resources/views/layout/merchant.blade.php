<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title')</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-slate-100 min-h-screen">

    <!-- Navbar -->
    <div class="bg-white border-b border-slate-200 shadow-sm">

        <div class="max-w-7xl mx-auto px-6">

            <div class="flex flex-wrap items-center justify-between py-4 gap-4">

                <!-- Store -->
                <div class="flex items-center gap-4">

                    <div class="w-12 h-12 rounded-2xl bg-slate-900 text-white flex items-center justify-center text-xl shadow-lg">
                        🏪
                    </div>

                    <div>

                        <h2 class="font-black text-slate-800">
                            {{ Auth::guard('merchant')->user()->store_name }}
                        </h2>

                        <p class="text-sm text-slate-400">
                            لوحة تحكم التاجر
                        </p>

                    </div>

                </div>

                <!-- Links -->
                <div class="flex flex-wrap items-center gap-3">

                    <a href="{{ route('merchant.dashboard') }}"
                       class="px-5 py-3 rounded-2xl font-bold transition
                       {{ request()->routeIs('merchant.dashboard')
                            ? 'bg-slate-900 text-white shadow-lg'
                            : 'bg-slate-100 hover:bg-slate-200 text-slate-700' }}">

                        📊 الرئيسية

                    </a>

                    <a href="{{ route('merchant.products.index') }}"
                       class="px-5 py-3 rounded-2xl font-bold transition
                       {{ request()->routeIs('merchant.products*')
                            ? 'bg-slate-900 text-white shadow-lg'
                            : 'bg-slate-100 hover:bg-slate-200 text-slate-700' }}">

                        📦 المنتجات

                    </a>

                    <form action="{{  route('logout') }}" method="POST">

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
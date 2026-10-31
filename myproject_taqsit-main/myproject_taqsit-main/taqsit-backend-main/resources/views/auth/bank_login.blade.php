@extends('layout.app')

@section('title', 'دخول إدارة البنك')

@section('content')
<div class="min-h-screen bg-gradient-to-br from-slate-950 via-blue-950 to-slate-900 relative overflow-hidden flex items-center justify-center px-4">

    <!-- Background Effects -->
    <div class="absolute top-0 left-0 w-[500px] h-[500px] bg-blue-500/20 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-0 w-[400px] h-[400px] bg-cyan-400/10 rounded-full blur-3xl"></div>

    <!-- Grid Overlay -->
    <div class="absolute inset-0 opacity-10"
         style="background-image: linear-gradient(rgba(255,255,255,.08) 1px, transparent 1px),
         linear-gradient(90deg, rgba(255,255,255,.08) 1px, transparent 1px);
         background-size: 50px 50px;">
    </div>

    <div class="relative z-10 w-full max-w-md">

        <!-- Logo / Header -->
        <div class="text-center mb-10">

            <div class="relative inline-flex items-center justify-center mb-6">
                <div class="absolute inset-0 bg-blue-500 blur-2xl opacity-40 rounded-full"></div>

                <div class="relative w-24 h-24 rounded-3xl bg-white/10 border border-white/10 backdrop-blur-xl flex items-center justify-center shadow-2xl">

                    <svg class="w-12 h-12 text-blue-400"
                         fill="none"
                         stroke="currentColor"
                         viewBox="0 0 24 24">
                        <path stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="1.8"
                              d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z">
                        </path>
                    </svg>

                </div>
            </div>

            <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-500/10 border border-blue-400/20 text-blue-300 text-sm backdrop-blur-xl mb-5">
                <span class="w-2 h-2 bg-blue-400 rounded-full animate-pulse"></span>
                النظام البنكي المركزي
            </div>

            <h1 class="text-4xl font-black text-white leading-tight">
                Bank Control Panel
            </h1>

            <p class="text-slate-300 mt-4 leading-7">
                منصة الإدارة والتحكم بالحسابات البنكية
                والمعاملات المالية بشكل آمن واحترافي
            </p>
        </div>

        <!-- Login Card -->
        <div class="relative group">

            <div class="absolute inset-0 bg-gradient-to-r from-blue-500 to-cyan-400 rounded-3xl blur opacity-25 group-hover:opacity-40 transition duration-500"></div>

            <div class="relative bg-white/10 backdrop-blur-2xl border border-white/10 rounded-3xl p-8 shadow-2xl">

                <form action="{{ url('/login') }}" method="POST" class="space-y-6">
                    @csrf

                    <!-- Email -->
                    <div>
                        <label class="block text-sm text-slate-200 mb-2">
                            البريد الإلكتروني
                        </label>

                        <div class="relative">
                            <input
                                type="email"
                                name="email"
                                placeholder="admin@bank.com"
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-blue-500 outline-none transition"
                            >

                            <div class="absolute inset-y-0 left-4 flex items-center text-slate-400">
                                ✉️
                            </div>
                        </div>
                    </div>

                    <!-- Password -->
                    <div>
                        <label class="block text-sm text-slate-200 mb-2">
                            كلمة المرور
                        </label>

                        <div class="relative">
                            <input
                                type="password"
                                name="password"
                                placeholder="••••••••"
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-blue-500 outline-none transition"
                            >

                            <div class="absolute inset-y-0 left-4 flex items-center text-slate-400">
                                🔒
                            </div>
                        </div>
                    </div>

                    <!-- Remember -->
                    <div class="flex items-center justify-between text-sm">
                        <label class="flex items-center gap-2 text-slate-300 cursor-pointer">
                            <input type="checkbox" class="rounded border-white/20 bg-white/10">
                            تذكر بيانات الدخول
                        </label>

                        <a href="#" class="text-blue-400 hover:text-blue-300 transition">
                            نسيت كلمة المرور؟
                        </a>
                    </div>

                    <!-- Button -->
                    <button
                        type="submit"
                        class="w-full py-4 rounded-2xl bg-gradient-to-r from-blue-500 to-cyan-400 text-white font-black text-lg shadow-2xl hover:scale-[1.02] hover:shadow-blue-500/40 transition duration-300"
                    >
                        دخول النظام
                    </button>

                </form>

            </div>
        </div>

        <!-- Footer -->
        <div class="mt-8 text-center text-slate-400 text-sm">
            جميع العمليات محمية ومشفرة بالكامل 🔐
        </div>

    </div>
</div>
@endsection
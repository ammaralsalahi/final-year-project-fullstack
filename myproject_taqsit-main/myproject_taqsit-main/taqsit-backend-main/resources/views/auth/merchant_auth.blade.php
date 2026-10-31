@extends('layout.app')

@section('title', 'بوابة التجار')

@section('content')
<div class="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-emerald-950 relative overflow-hidden">

    <!-- Glow Effects -->
    <div class="absolute top-0 left-0 w-96 h-96 bg-emerald-500/20 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-cyan-500/20 rounded-full blur-3xl"></div>

    <div class="relative z-10 max-w-7xl mx-auto px-6 py-16">

        <!-- Hero -->
        <div class="text-center mb-12">
            <div class="inline-flex items-center gap-2 bg-white/10 border border-white/10 backdrop-blur-xl px-5 py-2 rounded-full text-emerald-300 text-sm mb-6 shadow-lg">
                <span class="w-2 h-2 bg-emerald-400 rounded-full animate-pulse"></span>
                منصة الشركاء المعتمدين
            </div>

            <h1 class="text-5xl md:text-6xl font-black text-white leading-tight">
                بوابة التجار الذكية
            </h1>

            <p class="text-slate-300 text-lg mt-6 max-w-2xl mx-auto leading-8">
                إدارة عمليات البيع بالتقسيط والتحويلات المالية ومتابعة العملاء
                عبر منصة احترافية مصممة للتجار العصريين.
            </p>
        </div>

        <!-- Auth Card Container -->
        <div class="max-w-2xl mx-auto relative group">
            <div class="absolute inset-0 bg-gradient-to-r from-emerald-500 to-cyan-500 rounded-3xl blur opacity-25 group-hover:opacity-40 transition duration-500"></div>

            <div class="relative bg-white/10 backdrop-blur-2xl border border-white/10 rounded-3xl p-8 md:p-10 shadow-2xl">
                
                <!-- 1. LOGIN SECTION -->
                <div id="login-section" class="transition-all duration-300">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h2 class="text-3xl font-black text-white">
                                تسجيل الدخول
                            </h2>
                            <p class="text-slate-300 mt-2">
                                ادخل إلى لوحة التحكم الخاصة بمتجرك
                            </p>
                        </div>
                        <div class="w-16 h-16 rounded-2xl bg-emerald-500/20 flex items-center justify-center text-3xl shadow-lg">
                            🛒
                        </div>
                    </div>

                    <form action="{{ url('/login') }}" method="POST" class="space-y-6">
                        @csrf

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                اسم المتجر
                            </label>
                            <input
                                type="text"
                                name="store_name"
                                placeholder="اسم المتجر المسجل"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-emerald-500 outline-none transition"
                            >
                        </div>

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                رقم السجل التجاري
                            </label>
                            <input
                                type="text"
                                name="commercial_reg"
                                placeholder="CR-XXXXX"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-emerald-500 outline-none transition"
                            >
                        </div>

                        <button
                            type="submit"
                            class="w-full py-4 rounded-2xl bg-gradient-to-r from-emerald-500 to-cyan-500 text-white font-bold text-lg shadow-2xl hover:scale-[1.02] hover:shadow-emerald-500/30 transition duration-300"
                        >
                            دخول التاجر
                        </button>
                    </form>

                    <!-- Switch to Register Link -->
                    <div class="text-center mt-8 pt-6 border-t border-white/10">
                        <p class="text-slate-300">
                            ليس لديك حساب تاجر معنا؟ 
                            <button onclick="toggleAuth('register')" class="text-emerald-400 font-bold hover:underline focus:outline-none mr-1">
                                إنشاء حساب جديد الآن
                            </button>
                        </p>
                    </div>
                </div>

                <!-- 2. REGISTER SECTION (Hidden by default) -->
                <div id="register-section" class="hidden transition-all duration-300">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h2 class="text-3xl font-black text-white">
                                إنشاء حساب جديد
                            </h2>
                            <p class="text-slate-300 mt-2">
                                انضم إلى شبكة التجار المعتمدين
                            </p>
                        </div>
                        <div class="w-16 h-16 rounded-2xl bg-cyan-500/20 flex items-center justify-center text-3xl shadow-lg">
                            ✨
                        </div>
                    </div>

                    <form action="{{ url('/merchant/register') }}" method="POST" class="space-y-5">
                        @csrf

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                اسم المتجر
                            </label>
                            <input
                                type="text"
                                name="store_name"
                                placeholder="مثال: معرض الأمل"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-cyan-500 outline-none transition"
                            >
                        </div>

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                رقم السجل التجاري
                            </label>
                            <input
                                type="text"
                                name="commercial_reg"
                                placeholder="سيستخدم لتسجيل دخولك"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-cyan-500 outline-none transition"
                            >
                        </div>

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                رقم الهاتف
                            </label>
                            <input
                                type="text"
                                name="phone"
                                placeholder="77XXXXXXX"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-cyan-500 outline-none transition"
                            >
                        </div>

                        <div>
                            <label class="block text-sm text-slate-200 mb-2">
                                رقم الحساب البنكي
                            </label>
                            <input
                                type="text"
                                name="bank_account_number"
                                placeholder="ACC-2026-XXXX"
                                required
                                class="w-full bg-white/10 border border-white/10 text-white placeholder:text-slate-400 rounded-2xl px-5 py-4 focus:ring-2 focus:ring-cyan-500 outline-none transition"
                            >
                        </div>

                        <button
                            type="submit"
                            class="w-full py-4 rounded-2xl bg-white text-slate-900 font-black text-lg shadow-2xl hover:scale-[1.02] transition duration-300"
                        >
                            تقديم طلب التسجيل
                        </button>
                    </form>

                    <!-- Switch to Login Link -->
                    <div class="text-center mt-8 pt-6 border-t border-white/10">
                        <p class="text-slate-300">
                            لديك حساب بالفعل؟ 
                            <button onclick="toggleAuth('login')" class="text-cyan-400 font-bold hover:underline focus:outline-none mr-1">
                                تسجيل الدخول
                            </button>
                        </p>
                    </div>
                </div>

            </div>
        </div>

        <!-- Bottom Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-16">
            <div class="bg-white/5 border border-white/10 backdrop-blur-xl rounded-3xl p-6 text-center">
                <h3 class="text-4xl font-black text-white">24/7</h3>
                <p class="text-slate-300 mt-2">دعم ومتابعة مستمرة</p>
            </div>

            <div class="bg-white/5 border border-white/10 backdrop-blur-xl rounded-3xl p-6 text-center">
                <h3 class="text-4xl font-black text-emerald-400">+500</h3>
                <p class="text-slate-300 mt-2">تاجر موثوق</p>
            </div>

            <div class="bg-white/5 border border-white/10 backdrop-blur-xl rounded-3xl p-6 text-center">
                <h3 class="text-4xl font-black text-cyan-400">100%</h3>
                <p class="text-slate-300 mt-2">حماية وأمان للمعاملات</p>
            </div>
        </div>

    </div>
</div>

<!-- JavaScript السلس للتنقل بين الواجهتين بدون تحديث الصفحة -->
<script>
    function toggleAuth(view) {
        const loginSection = document.getElementById('login-section');
        const registerSection = document.getElementById('register-section');

        if (view === 'register') {
            loginSection.classList.add('hidden');
            registerSection.classList.remove('hidden');
        } else {
            registerSection.classList.add('hidden');
            loginSection.classList.remove('hidden');
        }
    }
</script>
@endsection
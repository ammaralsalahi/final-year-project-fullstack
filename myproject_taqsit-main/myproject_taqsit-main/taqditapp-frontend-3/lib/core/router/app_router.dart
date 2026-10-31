import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:installment/features/Auth/page/Login_screen.dart';
// import 'package:installment/features/Auth/page/register_screen.dart';
// import 'package:installment/features/newDesign/product_deisgn.dart';
// import 'package:installment/features/home/presentation/pages/home_page.dart';
import 'package:installment/main_page.dart';

import 'package:installment/features/splash/onboarding_page.dart';
// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/mainPage', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const OnboardingPage(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   // builder: (context, state) => const HomePage(),
      // ),
    ],
    // اختياري: إضافة صفحة خطأ في حال تعذر الوصول لمسار معين
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}

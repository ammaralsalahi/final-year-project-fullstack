import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/core/widegets/bottom_NavigationBar.dart';
import 'package:installment/features/home/bloc/home_bloc.dart';
import 'package:installment/features/home/presentation/pages/home_page.dart';
import 'package:installment/data/repository/home_repository.dart';
import 'package:installment/features/home/presentation/pages/transactions_page.dart';

import 'features/home/presentation/pages/installments_page.dart';
import 'features/home/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  // الترتيب الصحيح والمتطابق 100% مع الأيقونات:
  final List<Widget> pages = [
    const HomePage(), // أندكس 0 -> مرتبط بأيقونة "الرئيسية"
    const InstallmentsPage(), // أندكس 1 -> مرتبط بأيقونة "أقساطي"
    const TransactionsPage(), // أندكس 2 -> مرتبط بأيقونة "العمليات"
    const ProfilePage(), // أندكس 3 -> مرتبط بأيقونة "حسابي"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  التغليف المباشر والآمن: يتم إنشاء الـ Bloc والـ Repository فوراً مع الـ build منعاً لأي تأخير
      body: BlocProvider(
        create: (context) => HomeBloc(homeRepository: HomeRepository())
          ..add(FetchHomeData()), //  جلب البيانات والمنتجات فوراً عند التشغيل
        child: IndexedStack(index: currentIndex, children: pages),
      ),

      bottomNavigationBar: MainBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

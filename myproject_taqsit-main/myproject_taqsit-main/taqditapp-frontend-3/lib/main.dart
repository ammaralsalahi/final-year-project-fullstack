import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/core/constants/storage_service.dart';
import 'package:installment/core/router/app_router.dart';
import 'package:installment/data/repository/home_repository.dart';
import 'package:installment/features/cart/bloc/cart_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_bloc.dart';
import 'package:installment/features/home/bloc/home_bloc.dart';
import 'data/repository/auth_repository.dart' show AuthRepository;
import 'features/Auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); // 👈 التهيئة هنا مرة واحدة فقط
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(create: (context) => FavoritesBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(
          create: (context) =>
              HomeBloc(homeRepository: HomeRepository())..add(FetchHomeData()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

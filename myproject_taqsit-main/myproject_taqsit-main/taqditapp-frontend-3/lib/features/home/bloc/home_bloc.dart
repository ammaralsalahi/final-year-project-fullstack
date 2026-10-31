import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/bank_model.dart';
import '../../../../data/repository/home_repository.dart';

// --- الـ Events ---
abstract class HomeEvent {}

class FetchHomeData extends HomeEvent {}

// --- الـ States ---
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final BankModel bankData;
  final List<dynamic>
  products; // 🌟 هنا استقبلنا المنتجات كـ List منفصلة عشان تنعرض وراء بعضها بالهوم بيج

  HomeLoaded({required this.bankData, required this.products});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}

// --- الـ Bloc ---
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    // معالجة حدث جلب بيانات الصفحة الرئيسية والبنك والمنتجات معاً
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // 1. جلب بيانات البنك (الرصيد والليميت) المتوافقة مع مسار /user/profile
        final bankData = await homeRepository.getBankDetails();

        // 2. جلب قائمة المنتجات كاملة من مسار /products المخصص لها 🛒
        final productsList = await homeRepository.getProducts();

        // 3. دمج البيانات وإرسالها فوراً للواجهة لتحديث الهيدر وشبكة المنتجات
        emit(HomeLoaded(bankData: bankData, products: productsList));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  }
}

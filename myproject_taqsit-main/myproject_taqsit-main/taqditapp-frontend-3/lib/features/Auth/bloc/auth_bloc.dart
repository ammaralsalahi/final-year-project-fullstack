import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/data/repository/auth_repository.dart';
import 'package:installment/features/Auth/bloc/auth_event.dart';
import 'package:installment/features/Auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository; // تعريف الـ Repository

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(
          phoneNumber: event.phoneNumber,
          password: event.password,
        );

        // إذا نجح اللوجن نرسل حالة النجاح
        emit(AuthSuccess(message: "تم تسجيل الدخول بنجاح"));
      } catch (e) {
        // تنظيف نص الخطأ وعرضه
        String errorMsg = e.toString().replaceAll('Exception:', '').trim();
        emit(AuthFailure(errorMessage: errorMsg));
      }
    });
  }

  //linl login page with authRepository
  //   on<LoginEvent>((event, emit) async {
  //     emit(AuthLoading());
  //     try {
  //       // استدعاء دالة تسجيل الدخول الحقيقية
  //       await authRepository.login(
  //         phoneNumber: event.phoneNumber,
  //         password: event.password,
  //       );

  //       emit(AuthSuccess(message: "تم تسجيل الدخول بنجاح"));
  //     } catch (e) {
  //       String errorMsg = e.toString().replaceAll('Exception:', '').trim();
  //       emit(AuthFailure(errorMessage: errorMsg));
  //     }
  //   });

  //   on<RegisterEvent>((event, emit) async {
  //     emit(AuthLoading());
  //     try {
  //       // الاتصال الفعلي بالباك إند (Laravel)
  //       await authRepository.register(
  //         name: event.name,
  //         email: event.email,
  //         phone: event.phone,
  //         password: event.password,
  //         billingAccount: event.billingAccount,
  //       );

  //       emit(
  //         AuthSuccess(message: "تم إنشاء الحساب بنجاح، بانتظار موافقة البنك"),
  //       );
  //     } catch (e) {
  //       // إزالة كلمة Exception من نص الخطأ ليظهر للمستخدم بشكل لائق
  //       String errorMsg = e.toString().replaceAll('Exception:', '').trim();
  //       emit(AuthFailure(errorMessage: errorMsg));
  //     }
  //   });
  // }
}

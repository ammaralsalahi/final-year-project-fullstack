import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:installment/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await http.post(
        // تعديل: استخدام الثوابت من مجلد core
        Uri.parse('${AppConstants.baseUrl}${AppConstants.login}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'phone_number': phoneNumber, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // 👈 السر هنا: قم بعمل reload للـ prefs بعد تغيير أي قيمة
        await prefs.setString('token', data['access_token']);
        await prefs.setInt('user_id', data['data']['user_id']);

        await prefs.reload(); // إجبار التحديث من القرص إلى الذاكرة

        print("DEBUG: Value saved successfully: ${data['data']['user_id']}");
      } else {
        // رمي الاستثناء برسالة الخطأ القادمة من لارافل
        throw Exception(data['message'] ?? 'بيانات الدخول غير صحيحة');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('تعذر الاتصال بالسيرفر، تأكد من تشغيل الباك إيند');
    }
  }
}

  // استبدل هذا برابط سيرفر Laravel الخاص بك
  // إذا كنت تستخدم المحاكي (Emulator) استخدم 10.0.2.2 بدلاً من localhost
  // final String baseUrl = 'http://127.0.0.1:8000/api';

  // Future<void> register({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String password,
  //   required String billingAccount,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/register'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'name': name,
  //         'email': email,
  //         'phone': phone,
  //         'password': password,
  //         'billing_account': billingAccount,
  //         // 'password_confirmation': password, // فك التعليق إذا كان Laravel يطلب تأكيد الباسورد
  //       }),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // تم التسجيل بنجاح
  //       return;
  //     } else {
  //       // فشل التسجيل (جلب رسالة الخطأ من Laravel)
  //       final data = jsonDecode(response.body);
  //       throw Exception(data['message'] ?? 'حدث خطأ غير معروف');
  //     }
  //   } catch (e) {
  //     throw Exception('فشل الاتصال بالخادم: $e');
  //   }
  // }

  //LOGIN
  // Future<void> login({
  //   required String phoneNumber,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/login'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({'phone': phoneNumber, 'password': password}),
  //     );

  //     if (response.statusCode == 200) {
  //       // هنا عادة Laravel يعيد Token
  //       // سنقوم لاحقاً بحفظه باستخدام SharedPreferences
  //       return;
  //     } else {
  //       final data = jsonDecode(response.body);
  //       throw Exception(data['message'] ?? 'بيانات الدخول غير صحيحة');
  //     }
  //   } catch (e) {
  //     throw Exception('خطأ في الاتصال: $e');
  //   }
  // }
//}

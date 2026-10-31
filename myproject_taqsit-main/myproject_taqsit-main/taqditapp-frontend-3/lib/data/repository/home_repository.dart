// lib/data/repository/home_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:installment/core/constants/storage_service.dart';
import 'package:installment/features/home/data/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../model/bank_model.dart';

class HomeRepository {
  /// 1. دالة جلب بيانات الحساب والبنك الديناميكية بناءً على الـ user_id 🌟
  Future<BankModel> getBankDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // جلب الـ ID مباشرة من المفتاح الموحد في StorageService
      int userId =
          StorageService.getUserId() ??
          prefs.getInt('user_id') ??
          int.tryParse(prefs.getString('user_id') ?? '') ??
          4;

      // ضرب الـ API على الرابط الديناميكي للأقساط المتوافق مع تعديل لارافل الأخير
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/installments/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final bankModel = BankModel.fromJson(data);

        // حفظ الاحتياط للكاش لضمان التزامن
        await prefs.setInt('user_id', bankModel.userId);

        return bankModel;
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب بيانات الحساب البنكي');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('تعذر الاتصال بالسيرفر، تأكد من تشغيل الباك إيند');
    }
  }

  /// 2. دالة مكررة تم توجيهها لنفس المسار الصحيح لضمان عدم كسر الـ Bloc
  Future<BankModel> getHomeAndBankData() async {
    return await getBankDetails();
  }

  /// 3. دالة سداد القسط وتعديل الرابط ليطابق لارافل عبر الثوابت
  /// 3. دالة سداد القسط المحدثة لترسل الـ user_id والـ installment_id في البودي 🌟
  Future<bool> payInstallment(int installmentId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // جلب الـ user_id الديناميكي الخاص بالمستخدم الحالي
      int userId =
          StorageService.getUserId() ??
          prefs.getInt('user_id') ??
          int.tryParse(prefs.getString('user_id') ?? '') ??
          4;

      // إرسال الطلب إلى المسار الجديد /installments/pay
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/installments/pay'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'installment_id': installmentId,
          'user_id':
              userId, // 🌟 تمرير معرف المستخدم الديناميكي في البودي حسب تحديث السيرفر
        }),
      );

      final data = jsonDecode(response.body);

      // فحص نجاح العملية بناءً على استجابة لارافل
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['message'] ?? 'فشل في عملية السداد');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('تعذر الاتصال بالسيرفر أثناء السداد: $e');
    }
  }

  /// 4. دالة جلب المنتجات المحدثة مع إصلاح روابط الصور 🛒
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.products}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> rawProducts = [];

        if (data is List) {
          rawProducts = data;
        } else if (data is Map && data.containsKey('products')) {
          rawProducts = data['products'];
        } else if (data is Map && data.containsKey('data')) {
          rawProducts = data['data'];
        } else {
          throw Exception('هيكلية بيانات المنتجات غير مدعومة');
        }

        return rawProducts.map((jsonItem) {
          Map<String, dynamic> item = Map<String, dynamic>.from(jsonItem);

          String? imageUrl =
              item['image_url']?.toString() ??
              item['image']?.toString() ??
              item['photo']?.toString();

          if (imageUrl != null && imageUrl.isNotEmpty) {
            String newUrl = imageUrl;

            if (newUrl.contains('127.0.0.1') || newUrl.contains('localhost')) {
              newUrl = newUrl
                  .replaceAll('127.0.0.1', AppConstants.hostIp)
                  .replaceAll('localhost', AppConstants.hostIp);

              if (!newUrl.contains(':${AppConstants.port}')) {
                newUrl = newUrl.replaceFirst(
                  AppConstants.hostIp,
                  '${AppConstants.hostIp}:${AppConstants.port}',
                );
              }
            } else if (!newUrl.startsWith('http')) {
              if (!newUrl.startsWith('/')) {
                newUrl = '/$newUrl';
              }
              newUrl =
                  'http://${AppConstants.hostIp}:${AppConstants.port}$newUrl';
            }

            newUrl = newUrl.replaceAll('/storage/', '/images/');

            item['image_url'] = newUrl;
            item['image'] = newUrl;

            print('🔗 رابط الصورة الجاهز: $newUrl');
          } else {
            print('⚠️ تنبيه: المنتج لا يحتوي على صورة من الباك إيند!');
          }

          return ProductModel.fromJson(item);
        }).toList();
      } else {
        throw Exception(data['message'] ?? 'فشل في تحميل المنتجات');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في الاتصال بالشبكة أثناء جلب المنتجات: $e');
    }
  }

  /// 5. دالة الشراء بعد تأمين قراءة الـ user_id بكافة الأشكال الممكنة 🛠️
  /// 5. دالة الشراء الديناميكية المتوافقة مع المنتج المختار والواجهة 🛒
  Future<bool> purchaseProductWithInstallment({
    required int productId, // يأخذ الـ ID حق المنتج من الواجهة
    required int months, // يأخذ الأشهر اللي اختارها الزبون (3، 6، 12)
    int? userId,
    required double
    downPayment, // يأخذ الدفعة المقدمة (نصف السعر) المحسوبة في الواجهة
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // جلب معرف المستخدم الحالي ديناميكياً
      int userIdFromStorage =
          StorageService.getUserId() ?? prefs.getInt('user_id') ?? 4;

      int finalUserId = userId ?? userIdFromStorage;

      print(
        "DEBUG: Sending Purchase Request -> Product: $productId, User: $finalUserId, Plan: $months, DownPayment: $downPayment",
      );

      // الاتصال بمسار الشراء الفوري
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/purchase'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': productId,
          'user_id': finalUserId,
          'installment_plan': months,
          'down_payment': downPayment, // إرسال نصف السعر المتوقع في لارافل غصب
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (data['status'] == 'success' || data['message'] != null)) {
        return true;
      } else {
        // تمرير رسالة الخطأ القادمة من الباك إيند الحقيقية بالملي
        throw Exception(data['message'] ?? 'فشل في إتمام عملية التقسيط');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('تعذر الاتصال بالسيرفر أثناء طلب التقسيط: $e');
    }
  }

  /// 6. دالة جلب بيانات البروفايل المحدثة
  /// 6. دالة جلب بيانات البروفايل المحدثة ديناميكياً بالكامل 👤
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final user = data['user'] ?? {};
        final bank = data['bank'] ?? user['bank'] ?? {};

        // جلب البيانات ديناميكياً من الباك إيند حسب الزبون المسجل حالياً غصب
        return {
          'full_name':
              user['full_name'] ??
              bank['full_name'] ??
              'مرحباً بك', // 🌟 كلمة ترحيبية عامة كاحتياط فقط
          'email': bank['email'] ?? 'لا يوجد بريد إلكتروني',
          'phone_number': user['phone_number'] ?? bank['phone_number'] ?? '',
          'account_number': bank['account_number'] ?? 'لا يوجد رقم حساب',
          'balance': bank['balance'] ?? '0.00',
          'credit_score': bank['credit_score'] ?? 0,
          'max_credit_limit': bank['max_credit_limit'] ?? '0.00',
        };
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب بيانات الملف الشخصي');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في الاتصال بالسيرفر أثناء جلب البروفايل: $e');
    }
  }
}

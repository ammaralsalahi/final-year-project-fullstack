class AppConstants {
  // الرابط الأساسي للـ API (تأكد من ثبات الـ IP الخاص بجهازك)
  static const String baseUrl = 'http://192.168.1.104:8000/api';
  static const String hostIp = '192.168.1.104';
  static const String port = '8000';
  // روابط فرعية (Endpoints) متطابقة 100% مع الـ api.php في الباك إيند
  static const String login = '/login';
  static const String products = '/products';
  //  التعديل هنا: ربط البنك بالمسار المدمج الصحيح
  static const String bankDetails = '/user/profile';
  //  التعديل هنا: مسار السداد الفعلي في لاراڤيل
  static const String payInstallment = '/installments/pay';
}

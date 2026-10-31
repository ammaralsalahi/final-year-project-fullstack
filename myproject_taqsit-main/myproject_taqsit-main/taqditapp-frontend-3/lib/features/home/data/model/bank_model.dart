import 'installment_model.dart'; // تأكد من صحة مسار الموديل هنا

class BankModel {
  final double limit;
  final double balance;
  final List<InstallmentModel> installments; 

  BankModel({
    required this.limit,
    required this.balance,
    this.installments = const [], // 👈 جعلناها اختياري وقيمتها الافتراضية مصفوفة فارغة عشان ما تضرب في بقية الملفات
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    // جلب مصفوفة الأقساط وتحويلها بأمان
    var list = json['installments'] as List? ?? [];
    List<InstallmentModel> installmentList = list
        .map((i) => InstallmentModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return BankModel(
      // تحويل القيم إلى double بأمان منعاً لخطأ الـ type 'int' is not a subtype of type 'double'
      limit: double.tryParse(json['credit_limit']?.toString() ?? '0') ?? 0.0,
      balance: double.tryParse(json['bank_balance']?.toString() ?? '0') ?? 0.0,
      installments: installmentList, 
    );
  }
}
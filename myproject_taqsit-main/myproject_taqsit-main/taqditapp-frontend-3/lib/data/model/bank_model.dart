// lib/data/model/bank_model.dart

class BankModel {
  final int id;
  final int userId;
  final double balance;
  final double creditLimit;
  final double remainingTotal;
  final List<InstallmentItem> installments; // 🌟 قائمة الأقساط الحقيقية

  BankModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.creditLimit,
    required this.remainingTotal,
    required this.installments,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    // جلب كائن البنك الداخلي إن وجد (لأن سيرفرك أحياناً يلف الحقول داخل كائن 'bank')
    final bankData = json['bank'] is Map ? json['bank'] : json;

    // استخراج قائمة الأقساط بشكل آمن تماماً حسب مسميات لاراڤيل
    List<dynamic> rawInstallments = [];
    if (json['installments'] is List) {
      rawInstallments = json['installments'];
    } else if (bankData['installments'] is List) {
      rawInstallments = bankData['installments'];
    } else if (json['data'] is Map && json['data']['installments'] is List) {
      rawInstallments = json['data']['installments'];
    }

    return BankModel(
      id: int.tryParse(bankData['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? bankData['user_id']?.toString() ?? '0') ?? 0,
      balance: double.tryParse(bankData['balance']?.toString() ?? '0.0') ?? 0.0,
      creditLimit: double.tryParse(bankData['credit_limit']?.toString() ?? '0.0') ?? 0.0,
      // قراءة الـ remaining_total من الحقل المباشر أو البنك
      remainingTotal: double.tryParse(json['remaining_total']?.toString() ?? bankData['remaining_total']?.toString() ?? '0.0') ?? 0.0,
      
      // تحويل الأقساط إلى الموديل الفرعي لمنع ظهور واجهة فارغة
      installments: rawInstallments.map((item) => InstallmentItem.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}

// 🌟 الموديل الفرعي لكل قسط قادم من لاراڤيل بعد التحديث الأخير لـ الـ JSON
class InstallmentItem {
  final int id;
  final String productName; // 🌟 إضافة اسم المنتج القادم من السيرفر
  final double amount;
  final String dueDate;
  final String status;      // 'paid' أو 'pending'
  final bool isLate;        // 🌟 إضافة حقل التعثر لمعرفته وتلوينه بالأحمر

  InstallmentItem({
    required this.id,
    required this.productName,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.isLate,
  });

  factory InstallmentItem.fromJson(Map<String, dynamic> json) {
    return InstallmentItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? json['name']?.toString() ?? 'منتج غير معروف',
      amount: double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0,
      dueDate: json['due_date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      // فحص ذكي للـ bool يدعم لو رجع من لارافل كـ Boolean صريح أو كـ 1 و 0
      isLate: json['is_late'] is bool 
          ? json['is_late'] 
          : (json['is_late'] == 1 || json['is_late']?.toString() == 'true'),
    );
  }

  // دالة مساعدة لمعرفة هل القسط مدفوع أم لا لعرض الأيقونة المناسبة في الواجهة
  bool get isPaid => status.toLowerCase() == 'paid' || status == '1';
}
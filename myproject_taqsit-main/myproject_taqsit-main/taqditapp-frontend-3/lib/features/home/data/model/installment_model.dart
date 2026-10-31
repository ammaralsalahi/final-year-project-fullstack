// lib/features/home/data/model/installment_model.dart

class InstallmentModel {
  final int id;
  final String title;
  final double amount;
  final String dueDate;
  final String status; // قادم أو مدفوع (active / paid)

  InstallmentModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  // تحويل الـ JSON القادم من لارافل إلى كائن فلاتر
  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : (json['amount'] ?? 0.0),
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? 'active',
    );
  }
}
// lib/features/home/data/model/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final int price;
  final String discount;
  final String image;
  final String description;
  final int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.image,
    required this.description,
    required this.quantity,
  });

  // 🌟 الدالة المطورة والمطابقة 100% للـ JSON حق السيرفر حقك 🌟
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 1. معالجة السعر: تحويل الـ String العشري (مثل "6000.00") إلى double ثم int لمنع الـ 0 ريال
    double rawPrice = double.tryParse(json['price']?.toString() ?? '0') ?? 0.0;
    int finalPrice = rawPrice.toInt();

    // 2. معالجة رابط الصورة: الاعتماد مباشرة على حقل image_url الذكي القادم من لاراڤيل
    String imageUrl = json['image_url']?.toString() ?? '';

    // تأمين إضافي: إذا كان الرابط يستخدم localhost (127.0.0.1) وأنت تختبر من جوال حقيقي أو محاكي خارجي، يفضل استبداله بـ IP جهازك، وإلا اتركه كما هو
    if (imageUrl.contains('127.0.0.1')) {
      // إذا واجهت مشكلة عدم ظهور الصور في الجوال، غير '127.0.0.1' إلى الـ IP الخاص بجهازك (مثل 172.16.28.104)
      // imageUrl = imageUrl.replaceAll('127.0.0.1', '172.16.28.104');
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name:
          json['product_name']?.toString() ??
          json['name']?.toString() ??
          'منتج غير مسمى',
      price: finalPrice, // الحين بيطلع السعر الحقيقي (100000 أو 6000) غصب!
      discount: json['discount']?.toString() ?? '0%',
      image: imageUrl, // الرابط الجاهز الكامل من السيرفر
      description: json['description']?.toString() ?? '',
      quantity:
          int.tryParse(
            json['quantity']?.toString() ?? json['stock']?.toString() ?? '10',
          ) ??
          10,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    int? price,
    String? discount,
    String? image,
    String? description,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      image: image ?? this.image,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProductModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

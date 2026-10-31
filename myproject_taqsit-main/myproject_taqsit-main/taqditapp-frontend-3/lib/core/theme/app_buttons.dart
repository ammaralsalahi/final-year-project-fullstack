import 'package:flutter/material.dart';

class AppButtons {
  /// 🔴 زر رئيسي (بعرض كامل)
  static ButtonStyle primaryLarge = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  /// زر صغير
  static ButtonStyle smallRounded = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 58, 58, 58),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    elevation: 2,
  );

  /// 🔵 زر متوسط
  static ButtonStyle medium = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 32, 32, 32),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    minimumSize: const Size(250, 45),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

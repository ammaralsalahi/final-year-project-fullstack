import 'package:flutter/material.dart';
import 'package:installment/core/theme/app_text_style.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('CategoriesPage', style: AppTextStyles.productTitle),
      ),
    );
  }
}

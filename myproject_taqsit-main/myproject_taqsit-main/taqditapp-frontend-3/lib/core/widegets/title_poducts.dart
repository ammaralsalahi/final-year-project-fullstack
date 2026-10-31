import 'package:flutter/material.dart';
import 'package:installment/core/theme/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductTitleWithSquare extends StatelessWidget {
  final String title;
  final bool isLoading;

  const ProductTitleWithSquare({super.key, required this.title, required this.isLoading});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Skeletonizer(
        enabled: isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.right,
              style: AppTextStyles.productTitle,
            ),
            SizedBox(width: 4),
            Transform.translate(
              offset: const Offset(-1, 1), 
              child: Container(
                width: 8,
                height: 20, 
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 119, 40),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
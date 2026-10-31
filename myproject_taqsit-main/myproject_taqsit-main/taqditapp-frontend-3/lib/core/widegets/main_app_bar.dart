import 'package:flutter/material.dart';
import 'package:installment/core/theme/app_colors.dart';
import 'package:installment/core/theme/app_text_style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCart;
  final bool centerTitles;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final Color? iconcolor;

  const MainAppBar({
    super.key,
    required this.title,
    this.showCart = true,
    this.leadingIcon,
    this.backgroundColor,
    this.titleStyle,
    required this.centerTitles,
    this.iconcolor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.textSecondary,
      elevation: 0,
      centerTitle: centerTitles,
      flexibleSpace: backgroundColor == null
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 236, 90, 45), Colors.deepOrange],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
              ),
            )
          : null,
      iconTheme: IconThemeData(color: iconcolor),
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: titleStyle ?? AppTextStyles.appBarTitle,
      ),
      leading: leadingIcon,
      actions: showCart
          ? [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/CartPage');
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primaryColor = Color(0xFF123746);
  static const Color goldColor = Color(0xFFDDBB69);
  static const Color mutedColor = Color(0xFF82919A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.09),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: primaryColor.withOpacity(0.06),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 9, 8, 5),
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  label: 'الرئيسية',
                  icon: CupertinoIcons.house,
                  activeIcon: CupertinoIcons.house_fill,
                ),
                _buildNavItem(
                  index: 1,
                  label: 'أقساطي',
                  icon: CupertinoIcons.creditcard,
                  activeIcon: CupertinoIcons.creditcard_fill,
                ),
                _buildNavItem(
                  index: 2,
                  label: 'العمليات',
                  icon: CupertinoIcons.doc_text,
                  activeIcon: CupertinoIcons.doc_text_fill,
                ),
                _buildNavItem(
                  index: 3,
                  label: 'حسابي',
                  icon: CupertinoIcons.person,
                  activeIcon: CupertinoIcons.person_fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 2,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withOpacity(0.07)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: isSelected ? 48 : 42,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          isSelected ? activeIcon : icon,
                          size: 22,
                          color: isSelected
                              ? goldColor
                              : mutedColor,
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 2,
                            child: Container(
                              width: 4,
                              height: 3,
                              decoration: BoxDecoration(
                                color: goldColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontFamily: 'cairo',
                      fontSize: isSelected ? 11 : 10,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? primaryColor
                          : mutedColor,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

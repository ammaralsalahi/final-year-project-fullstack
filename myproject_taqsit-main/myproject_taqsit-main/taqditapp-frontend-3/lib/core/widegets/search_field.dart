
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const Color primaryColor = Color(0xFF123746);
  static const Color secondaryColor = Color(0xFF205466);
  static const Color goldColor = Color(0xFFDDBB69);
  static const Color backgroundColor = Color(0xFFF3F6FA);
  static const Color mutedColor = Color(0xFF82919A);

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    if (isExpanded) {
      if (_controller.text.isNotEmpty) {
        _controller.clear();
      }

      _focusNode.unfocus();

      setState(() {
        isExpanded = false;
      });
    } else {
      setState(() {
        isExpanded = true;
      });

      // إعطاء الحقل وقتًا للظهور قبل فتح لوحة المفاتيح
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && isExpanded) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth =
        MediaQuery.of(context).size.width - 32;

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        width: isExpanded ? availableWidth : 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            isExpanded ? 16 : 25,
          ),
          border: Border.all(
            color: isExpanded
                ? primaryColor.withOpacity(0.18)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(
                isExpanded ? 0.09 : 0.06,
              ),
              blurRadius: isExpanded ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // زر البحث
            Material(
              color: isExpanded
                  ? primaryColor
                  : backgroundColor,
              borderRadius: BorderRadius.circular(
                isExpanded ? 13 : 25,
              ),
              child: InkWell(
                onTap: isExpanded
                    ? () {
                        _focusNode.unfocus();
                        // يمكن تنفيذ البحث الفعلي هنا
                      }
                    : _toggleSearch,
                borderRadius: BorderRadius.circular(
                  isExpanded ? 13 : 25,
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.search_rounded,
                    size: 23,
                    color: isExpanded
                        ? goldColor
                        : primaryColor,
                  ),
                ),
              ),
            ),

            // حقل البحث
            if (isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      fontFamily: 'cairo',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    cursorColor: secondaryColor,
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن منتج...',
                      hintStyle: TextStyle(
                        fontFamily: 'cairo',
                        fontSize: 12,
                        color: mutedColor,
                      ),
                      prefixIcon: null,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (value) {
                      // اربط قيمة البحث بمنطق البحث الموجود في مشروعك
                      _focusNode.unfocus();
                    },
                  ),
                ),
              ),

            // زر الإغلاق
            if (isExpanded)
              IconButton(
                tooltip: 'إغلاق البحث',
                onPressed: _toggleSearch,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: mutedColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

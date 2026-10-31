
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:installment/core/theme/app_buttons.dart';
import 'package:installment/core/theme/app_text_style.dart';

class HomeBannerSlider extends StatefulWidget {
  final List banners;

  const HomeBannerSlider({
    super.key,
    required this.banners,
  });

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int currentIndex = 0;

  static const Color primaryColor = Color(0xFF123746);
  static const Color secondaryColor = Color(0xFF205466);
  static const Color goldColor = Color(0xFFDDBB69);

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = widget.banners[index];

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // صورة البنر
                    Image.asset(
                      banner.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: primaryColor,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white70,
                            size: 42,
                          ),
                        );
                      },
                    ),

                    // تدرج لتحسين وضوح العنوان
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0xDD123746),
                            Color(0x99123746),
                            Color(0x20123746),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),

                    // لمسة ذهبية
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 65,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: goldColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // العنوان
                    Positioned(
                      top: 22,
                      right: 18,
                      left: 18,
                      child: Text(
                        banner.title,
                        textAlign: TextAlign.right,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bannerTitle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // زر التسوق
                    Positioned(
                      right: 18,
                      bottom: 18,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: primaryColor,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // أضف التنقل إلى صفحة المنتجات هنا
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 19,
                        ),
                        label: const Text(
                          'تسوّق الآن',
                          style: TextStyle(
                            fontFamily: 'cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 190,
            viewportFraction: 0.94,
            autoPlay: widget.banners.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(
              milliseconds: 700,
            ),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            enlargeFactor: 0.04,
            enableInfiniteScroll: widget.banners.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // مؤشرات البنرات
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) {
              final isSelected = currentIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isSelected ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : secondaryColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

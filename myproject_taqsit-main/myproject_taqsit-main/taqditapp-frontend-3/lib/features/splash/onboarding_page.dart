import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:installment/core/theme/app_buttons.dart';
import 'package:installment/core/theme/app_colors.dart';
import 'package:installment/core/theme/app_text_style.dart';
// import 'package:installment/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../../home/presentation/pages/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding/img1.svg",
      "title": "اهلا بك في تطبيقنا",
      "description":
          "استمتع بتجربه تسوق سهلة وآمنة، واختر ما يناسبك من منتجاتنا مع دفع مرن باقساط مريحة",
    },
    {
      "image": "assets/images/onboarding/img4.svg",
      "title": "تسوّق الآن وادفع لاحقاً",
      "description": "اختر المنتج الذي تريده اليوم وادفعه بأقساط مريحة",
    },
    {
      "image": "assets/images/onboarding/img2.svg",
      "title": "أقساط مرنة تناسبك",
      "description": "اختر مدة التقسيط المناسبة لك بكل سهولة وشفافية",
    },
    {
      "image": "assets/images/onboarding/img3.svg",
      "title": "دفع آمن ومتابعة مستمرة",
      "description": "تابع طلباتك وأقساطك بسهولة وأمان كامل",
    },
  ];

  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(234, 55, 11, 105),
              const Color.fromARGB(255, 28, 69, 97),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            /// الصفحات
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          pages[index]["image"]!,
                          width: 200,
                          height: 200,
                        ),

                        const SizedBox(height: 40),

                        Text(
                          pages[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.onboardingtitle,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          pages[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.onboardingtext,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// المؤشرات (النقاط)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.textPrimary
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// الزر
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (currentIndex == pages.length - 1) {
                    finishOnboarding();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                icon: Icon(
                  currentIndex == pages.length - 1
                      ? Icons.check
                      : Icons.arrow_forward,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                label: Text(
                  currentIndex == pages.length - 1 ? "ابدأ الآن" : "التالي",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Beiruti',
                  ),
                ),
                style: AppButtons.primaryLarge,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

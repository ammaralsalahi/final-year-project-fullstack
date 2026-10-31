import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/core/theme/app_colors.dart';
import 'package:installment/core/widegets/home_banner_slider.dart';
import 'package:installment/core/widegets/product_items.dart';
import 'package:installment/core/widegets/search_field.dart';
import 'package:installment/core/widegets/title_poducts.dart';
import 'package:installment/data/repository/home_repository.dart';
import 'package:installment/features/home/data/model/product_model.dart';
import 'package:installment/features/widget/sliverAppBar.dart';
import '../../bloc/home_bloc.dart';
import '../../data/banner_list.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // نجبر الصفحة تطلب البيانات من لارافل فوراً أول ما تفتح الشاشة
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(FetchHomeData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // إذا ضرب خطأ، بنعرضه على الشاشة لسهولة الفحص والـ Debugging
          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'حدث خطأ أثناء جلب البيانات:\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          bool isLoading = state is HomeLoading || state is HomeInitial;

          // قيم افتراضية مريحة للـ Skeletonizer أثناء التحميل
          double currentLimit = 500000;
          List<dynamic> allProducts = [];

          if (state is HomeLoaded) {
            currentLimit = state.bankData.creditLimit;
            allProducts = state.products;
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchHomeData());
                await context.read<HomeBloc>().stream.firstWhere(
                  (nextState) =>
                      nextState is HomeLoaded || nextState is HomeError,
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // 1. الهيدر المالي باستخدام نفس طريقة صفحة البروفايل
                  FutureBuilder<Map<String, dynamic>>(
                    future: HomeRepository()
                        .getUserProfile(), // 👈 استدعاء نفس الدالة
                    builder: (context, snapshot) {
                      // متغيرات مؤقتة لحين اكتمال جلب البيانات
                      double balance = 0.0;
                      int creditScore = 0;
                      String userName = "جاري التحميل...";
                      bool isProfileLoading =
                          snapshot.connectionState == ConnectionState.waiting;

                      if (snapshot.hasData) {
                        final profileData = snapshot.data!;
                        userName = profileData['full_name'] ?? 'مستخدم';

                        // 👈 جلب الرصيد ومؤشر الثقة من الـ Map مباشرة كما فعلت في البروفايل
                        balance =
                            double.tryParse(
                              profileData['balance']?.toString() ?? '0.0',
                            ) ??
                            0.0;
                        creditScore =
                            int.tryParse(
                              profileData['credit_score']?.toString() ?? '0',
                            ) ??
                            0;
                      }

                      return Skeletonizer.sliver(
                        // التفعيل يتم إذا كان الـ Bloc يحمل أو الـ Future يحمل
                        enabled: isLoading || isProfileLoading,
                        child: SliverAppBarDashboard(
                          userName: userName,
                          balance: balance, // 👈 الرصيد الحالي
                          creditScore: creditScore, // 👈 مؤشر الثقة
                          nextInstallment: currentLimit,
                          dueDate: "2026/07/01",
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductTitleWithSquare(
                          title: 'العروض المستمرة والإعلانات',
                          isLoading: isLoading,
                        ),
                        Skeletonizer(
                          enabled: isLoading,
                          child: HomeBannerSlider(banners: banners),
                        ),
                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: const SearchField(),
                          ),
                        ),

                        ProductTitleWithSquare(
                          title: 'المنتجات المتاحة للتقسيط الفوري',
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // 3. عرض كافة المنتجات وربط الانتقال لصفحة التفاصيل
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: Skeletonizer.sliver(
                      enabled: isLoading,
                      child: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          // إرجاع عنصر فارغ مؤقتاً للـ Skeletonizer أو العنصر الحقيقي
                          // إرجاع عنصر وهمي للـ Skeletonizer أثناء التحميل
                          final product = isLoading
                              ? ProductModel(
                                  id: "1",
                                  name: "أبل واتش ألترا",
                                  price: 66000,
                                  discount: "15%",
                                  image:
                                      "assets/images/products/watch/image2.png",
                                  description:
                                      "ساعة آبل الذكية الجيل التاسع، تصميم أنيق ومتين مع شاشة Retina دائمًا تعمل، مقاومة للماء، تتبع النشاط الصحي والرياضي بدقة، إشعارات فورية، ودعم المكالمات والرسائل.",
                                  quantity: 12,
                                )
                              : allProducts[index];

                          return GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    // الانتقال لشاشة تفاصيل المنتج وتمرير الـ ProductModel الحقيقي
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsPage(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                            child: ProductItems(product: product),
                          );
                        }, childCount: isLoading ? 6 : allProducts.length),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

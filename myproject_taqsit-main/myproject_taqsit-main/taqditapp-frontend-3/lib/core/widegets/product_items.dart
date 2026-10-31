
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_event.dart';
import 'package:installment/features/favorites/bloc/favorite_state.dart';
import 'package:installment/features/home/presentation/pages/product_details_page.dart';
import '../../features/home/data/model/product_model.dart';

class ProductItems extends StatelessWidget {
  final ProductModel product;

  const ProductItems({
    super.key,
    required this.product,
  });

  static const Color primaryColor = Color(0xFF123746);
  static const Color goldColor = Color(0xFFDDBB69);
  static const Color backgroundColor = Color(0xFFF3F6FA);
  static const Color mutedColor = Color(0xFF7B8B96);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(product: product),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE8EDF2),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.055),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // مساحة الصورة
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: backgroundColor,
                      padding: const EdgeInsets.all(9),
                      child: _buildProductImage(),
                    ),

                    // شريط زخرفي خفيف
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: goldColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // زر المفضلة
                    Positioned(
                      top: 9,
                      right: 9,
                      child: BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          final isFavorite = state.favorites.any(
                            (item) => item.id == product.id,
                          );

                          return Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                if (isFavorite) {
                                  context.read<FavoritesBloc>().add(
                                    RemoveFromFavorites(product),
                                  );
                                } else {
                                  context.read<FavoritesBloc>().add(
                                    AddToFavorites(product),
                                  );
                                }
                              },
                              child: SizedBox(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFavorite
                                      ? const Color(0xFFE05260)
                                      : primaryColor,
                                  size: 19,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // معلومات المنتج
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المنتج
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 13,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'cairo',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // السعر
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F8),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${product.price}',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'cairo',
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'ريال',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    const String fallbackImage = 'assets/images/img2.png';

    if (product.image.isEmpty) {
      return Image.asset(
        fallbackImage,
        fit: BoxFit.contain,
      );
    }

    if (product.image.startsWith('http')) {
      return Image.network(
        product.image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            fallbackImage,
            fit: BoxFit.contain,
          );
        },
      );
    }

    return Image.asset(
      product.image,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackImage,
          fit: BoxFit.contain,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:installment/core/theme/app_text_style.dart';
import 'package:installment/core/widegets/main_app_bar.dart';
import 'package:installment/features/favorites/bloc/favorite_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_event.dart';
import 'package:installment/features/favorites/bloc/favorite_state.dart';
import 'package:installment/features/home/presentation/pages/product_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: MainAppBar(
        title: "المفضلات",
        centerTitles: true,
        showCart: false,
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        titleStyle: AppTextStyles.productappbr,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final favorites = state.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/favorites/Empty-amico.svg',
                    height: 260,
                  ),
                  Text(
                    "!!لا يوجد منتجات في المفضلة",
                    style: AppTextStyles.productfavorites3,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(product: product),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      product.name,
                      style: AppTextStyles.productfavorites2,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Row(
                      children: [
                        Text("ريال ", style: AppTextStyles.productfavorites),
                        Text(
                          "${product.price}",
                          style: AppTextStyles.productfavorites,
                        ),
                      ],
                    ),

                    trailing: IconButton(
                      onPressed: () {
                        context.read<FavoritesBloc>().add(
                          RemoveFromFavorites(product),
                        );
                      },
                      icon: const Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

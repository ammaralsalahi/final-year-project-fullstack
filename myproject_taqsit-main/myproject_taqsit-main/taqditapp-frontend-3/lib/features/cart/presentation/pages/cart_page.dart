import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:installment/core/theme/app_buttons.dart';
// import 'package:installment/core/theme/app_colors.dart';
import 'package:installment/core/theme/app_text_style.dart';
import 'package:installment/core/widegets/main_app_bar.dart';
import 'package:installment/features/cart/bloc/cart_bloc.dart';
import 'package:installment/features/cart/bloc/cart_event.dart';
import 'package:installment/features/cart/bloc/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "السلة",
        centerTitles: true,
        showCart: false,
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        titleStyle: AppTextStyles.productappbr,
      ),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.cartItems;

          if (items.isEmpty) {
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
                    "!!لا يوجد منتجات في السله",
                    style: AppTextStyles.productfavorites3,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    ////////////////////////////////////////////
                    return Dismissible(
                      key: Key(product.id),
                      direction: DismissDirection.endToStart,

                      onDismissed: (_) {
                        context.read<CartBloc>().add(RemoveFromCart(product));
                      },

                      background: Container(
                        margin: const EdgeInsets.all(14), // نفس margin الكارد
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5),
                          ],
                        ),

                        child: Row(
                          children: [
                            Image.asset(
                              product.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                   style: AppTextStyles.productfavorites2,
                                   textDirection: TextDirection.rtl,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "ريال ",
                                        style: AppTextStyles.productfavorites,
                                      ),
                                      Text(
                                        "${product.price}",
                                        style: AppTextStyles.productfavorites,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                      DecreaseQuantity(product),
                                    );
                                  },
                                  icon: const Icon(Icons.remove),
                                ),

                                Text("${product.quantity}"),

                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                      IncreaseQuantity(product),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: AppButtons.smallRounded,
                        onPressed: () {},
                        child: const Text(
                          "شراء كاش",
                          style: AppTextStyles.buttontextadd12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: AppButtons.smallRounded,
                        onPressed: () {},
                        child: const Text(
                          "شراء بالتقسيط",
                          style: AppTextStyles.buttontextadd12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

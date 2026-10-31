import '../../home/data/model/product_model.dart';

class CartState {
  final List<ProductModel> cartItems;

  const CartState({this.cartItems = const []});

  CartState copyWith({
    List<ProductModel>? cartItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
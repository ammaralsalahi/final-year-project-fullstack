import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../home/data/model/product_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {

    /// ➕ إضافة للسلة
   on<AddToCart>((event, emit) {
  final updated = List<ProductModel>.from(state.cartItems);

  final index = updated.indexWhere(
    (item) => item.id == event.product.id,
  );

  if (index != -1) {
    /// إذا المنتج موجود ➜ زود الكمية
    updated[index] =
        updated[index].copyWith(quantity: updated[index].quantity + 1);
  } else {
    /// ✅ يبدأ بواحد فقط
    updated.add(
      event.product.copyWith(quantity: 1),
    );
  }

  emit(state.copyWith(cartItems: updated));
});
    /// ❌ حذف من السلة
    on<RemoveFromCart>((event, emit) {
      final updated = state.cartItems
          .where((item) => item.id != event.product.id)
          .toList();

      emit(state.copyWith(cartItems: updated));
    });

    /// ➕ زيادة الكمية
    on<IncreaseQuantity>((event, emit) {
      final updated = state.cartItems.map((item) {
        if (item.id == event.product.id) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(cartItems: updated));
    });

    /// ➖ نقصان الكمية
    on<DecreaseQuantity>((event, emit) {
      final updated = state.cartItems.map((item) {
        if (item.id == event.product.id && item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(cartItems: updated));
    });
  }
}
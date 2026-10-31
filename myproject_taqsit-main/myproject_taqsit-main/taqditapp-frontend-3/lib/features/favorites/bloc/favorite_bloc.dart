import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_event.dart';
import 'package:installment/features/favorites/bloc/favorite_state.dart';
import '../../home/data/model/product_model.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {

    /// ➕ إضافة للمفضلة
    on<AddToFavorites>((event, emit) {
      final updated = List<ProductModel>.from(state.favorites);

      /// 🔥 الحل هنا (بدل contains)
      if (!updated.any((item) => item.id == event.product.id)) {
        updated.add(event.product);
      }

      emit(state.copyWith(favorites: updated));
    });

    /// ❌ حذف
    on<RemoveFromFavorites>((event, emit) {
      final updated = state.favorites
          .where((item) => item.id != event.product.id)
          .toList();

      emit(state.copyWith(favorites: updated));
    });

    /// ➕ زيادة الكمية
    on<IncreaseQuantity>((event, emit) {
      final updated = state.favorites.map((item) {
        if (item.id == event.product.id) {
          return ProductModel(
            id: item.id,
            name: item.name,
            price: item.price,
            discount: item.discount,
            image: item.image,
            description: item.description,
            quantity: item.quantity + 1,
          );
        }
        return item;
      }).toList();

      emit(state.copyWith(favorites: updated));
    });

    /// ➖ نقصان الكمية
    on<DecreaseQuantity>((event, emit) {
      final updated = state.favorites.map((item) {
        if (item.id == event.product.id && item.quantity > 1) {
          return ProductModel(
            id: item.id,
            name: item.name,
            price: item.price,
            discount: item.discount,
            image: item.image,
            description: item.description,
            quantity: item.quantity - 1,
          );
        }
        return item;
      }).toList();

      emit(state.copyWith(favorites: updated));
    });
  }
}
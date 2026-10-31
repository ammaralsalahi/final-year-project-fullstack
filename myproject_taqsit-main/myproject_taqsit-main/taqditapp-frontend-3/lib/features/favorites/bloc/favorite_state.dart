import '../../home/data/model/product_model.dart';

class FavoritesState {
  final List<ProductModel> favorites;

  const FavoritesState({this.favorites = const []});

  FavoritesState copyWith({
    List<ProductModel>? favorites,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
    );
  }
}
import '../../home/data/model/product_model.dart';

abstract class FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final ProductModel product;
  AddToFavorites(this.product);
}

class RemoveFromFavorites extends FavoritesEvent {
  final ProductModel product;
  RemoveFromFavorites(this.product);
}

class IncreaseQuantity extends FavoritesEvent {
  final ProductModel product;
  IncreaseQuantity(this.product);
}

class DecreaseQuantity extends FavoritesEvent {
  final ProductModel product;
  DecreaseQuantity(this.product);
}
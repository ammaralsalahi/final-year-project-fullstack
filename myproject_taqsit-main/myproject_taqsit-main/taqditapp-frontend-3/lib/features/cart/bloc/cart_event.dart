import '../../home/data/model/product_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final ProductModel product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final ProductModel product;
  RemoveFromCart(this.product);
}

class IncreaseQuantity extends CartEvent {
  final ProductModel product;
  IncreaseQuantity(this.product);
}

class DecreaseQuantity extends CartEvent {
  final ProductModel product;
  DecreaseQuantity(this.product);
}
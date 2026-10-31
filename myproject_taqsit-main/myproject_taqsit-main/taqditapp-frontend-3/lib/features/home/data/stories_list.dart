// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:installment/features/cart/presentation/pages/cart_page.dart';
import 'package:installment/features/home/data/model/stories_model.dart';

List<Storyitem> storiesList = [
  Storyitem(title: "ملابس", image:"assets/images/iconesvg/tshirt.svg", page: CartPage()),
  Storyitem(title: "احذيه", image:"assets/images/iconesvg/shoes.svg", page: CartPage()),
  Storyitem(title: "اكترونيات", image:"assets/images/iconesvg/electricity.svg", page: CartPage()),
  Storyitem(title: "ادوات منزليه",image:"assets/images/iconesvg/kitchen.svg", page: CartPage()),
  Storyitem(title: "عطور",image:"assets/images/iconesvg/perfume.svg", page: CartPage()),
  Storyitem(title: "ساعات",image:"assets/images/iconesvg/watch.svg", page: CartPage()),
  Storyitem(title: "لابتوبات",image:"assets/images/iconesvg/laptop.svg", page: CartPage()),
];

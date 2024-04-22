import 'package:flutter/material.dart';
import 'package:tecnoshopping/models/products_model.dart';

class PurchaseProductsProvider extends ChangeNotifier {
  Set<Product> _purchasedProducts = {};

  Set<Product> get purchasedProducts => _purchasedProducts;

  void productsPurchasedEmpty() {
    _purchasedProducts = {};
  }
}

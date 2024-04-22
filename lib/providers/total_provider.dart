import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/providers/providers.dart';

class TotalPurchasedProvider extends ChangeNotifier {
  double _purchasedTotal = 0.0;

  double get purchasedTotal => _purchasedTotal;

  void sumarTotalProductsBuy(BuildContext context) {

    final productBuyProvider = Provider.of<PurchaseProductsProvider>(context, listen: false).purchasedProducts;
    final productBuyProviderList = productBuyProvider.toList();
    // Sumar los valores de buy de todos los productos
    double totalBuy = productBuyProviderList.fold<double>(0, (previousValue, product) => previousValue + product.buy);

    _purchasedTotal = totalBuy;
  }

  void purchasedTotalIsZero() {
    _purchasedTotal = 0.0;
  }
}

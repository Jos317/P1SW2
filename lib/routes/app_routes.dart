import 'package:flutter/material.dart';
import '../presentation/success_screen/success_screen.dart';
import '../presentation/info_screen/info_screen.dart';
import '../presentation/home_screen_tab_container_screen/home_screen_tab_container_screen.dart';
import '../presentation/products_cart_screen/products_cart_screen.dart';

class AppRoutes {
  static const String homeScreenPage = '/home_screen_page';

  static const String homeScreenTabContainerScreen =
      '/home_screen_tab_container_screen';

  static const String infoScreen = '/info_screen';

  static const String successScreen = '/success_screen';

  static const String productsCartScreen = '/products_cart_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    homeScreenTabContainerScreen: (context) => HomeScreenTabContainerScreen(),
    productsCartScreen: (context) => ProductsCartScreen(),
    infoScreen: (context) => InfoScreen(),
    successScreen: (context) => SuccessScreen(),
    initialRoute: (context) => HomeScreenTabContainerScreen()
  };
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tecnoshopping/providers/providers.dart';
import 'core/app_export.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51O7Ie0AY23p6KhXHNTj81exQIqEtJQzgw3bmbdUscTh5UQmBZ7kdgwCG7920vd1ML6Xk3Yl2QcH1NAD1wTzVPdfO00UdyppfnW";
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ThemeHelper().changeTheme('primary');
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            ChangeNotifierProvider(create: (_) => PurchaseProductsProvider()),
            ChangeNotifierProvider(create: (_) => TotalPurchasedProvider()),
            ChangeNotifierProvider(create: (_) => ClienteProvider()),
          ],
          child: MaterialApp(
            theme: theme,
            title: 'tecnoshopping',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_search_view.dart';
import '../home_screen_page/home_screen_page.dart';

class HomeScreenTabContainerScreen extends StatefulWidget {
  const HomeScreenTabContainerScreen({Key? key})
      : super(
          key: key,
        );

  @override
  HomeScreenTabContainerScreenState createState() =>
      HomeScreenTabContainerScreenState();
}
class HomeScreenTabContainerScreenState
    extends State<HomeScreenTabContainerScreen> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? tabviewController;
  List<String> categories = ["All"]; // Inicializamos con "All"

  @override
  void initState() {
    super.initState();
    inicializarProductos();
  }

  @override
  void dispose() {
    tabviewController?.dispose(); // Dispose del TabController
    super.dispose();
  }

  Future<void> inicializarProductos() async {
    await Provider.of<ProductsProvider>(context, listen: false).inicializarDatos();
    // Obtener las categorías de los productos del provider
    List<String> allCategories = Provider.of<ProductsProvider>(context, listen: false).getAllCategories();
    // Agregar las categorías al listado
    categories.addAll(allCategories);
    setState(() {
      // Inicializar el TabController con la longitud de las categorías
      tabviewController = TabController(length: categories.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 21.v),
              Padding(
                padding: EdgeInsets.only(
                  left: 20.h,
                  right: 27.h,
                ),
                child: CustomSearchView(
                  controller: searchController,
                  hintText: "Search products",
                ),
              ),
              SizedBox(height: 17.v),
              _buildTabview(context),
              SizedBox(
                height: 550.v,
                child: tabviewController != null ? TabBarView(
                  controller: tabviewController,
                  children: categories.map((category) {
                    return HomeScreenPage(category: category);
                  }).toList(),
                ) : Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final purchaseProducts = Provider.of<PurchaseProductsProvider>(context).purchasedProducts;
    return CustomAppBar(
      actions: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.productsCartScreen),
          child: Container(
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.fromLTRB(32.h, 17.v, 32.h, 15.v),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgShape,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  alignment: Alignment.center,
                ),
                if (purchaseProducts.isNotEmpty) ... [
                  Container(
                    alignment: Alignment.topRight,
                    height: 8.adaptSize,
                    width: 8.adaptSize,
                    margin: EdgeInsets.only(
                      left: 16.h,
                      bottom: 16.v,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.redA700,
                      borderRadius: BorderRadius.circular(
                        4.h,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return SizedBox(
      height: 39.v,
      width: 343.h,
      child: tabviewController != null ? TabBar(
        controller: tabviewController!,
        labelPadding: EdgeInsets.zero,
        labelColor: theme.colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          fontSize: 12.fSize,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: appTheme.gray600,
        unselectedLabelStyle: TextStyle(
          fontSize: 12.fSize,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
        ),
        indicatorPadding: EdgeInsets.symmetric(vertical: 1.h),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10.h,
          ),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.secondaryContainer,
              appTheme.lightBlue700
            ],
          ),
        ),
        tabs: categories.map((categoria) {
          return Tab(
            child: Text(
              categoria,
            ),
          );
        }).toList(),
      )
      : Center(child: CircularProgressIndicator()),
    );
  }
}

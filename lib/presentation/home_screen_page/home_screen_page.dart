import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/models/products_model.dart';
import 'package:tecnoshopping/presentation/detail_product_screen/detail_product_screen.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../core/app_export.dart'; // ignore_for_file: must_be_immutable

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key, required this.category})
      : super(
          key: key,
        );
  
  final String category;

  @override
  HomeScreenPageState createState() => HomeScreenPageState();
}

class HomeScreenPageState extends State<HomeScreenPage>
    with AutomaticKeepAliveClientMixin<HomeScreenPage> {
  @override
  bool get wantKeepAlive => true;
  late Products productsXCategory;

  @override
  void initState() {
    super.initState();
    final Products allProducts =  Provider.of<ProductsProvider>(context, listen: false).products!;
    if (widget.category != 'All'){
      // Filtramos los productos por categoría
      productsXCategory = Products(
        products: allProducts.products
            .where((product) => product.category.name == widget.category)
            .toList(),
      );
    } else {
      productsXCategory = allProducts;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: appTheme.gray50,
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.fillGray,
        child: _buildGeneralColumn(context)
      ),
    );
  }

  /// Section Widget
  Widget _buildGeneralColumn(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 27.v),
          Text(
            "General Products",
            style: CustomTextStyles.titleLarge22,
          ),
          SizedBox(height: 10.v),
          Container(
            height: 450.v,
            child: Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Indica el número de columnas
                  crossAxisSpacing: 10.0, // Espacio horizontal entre elementos
                  mainAxisSpacing: 10.0, // Espacio vertical entre elementos
                  childAspectRatio: 0.7, // Relación de aspecto de los elementos (ancho / alto)
                ),
                itemCount: productsXCategory.products.length,
                itemBuilder: (context, index) {
                  final producto = productsXCategory.products[index];
                  return _buildProductoStack(
                    context,
                    product: producto,
                  );
                },
              )
            ),
          )
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildProductoStack(
    BuildContext context, {
    required Product product
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailProductScreen(product: product)),
        );
      },
      child: SizedBox(
        height: 215.v,
        width: 158.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomImageView(
              imagePath: (product.url.isNotEmpty) ? product.url : ImageConstant.imageNotFound,
              height: 170.v,
              width: 140.h,
              radius: BorderRadius.circular(
                20.h,
              ),
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 7.v,
                ),
                decoration: AppDecoration.gradientBlackToBlack.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 162.v),
                    Text(
                      product.name,
                      style: CustomTextStyles.titleMediumMedium.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.v),
                    Text(
                      product.brand,
                      style: CustomTextStyles.bodySmallBluegray10001.copyWith(
                        color: appTheme.blueGray10001,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

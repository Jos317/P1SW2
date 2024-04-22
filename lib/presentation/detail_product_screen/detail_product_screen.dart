import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/models/products_model.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';

class DetailProductScreen extends StatelessWidget {
  const DetailProductScreen({Key? key, required this.product})
      : super(
          key: key,
        );

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDreamsville(context),
              SizedBox(height: 13.v),
              Text(
                "About",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 15.v),
              Container(
                width: 327.h,
                margin: EdgeInsets.only(right: 7.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: product.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 15.v),
              Text(
                "Price",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 15.v),
              Text(
                product.price.toString() + " bs",
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 15.v),
              Text(
                "Stock",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 15.v),
              Text(
                product.quantity.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 15.v),
              Text(
                "Category",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 15.v),
              Text(
                product.category.name,
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 5.v)
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonaddcart(context, product),
      ),
    );
  }

  /// Section Widget
  Widget _buildDreamsville(BuildContext context) {
    return SizedBox(
      height: 319.v,
      width: 335.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Opacity(
            opacity: 0.1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 106.v,
                width: 295.h,
                decoration: BoxDecoration(
                  color: appTheme.black900.withOpacity(0.39),
                  borderRadius: BorderRadius.circular(
                    20.h,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 304.v,
              width: 335.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomImageView(
                    imagePath: (product.url.isNotEmpty) ? product.url : ImageConstant.imageNotFound,
                    height: 304.v,
                    width: 335.h,
                    radius: BorderRadius.circular(
                      20.h,
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.h,
                        vertical: 14.v,
                      ),
                      decoration:
                          AppDecoration.gradientBlackToBlack900.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.v),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButton(
                                height: 34.adaptSize,
                                width: 34.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                onTap: () {
                                  onTapBtnArrowleftone(context);
                                },
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgArrowLeft,
                                ),
                              ),
                              CustomIconButton(
                                height: 34.adaptSize,
                                width: 34.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgIcBookmark,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 175.v),
                          Container(
                            height: 33,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Text(
                                    product.name,
                                    style: CustomTextStyles.titleLargeOnPrimaryContainer,
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 7.v),
                          Text(
                            product.brand,
                            style: CustomTextStyles.bodySmallBluegray100,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildButtonaddcart(BuildContext context, Product product) {
    return Container(
      margin: EdgeInsets.only(
        left: 58.h,
        right: 58.h,
        bottom: 18.v,
      ),
      decoration: AppDecoration.gradientSecondaryContainerToLightBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: CustomElevatedButton(
        text: "Add to Cart",
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientPrimaryToLightBlueDecoration,
        buttonTextStyle: theme.textTheme.titleMedium!,
        onPressed: () {
          onTapAddtocart(context, product);
        },
      ),
    );
  }

  /// Navigates back to the previous screen.
  onTapBtnArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  void onTapAddtocart(BuildContext context, Product product) {
    // Acceder al provider PurchaseProductsProvider
    final purchaseProvider = Provider.of<PurchaseProductsProvider>(context, listen: false);

    // Añadir el producto a la lista de productos comprados
    purchaseProvider.purchasedProducts.add(product);

    // Notificar a los oyentes (si los hay) que se han realizado cambios en el provider
    purchaseProvider.notifyListeners();

    Provider.of<TotalPurchasedProvider>(context, listen: false).sumarTotalProductsBuy(context);
  }
}

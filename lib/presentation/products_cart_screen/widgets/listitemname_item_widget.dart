import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/models/products_model.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_icon_button.dart'; // ignore: must_be_immutable

class ListitemnameItemWidget extends StatelessWidget {
  const ListitemnameItemWidget({Key? key, required this.product})
      : super(
          key: key,
        );

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.white.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomImageView(
            imagePath: (product.url.isNotEmpty) ? product.url : ImageConstant.imageNotFound,
            height: 104.v,
            width: 82.h,
            radius: BorderRadius.horizontal(
              left: Radius.circular(8.h),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.v,
              bottom: 6.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: CustomTextStyles.titleLargeOnPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 4.v),
                Text(
                  "Precio: " + product.price.toStringAsFixed(2) + " bs",
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 4.v),
                SizedBox(
                  width: 219.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quantity:",
                            style: theme.textTheme.labelLarge,
                          ),
                          SizedBox(
                            width: 65.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIconButton(
                                  onTap: () {
                                    if (product.purchased > 1) {
                                      final purchaseProducts = Provider.of<PurchaseProductsProvider>(context, listen: false);
                                      final productFind = purchaseProducts.purchasedProducts.firstWhere((productElement) => product.id == productElement.id);
                                      productFind.purchased--;
                                      productFind.buy = productFind.purchased * productFind.price;
                                      purchaseProducts.notifyListeners();
                                      Provider.of<TotalPurchasedProvider>(context, listen: false).sumarTotalProductsBuy(context);
                                    }
                                  },
                                  height: 25.adaptSize,
                                  width: 25.adaptSize,
                                  decoration:
                                      IconButtonStyleHelper.outlineBlack,
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgIcon,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 7.v,
                                    bottom: 5.v,
                                  ),
                                  child: Text(
                                    product.purchased.toString(),
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ),
                                CustomIconButton(
                                  onTap: () {
                                    if (product.purchased < product.quantity) {
                                      final purchaseProducts = Provider.of<PurchaseProductsProvider>(context, listen: false);
                                      final productFind = purchaseProducts.purchasedProducts.firstWhere((productElement) => product.id == productElement.id);
                                      productFind.purchased++;
                                      productFind.buy = productFind.purchased * productFind.price;
                                      purchaseProducts.notifyListeners();
                                      Provider.of<TotalPurchasedProvider>(context, listen: false).sumarTotalProductsBuy(context);
                                    }
                                  },
                                  height: 25.adaptSize,
                                  width: 25.adaptSize,
                                  decoration:
                                      IconButtonStyleHelper.outlineBlack,
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgIconGray500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          final purchaseProducts = Provider.of<PurchaseProductsProvider>(context, listen: false);
                          purchaseProducts.purchasedProducts.removeWhere((productElement) => product.id == productElement.id);
                          purchaseProducts.notifyListeners();
                          Provider.of<TotalPurchasedProvider>(context, listen: false).sumarTotalProductsBuy(context);
                        },
                        height: 26.v,
                        width: 88.h,
                        text: "Remove",
                        margin: EdgeInsets.only(
                          top: 8.v,
                          bottom: 5.v,
                        ),
                        buttonStyle: CustomButtonStyles.outlineRedF,
                        buttonTextStyle:
                            CustomTextStyles.titleSmallOnPrimaryContainer,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

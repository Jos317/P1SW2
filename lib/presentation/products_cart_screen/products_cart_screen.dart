import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'widgets/listitemname_item_widget.dart';

class ProductsCartScreen extends StatelessWidget {
  const ProductsCartScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final purchaseProducts = Provider.of<PurchaseProductsProvider>(context).purchasedProducts;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(context),
        body: purchaseProducts.isNotEmpty
        ? Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 15.h,
            vertical: 28.v,
          ),
          child: Column(
            children: [
              _buildListItemName(context),
              Spacer(),
              SizedBox(height: 7.v),
              _buildTotal(context)
            ],
          ),
        )
        : Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 58.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCart,
                height: 59.adaptSize,
                width: 59.adaptSize,
              ),
              SizedBox(height: 5.v),
              SizedBox(
                width: 255.h,
                child: Text(
                  "Empty shopping cart...",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: purchaseProducts.isNotEmpty ? _buildBuy(context) : null,
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 51.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 17.h,
          top: 11.v,
          bottom: 11.v,
        ),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "Cart",
      ),
    );
  }

  /// Section Widget
  Widget _buildListItemName(BuildContext context) {
    final purchaseProducts = Provider.of<PurchaseProductsProvider>(context).purchasedProducts;
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 22.v,
          );
        },
        itemCount: purchaseProducts.length,
        itemBuilder: (context, index) {
          final purchasedProductsList = purchaseProducts.toList();
          final producto = purchasedProductsList[index];
          return ListitemnameItemWidget(product: producto);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildTotal(BuildContext context) {
    final purchasedTotal = Provider.of<TotalPurchasedProvider>(context).purchasedTotal;
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 1.v,
              bottom: 3.v,
            ),
            child: Text(
              "Total Bs:",
              style: CustomTextStyles.bodyMediumGray500,
            ),
          ),
          Text(
            purchasedTotal.toStringAsFixed(2),
            style: CustomTextStyles.bodyLargeOnPrimary,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBuy(BuildContext context) {
    return CustomElevatedButton(
      text: "Buy",
      margin: EdgeInsets.only(
        left: 16.h,
        right: 15.h,
        bottom: 19.v,
      ),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToLightBlueDecoration,
      buttonTextStyle: theme.textTheme.titleMedium!,
      onPressed: () {
        onTapBuy(context);
      },
    );
  }

  /// Navigates back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  onTapBuy(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.infoScreen);
  }
}

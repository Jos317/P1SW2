import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/presentation/success_screen/helpers/generate_pdf.dart';
import 'package:tecnoshopping/providers/providers.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.blue200,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.v),
              Container(
                height: MediaQuery.of(context).size.height * .86,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.h,
                  vertical: 140.v,
                ),
                decoration: AppDecoration.outlineBlack900.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder42,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _buildBuySuccessfulColumn(context),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 199.adaptSize,
                        width: 199.adaptSize,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 9.v,
                        ),
                        decoration: AppDecoration.gradientBlueToCyan.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder99,
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgImage,
                          height: 166.adaptSize,
                          width: 166.adaptSize,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildBuySuccessfulColumn(BuildContext context) {
    final purchasedTotal = Provider.of<TotalPurchasedProvider>(context).purchasedTotal;
    final cliente = Provider.of<ClienteProvider>(context).cliente;
    final productPurchasedSetProvider = Provider.of<PurchaseProductsProvider>(context).purchasedProducts;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(left: 1.h),
        padding: EdgeInsets.symmetric(
          horizontal: 36.h,
          vertical: 38.v,
        ),
        decoration: AppDecoration.outlineBlack900.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 150.v),
            Container(
              width: 265.h,
              margin: EdgeInsets.only(right: 5.h),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Buy Successful\n",
                      style: theme.textTheme.titleLarge,
                    ),
                    TextSpan(
                      text: "Compra realizada con exito",
                      style: theme.textTheme.bodyLarge,
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25.v),
            CustomElevatedButton(
              onPressed: () async {
                final productPurchasedList = productPurchasedSetProvider.toList();
                final fileLocation = await generatePDF(purchasedTotal, productPurchasedList, cliente!);
                OpenFile.open(fileLocation);
              },
              text: "Ver Factura",
              margin: EdgeInsets.only(
                left: 6.h,
                right: 5.h,
              ),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles
                  .gradientPrimaryToSecondaryContainerDecoration,
              buttonTextStyle: theme.textTheme.titleMedium!,
            ),
            SizedBox(height: 10.v),
            CustomElevatedButton(
              onPressed: () {
                final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                productsProvider.productsNull();
                final productPurchasedSetProvider = Provider.of<PurchaseProductsProvider>(context, listen: false);
                productPurchasedSetProvider.productsPurchasedEmpty();
                final purchasedTotalProvider = Provider.of<TotalPurchasedProvider>(context, listen: false);
                purchasedTotalProvider.purchasedTotalIsZero();
                final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
                clienteProvider.clienteNull();
                Navigator.pushNamed(context, AppRoutes.homeScreenTabContainerScreen);
              },
              text: "Volver",
              margin: EdgeInsets.only(
                left: 6.h,
                right: 5.h,
              ),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles
                  .gradientColorsContainerDecoration,
              buttonTextStyle: theme.textTheme.titleMedium!,
            )
          ],
        ),
      ),
    );
  }
}

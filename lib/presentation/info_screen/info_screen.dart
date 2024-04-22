import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecnoshopping/models/cliente_model.dart';
import 'package:tecnoshopping/providers/providers.dart';
import 'package:tecnoshopping/services/compra_services.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_text_field.dart';

import 'dart:convert';

// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class InfoScreen extends StatefulWidget {
  InfoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController ciValueController = TextEditingController();

  TextEditingController nombreValueController = TextEditingController();

  TextEditingController apellidoValueController = TextEditingController();

  TextEditingController telefonoValueController = TextEditingController();

  Map<String, dynamic>? paymentIntent;

  // void makePayment(double total) async {
  //   String totalString = total.toStringAsFixed(2).replaceAll('.', '');
  //   try {
  //     paymentIntent = await createPaymentIntent(totalString);
  //     var gpay = const PaymentSheetGooglePay(
  //       merchantCountryCode: "US",
  //       currencyCode: "US",
  //       testEnv: true,
  //     );
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //       paymentIntentClientSecret: paymentIntent!["client_secret"],
  //       style: ThemeMode.dark,
  //       merchantDisplayName: "",
  //       googlePay: gpay,
  //     ));

  //     await displayPaymentSheet();
  //   } catch (e) {
  //     Exception(e.toString());
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     debugPrint("Done");
  //   } catch (e) {
  //     debugPrint("Failde");
  //   }
  // }

  // createPaymentIntent(String total) async {
  //   try {

  //     Map<String, dynamic> body = {
  //       "amount": "${total}",
  //       "currency": "USD",
  //     };

  //     http.Response response = await http.post(
  //         Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //         body: body,
  //         headers: {
  //           "Authorization":
  //               "Bearer sk_test_51O7Ie0AY23p6KhXHMB1cn0MvftzATjcs36rNJBC75b2joKuBvJM3HDdYSpZvkGgcGB922gHNLkklW7OYoCMuKgje00Oac710XJ",
  //           "Content-Type": "application/x-www-form-urlencoded",
  //         });
  //     return json.decode(response.body);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Este campo no puede estar vacío";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Activa la validación dinámica
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 27.v,
            ),
            child: Column(
              children: [
                _buildTextField(context, ciValueController, "CI"),
                SizedBox(height: 20.v),
                _buildTextField(context, nombreValueController, "Nombre"),
                SizedBox(height: 20.v),
                _buildTextField(context, apellidoValueController, "Apellido"),
                SizedBox(height: 20.v),
                _buildTextField(context, telefonoValueController, "Telefono", textInputAction: TextInputAction.done),
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBuyNowButton(context, ciValueController, nombreValueController, apellidoValueController, telefonoValueController),
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
        text: "Adding Info",
      ),
    );
  }

  /// Section Widget
  Widget _buildTextField(BuildContext context, TextEditingController controller, String labelText, {TextInputAction? textInputAction}) {
    return CustomFloatingTextField(
      validator: _validateInput,
      controller: controller,
      labelText: labelText,
      labelStyle: theme.textTheme.bodyMedium!,
      hintText: labelText,
      textInputAction: textInputAction,
      textInputType: (labelText == "CI" || labelText == "Telefono") ? TextInputType.number : TextInputType.text
    );
  }

  /// Section Widget
  Widget _buildBuyNowButton(BuildContext context, TextEditingController controller1, TextEditingController controller2, TextEditingController controller3, TextEditingController controller4) {
    final purchasedTotal = Provider.of<TotalPurchasedProvider>(context).purchasedTotal;
    return CustomElevatedButton(
      text: "Buy NOW",
      margin: EdgeInsets.only(left: 17.h, right: 14.h, bottom: 21.v),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToSecondaryContainerDecoration,
      buttonTextStyle: theme.textTheme.titleMedium!,
      onPressed: () async{
        if (_formKey.currentState!.validate()) { // Validar el formulario antes de proceder
          final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
          Cliente cliente = Cliente(int.parse(controller1.text), controller2.text, controller3.text, controller4.text);
          clienteProvider.ponerCliente(cliente);
          obtenerDatosCompra(context).then((datosCompra) {
            realizarCompra(datosCompra)
              .then((mensaje) => print(mensaje))
              .catchError((error) => print(error));
          }).catchError((error) => print(error));
          // makePayment(purchasedTotal);
          onTapBuyNow(context); // Si la validación es exitosa, proceder con la acción del botón
        }
      },
    );
  }

  /// Navigates back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the successScreen when the action is triggered.
  onTapBuyNow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.successScreen);
  }
}

import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentFailPopup extends StatefulWidget {
  String paymentFailMessage;

  PaymentFailPopup({required this.paymentFailMessage, Key? key})
      : super(key: key);

  @override
  _PaymentFailPopupPopupState createState() => _PaymentFailPopupPopupState();
}

class _PaymentFailPopupPopupState extends State<PaymentFailPopup> {
  String menuName = StringConstants.customMenuPackage;
  bool isEditingMenuName = false;
  var amountTextFieldController = TextEditingController();
  var menuNameTextFieldController = TextEditingController();
  String cardNumberValidationMessage = "";
  String cardDateValidationMessage = "";
  String cardCvvValidationMessage = "";
  String cardNumber = "4111111111111111",
      cardCvc = "123",
      cardExpiryYear = "22",
      cardExpiryMonth = "12";
  String stripeTokenId = "", stripePaymentMethodId = "";
  String demoCardNumber = "";
  bool isCardNumberValid = false;
  bool isExpiryValid = false;
  bool isCvcValid = false;
  bool isApiProcess = false;
  late PaymentPresenter paymentPresenter;
  TextEditingController dateExpiryController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

  _PaymentFailPopupPopupState() {
    // paymentPresenter = PaymentPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: showCustomMenuPopup(),
    );
  }

  Widget showCustomMenuPopup() {
    return Dialog(
      backgroundColor: getMaterialColor(AppColors.whiteColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: customMenuPopUpComponent(),
    );
  }

  Widget customMenuPopUpComponent() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().popUpTopView(
                title: StringConstants.paymentFail,
                onTapCloseButton: onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 23.0, bottom: 10.0),
              child: CommonWidgets().textWidget(
                  StringConstants.paymentFailMessage,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular),
                  textAlign: TextAlign.left),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.okay,
                  onTapCloseButton,
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  onTapCloseButton() {
    Navigator.of(context).pop(false);
  }
}

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

class CreditCardDetailsPopup extends StatefulWidget {
  String totalAmount;

  CreditCardDetailsPopup({required this.totalAmount, Key? key})
      : super(key: key);

  @override
  _CreditCardDetailsPopupState createState() => _CreditCardDetailsPopupState();
}

class _CreditCardDetailsPopupState extends State<CreditCardDetailsPopup> {
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

  _CreditCardDetailsPopupState() {
    // paymentPresenter = PaymentPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
        isCallInProgress: isApiProcess,
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: showCustomMenuPopup(),
        ));
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
                title: StringConstants.addCreditCardDetails,
                onTapCloseButton: onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 23.0, bottom: 10.0),
              child: profileDetailsComponent(
                  StringConstants.cardNumber,
                  "",
                  StringConstants.cardNumber,
                  cardNumberController,
                  cardNumberValidationMessage,
                  cardValidation,
                  15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                    child: cardExpiryComponent(
                        StringConstants.cardExpiry,
                        "",
                        StringConstants.cardExpiryMsg,
                        dateExpiryController,
                        cardDateValidationMessage,
                        dateValidation,
                        5),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: profileDetailsComponent(
                        StringConstants.cardCvc,
                        "",
                        StringConstants.cardCvcMsg,
                        cvcController,
                        cardCvvValidationMessage,
                        cvvValidation,
                        3),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.submit + " " + "\$ " + widget.totalAmount,
                  onTapConfirmManualCardPayment,
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

  Widget profileDetailsComponent(
          String txtName,
          String txtValue,
          String txtHint,
          TextEditingController textEditingController,
          String validationMessage,
          Function validationMethod,
          int maxLength) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  maxLength: maxLength,
                  onChanged: (value) {
                    validationMethod();
                    debugPrint('============>');
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      hintText: txtHint,
                      border: InputBorder.none,
                      labelText: txtValue,
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Text(validationMessage,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor5),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left)
        ],
      );

  Widget cardExpiryComponent(
          String txtName,
          String txtValue,
          String txtHint,
          TextEditingController textEditingController,
          String validationMessage,
          Function validationMethod,
          int maxLength) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  maxLength: maxLength,
                  inputFormatters: [maskFormatter],
                  onChanged: (value) {
                    validationMethod();
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      hintText: txtHint,
                      border: InputBorder.none,
                      labelText: txtValue,
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Text(validationMessage,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor5),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left)
        ],
      );

  //Action
  onTapCloseButton() {
    Navigator.of(context).pop(false);
  }

  cardValidation() {
    debugPrint('validation');
    if (cardNumberController.text.isEmpty) {
      setState(() {
        debugPrint('validation$cardNumberValidationMessage');
        cardNumberValidationMessage = "Please Enter Card Details";
        isCardNumberValid = false;
      });
      return false;
    } else {
      setState(() {
        debugPrint('validationFull$cardNumberValidationMessage');
        cardNumberValidationMessage = "";
        isCardNumberValid = true;
      });
    }
  }

  dateValidation() {
    var date, year;
    try {
      String s = dateExpiryController.text;
      int idx = s.indexOf("/");
      date = int.parse(s.substring(0, idx).trim());
      year = int.parse(s.substring(idx + 1).trim());
    } catch (error) {
      debugPrint(error.toString());
    }

    debugPrint('validation');
    if (dateExpiryController.text.isEmpty) {
      setState(() {
        cardDateValidationMessage = "Please Enter Date";
        isExpiryValid = false;
      });
    } else if (date > 31) {
      setState(() {
        cardDateValidationMessage = "Please Check Date";
        isExpiryValid = false;
      });
    }
    if (year > 12) {
      setState(() {
        cardDateValidationMessage = "Please Check Year";
        isExpiryValid = false;
      });
    } else {
      setState(() {
        cardDateValidationMessage = "";
        isExpiryValid = true;
      });
    }
  }

  cvvValidation() {
    if (cvcController.text.isEmpty) {
      setState(() {
        cardCvvValidationMessage = "Please Enter Card Details";
        isCvcValid = false;
      });
      return false;
    } else {
      setState(() {
        cardCvvValidationMessage = "";
        isCvcValid = true;
      });
    }
  }

  void onTapConfirmManualCardPayment() {
    if (isCardNumberValid && isExpiryValid && isCvcValid) {
      Navigator.of(context).pop(true);
    }
  }
}

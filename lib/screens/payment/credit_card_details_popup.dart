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

class CreditCardDetailsPopup extends StatefulWidget {
  const CreditCardDetailsPopup({Key? key}) : super(key: key);

  @override
  _CreditCardDetailsPopupState createState() => _CreditCardDetailsPopupState();
}

class _CreditCardDetailsPopupState extends State<CreditCardDetailsPopup> implements ResponseContractor {

  String menuName = StringConstants.customMenuPackage;
  bool isEditingMenuName = false;
  var amountTextFieldController = TextEditingController();
  var menuNameTextFieldController = TextEditingController();
  String cardNumberValidationMessage = "";
  String cardNumber="4111111111111111",cardCvc="123",cardExpiryYear="22",cardExpiryMonth="12";
  String stripeTokenId="",stripePaymentMethodId="";
  String demoCardNumber = "";
  bool isCardNumberValid = true;
  bool isCvcValid = true;
  bool isApiProcess = false;
  late PaymentPresenter paymentPresenter;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

  _CreditCardDetailsPopupState(){
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
            CommonWidgets().popUpTopView(title: StringConstants.customMenu,
                onTapCloseButton: onTapCloseButton),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.cardNumber, "",
                  StringConstants.cardNumber, cardNumberController,"",passwordValidation),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
                    child: cvvAndDateComponent(StringConstants.cardCvc, "",
                        StringConstants.cardCvc, cvcController,"",passwordValidation),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 10.0, right: 23.0, bottom: 10.0),
                    child: cvvAndDateComponent(StringConstants.cardCvc, "",
                        StringConstants.cardCvc, cvcController,"",passwordValidation),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.submit,
                  onTapConfirmPayment,
                ),
              ],
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
      ) =>
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
                top: 5.0, bottom: 0.0, left: 0.0, right: 0.0),
            child: Container(
              height: 40.0,
              width: 500.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  onChanged: (value) {
                    validationMethod();
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
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
  Widget cvvAndDateComponent(
      String txtName,
      String txtValue,
      String txtHint,
      TextEditingController textEditingController,
      String validationMessage,
      Function validationMethod,
      ) =>
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
                top: 5.0, bottom: 0.0, left: 0.0, right: 0.0),
            child: Container(
              height: 40.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  onChanged: (value) {
                    validationMethod();
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
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
  passwordValidation() {

    if (cardNumberController.text.isEmpty) {
      setState(() {
        cardNumberValidationMessage = "Please Enter Card Details";
      });
      return false;
    }

    return true;
  }


  //Action
  onTapCloseButton() {
    Navigator.of(context).pop();
  }

  onTapConfirmPayment() {

    setState(() {
      cardNumberController.text.isEmpty
          ? isCardNumberValid = false
          : isCardNumberValid = true;
    });

    //TokenMethodApi call
    getTokenCall(cardNumber, cardCvc, cardExpiryMonth, cardExpiryYear);

    Navigator.pop(context);
  }

  void getTokenCall(String cardNumber, String cardCvc, String expiryMonth,
      String expiryYear) {
    final body = {
      "card[number]": cardNumber,
      "card[cvc]": cardCvc,
      "card[exp_month]": expiryMonth,
      "card[exp_year]": expiryYear};
    paymentPresenter.getToken(body);
  }
  void getMethodPayment(String cardNumber, String cardCvc, String expiryMonth,
      String expiryYear) {
    final bodyPaymentMethod = {
      "type": "card",
      "card[number]": cardNumber,
      "card[cvc]": cardCvc,
      "card[exp_month]": expiryMonth,
      "card[exp_year]": expiryYear};
    paymentPresenter.getPaymentMethod(bodyPaymentMethod);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSuccess(response) {
    // TODO: implement showSuccess
  }

}

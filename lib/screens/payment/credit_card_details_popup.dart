import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

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
  String cardYearValidationMessage = "";
  String demoCardNumber = "";
  bool isCardNumberValid = false;
  bool isExpiryValid = false;
  bool isYearValid = false;
  int yearOfExpiryInt=0;
  late PaymentPresenter paymentPresenter;
  TextEditingController dateExpiryController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  _CreditCardDetailsPopupState() {
  }

  @override
  void initState() {
    super.initState();
    DateTime dateToday =DateTime.now();
    String date = dateToday.toString().substring(0,10);
    var yearOfDate = date.split('-');
    String yearOfExpiryString=yearOfDate[0];
    yearOfExpiryInt=int.parse(yearOfExpiryString);

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                  18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                    child: profileDetailsComponent(
                        StringConstants.cardExpiryMonth,
                        "",
                        StringConstants.cardExpiryMsg,
                        dateExpiryController,
                        cardDateValidationMessage,
                        dateValidation,
                        2),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: profileDetailsComponent(
                        StringConstants.cardExpiryYear,
                        "",
                        StringConstants.cardExpiryYear,
                        yearController,
                        cardYearValidationMessage,
                        yearValidation,
                        4),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.pay + " " + "\$" + widget.totalAmount,
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
                  keyboardType: TextInputType.number,
                  maxLength: maxLength,
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
    if (cardNumberController.text.isEmpty) {
      setState(() {
        cardNumberValidationMessage = StringConstants.cardNumber;
      });
      return false;
    } else {
      setState(() {
        cardNumberValidationMessage = "";
      });
      isCardNumberValid = true;
    }
  }

  dateValidation() {
    int cardMonth = int.parse(dateExpiryController.text);

    if (dateExpiryController.text == "") {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isExpiryValid = false;
    }
    if (cardMonth > 12) {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryCheckkMsg;
      });
      isExpiryValid = false;
    } else {
      setState(() {
        cardDateValidationMessage = "";
      });
      isExpiryValid = true;
    }
  }

  yearValidation() {
    int cardYear = int.parse(yearController.text);

    if (yearController.text.isEmpty) {
      setState(() {
        cardYearValidationMessage = StringConstants.cardExpiryYearEnterMsg;
      });
      return false;
    }
    if (cardYear < yearOfExpiryInt) {
      setState(() {
        cardYearValidationMessage = StringConstants.cardExpiryYearCheckMsg;
      });
      isYearValid = false;
    } else {
      setState(() {
        cardYearValidationMessage = "";
      });
      isYearValid = true;
    }
  }

  void onTapConfirmManualCardPayment() {
    if (isExpiryValid == false) {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isExpiryValid = false;
    }
    if (yearController.text.isEmpty) {
      setState(() {
        cardYearValidationMessage =  StringConstants.cardExpiryYearEnterMsg;
      });
      isYearValid = false;
    }
    if (cardNumberController.text.isEmpty) {
      setState(() {
        cardNumberValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isCardNumberValid = false;
    }
    if (isCardNumberValid && isExpiryValid && isYearValid) {
      Map<String, dynamic> myData = {};
      myData[ConstatKeys.cardValue] = true;
      myData[ConstatKeys.cardNumber] = cardNumberController.text;
      myData[ConstatKeys.cardMonth] = dateExpiryController.text;
      myData[ConstatKeys.cardYear] = yearController.text;
      Navigator.pop(context, myData);
    }
  }
}

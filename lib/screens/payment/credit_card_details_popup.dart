import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
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
  String cardNumberValidationMessage = "";
  String zipcodeValidationMessage = "";
  String cardDateValidationMessage = "";
  String cardYearValidationMessage = "";
  String cvvValidationMessage = "";
  String demoCardNumber = "";
  bool isCardNumberValid = false;
  bool isZipCodeValid = false;
  bool isExpiryValid = false;
  bool isYearValid = false;
  bool isCvvValid = false;
  int yearOfExpiryInt = 0;
  var month, year;
  String spliitYear = "";
  late PaymentPresenter paymentPresenter;
  TextEditingController dateExpiryController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  // {cardNumber: 4111111111111111, expirationYear: 2023, expirationMonth: 12, cvv: 123, zipcode: 90404}
  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  _CreditCardDetailsPopupState() {}

  @override
  void initState() {
    super.initState();
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    var yearOfDate = date.split('-');
    String yearOfExpiryString = yearOfDate[0];
    spliitYear = yearOfExpiryString.toString().substring(0, 2);
    yearOfExpiryInt = int.parse(spliitYear);
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
      backgroundColor: AppColors.whiteColor,
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
              padding: const EdgeInsets.only(top: 25.0, left: 23.0),
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
                    padding: const EdgeInsets.only(left: 20.0),
                    child: cardExpiryComponent(
                        StringConstants.cardExpiryMonthYear,
                        "",
                        StringConstants.cardExpiryMonthYear,
                        dateExpiryController,
                        cardDateValidationMessage,
                        dateValidation,
                        7),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: profileDetailsComponent(
                        StringConstants.cardCvcMsg,
                        "",
                        StringConstants.cardCvcMsg,
                        cvvController,
                        cvvValidationMessage,
                        cvvValidation,
                        3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: profileDetailsComponent(
                  StringConstants.enterZipcode,
                  "",
                  StringConstants.enterZipcode,
                  zipCodeController,
                  zipcodeValidationMessage,
                  zipCodeValidation,
                  6),
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
                  color: AppColors.textColor1,
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
                      color: AppColors.textColor1
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  inputFormatters: [maskFormatter],
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
                          color: AppColors.textColor1,
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
                  color: AppColors.textColor1,
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
                      color: AppColors.textColor1
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
                          color: AppColors.textColor1,
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

  zipCodeValidation() {
    if (zipCodeController.text.isEmpty) {
      setState(() {
        zipcodeValidationMessage = StringConstants.enterZipcode;
      });
      isZipCodeValid = false;
    } else {
      setState(() {
        zipcodeValidationMessage = "";
      });
      isZipCodeValid = true;
    }
  }

  dateValidation() {
    try {
      String s = dateExpiryController.text;
      int idx = s.indexOf("/");
      month = int.parse(s.substring(0, idx).trim());
      year = int.parse(s.substring(idx + 1).trim());
    } catch (error) {
      debugPrint(error.toString());
    }

    if (dateExpiryController.text.isEmpty) {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isExpiryValid = false;
    }
    if (dateExpiryController.text.length < 5) {
      debugPrint('>>>>>>>>${dateExpiryController.text.length}');
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isExpiryValid = false;
    }
    if (month!=null) {
      if (month > 12) {
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

  }

  cvvValidation() {
    if (cvvController.text.isEmpty) {
      setState(() {
        cvvValidationMessage = StringConstants.cvvEnterMsg;
      });
      return false;
    } else {
      setState(() {
        cvvValidationMessage = "";
      });
      isCvvValid = true;
    }
  }

  void onTapConfirmManualCardPayment() {
    String stringValueYear = year.toString();
    if (isExpiryValid == false) {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isExpiryValid = false;
    }
    if (dateExpiryController.text.isEmpty) {
      setState(() {
        cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isYearValid = false;
    }
    if (cardNumberController.text.isEmpty) {
      setState(() {
        cardNumberValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      isCardNumberValid = false;
    }
    if (isCardNumberValid && isExpiryValid && isCvvValid && isZipCodeValid) {
      Map<String, dynamic> myData = {};
      myData[ConstantKeys.cardValue] = true;
      myData[ConstantKeys.cardNumber] = cardNumberController.text;
      myData[ConstantKeys.cardExpiry] = spliitYear + stringValueYear;
      myData[ConstantKeys.cardCvv] = cvvController.text;
      myData[ConstantKeys.cardMonth] = month;
      myData[ConstantKeys.zipcode] = zipCodeController.text;
      Navigator.pop(context, myData);
    }
  }
}

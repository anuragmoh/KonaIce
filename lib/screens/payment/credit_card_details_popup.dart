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
  String _cardNumberValidationMessage = "";
  String _zipcodeValidationMessage = "";
  String _cardDateValidationMessage = "";
  String _cvvValidationMessage = "";
  bool _isCardNumberValid = false;
  bool _isZipCodeValid = false;
  bool _isExpiryValid = false;
  bool _isYearValid = false;
  bool _isCvvValid = false;
  int _yearOfExpiryInt = 0;
  var _month, _year;
  String _spliitYear = "";
  late PaymentPresenter _paymentPresenter;
  TextEditingController _dateExpiryController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  var _maskFormatter = MaskTextInputFormatter(
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
    _spliitYear = yearOfExpiryString.toString().substring(0, 2);
    _yearOfExpiryInt = int.parse(_spliitYear);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: _showCustomMenuPopup(),
    );
  }

  Widget _showCustomMenuPopup() {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: _customMenuPopUpComponent(),
    );
  }

  Widget _customMenuPopUpComponent() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().popUpTopView(
                title: StringConstants.addCreditCardDetails,
                onTapCloseButton: _onTapCloseButton),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 23.0),
              child: _profileDetailsComponent(
                  StringConstants.cardNumber,
                  "",
                  StringConstants.cardNumber,
                  _cardNumberController,
                  _cardNumberValidationMessage,
                  _cardValidation,
                  18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _cardExpiryComponent(
                        StringConstants.cardExpiryMonthYear,
                        "",
                        StringConstants.cardExpiryMonthYear,
                        _dateExpiryController,
                        _cardDateValidationMessage,
                        _dateValidation,
                        7),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: _profileDetailsComponent(
                        StringConstants.cardCvcMsg,
                        "",
                        StringConstants.cardCvcMsg,
                        _cvvController,
                        _cvvValidationMessage,
                        _cvvValidation,
                        3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: _profileDetailsComponent(
                  StringConstants.enterZipcode,
                  "",
                  StringConstants.enterZipcode,
                  _zipCodeController,
                  _zipcodeValidationMessage,
                  _zipCodeValidation,
                  6),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.pay + " " + "\$" + widget.totalAmount,
                  _onTapConfirmManualCardPayment,
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

  Widget _cardExpiryComponent(
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
              height: 45.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: AppColors.textColor1.withOpacity(0.2), width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, top: 0.0),
                child: TextField(
                  inputFormatters: [_maskFormatter],
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

  Widget _profileDetailsComponent(
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
              height: 45.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: AppColors.textColor1.withOpacity(0.2), width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, top: 0.0),
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
  _onTapCloseButton() {
    Navigator.of(context).pop(false);
  }

  _cardValidation() {
    if (_cardNumberController.text.isEmpty) {
      setState(() {
        _cardNumberValidationMessage = StringConstants.cardNumber;
      });
      return false;
    } else {
      setState(() {
        _cardNumberValidationMessage = "";
      });
      _isCardNumberValid = true;
    }
  }

  _zipCodeValidation() {
    if (_zipCodeController.text.isEmpty) {
      setState(() {
        _zipcodeValidationMessage = StringConstants.enterZipcode;
      });
      _isZipCodeValid = false;
    } else {
      setState(() {
        _zipcodeValidationMessage = "";
      });
      _isZipCodeValid = true;
    }
  }

  _dateValidation() {
    try {
      String s = _dateExpiryController.text;
      int idx = s.indexOf("/");
      _month = int.parse(s.substring(0, idx).trim());
      _year = int.parse(s.substring(idx + 1).trim());
    } catch (error) {
      debugPrint(error.toString());
    }

    if (_dateExpiryController.text.isEmpty) {
      setState(() {
        _cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      _isExpiryValid = false;
    }
    if (_dateExpiryController.text.length < 5) {
      setState(() {
        _cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      _isExpiryValid = false;
    }
    if (_month != null) {
      if (_month > 12) {
        setState(() {
          _cardDateValidationMessage = StringConstants.cardExpiryCheckkMsg;
        });
        _isExpiryValid = false;
      } else {
        setState(() {
          _cardDateValidationMessage = "";
        });
        _isExpiryValid = true;
      }
    }
  }

  _cvvValidation() {
    if (_cvvController.text.isEmpty) {
      setState(() {
        _cvvValidationMessage = StringConstants.cvvEnterMsg;
      });
      return false;
    } else {
      setState(() {
        _cvvValidationMessage = "";
      });
      _isCvvValid = true;
    }
  }

  void _onTapConfirmManualCardPayment() {
    String stringValueYear = _year.toString();
    if (_isExpiryValid == false) {
      setState(() {
        _cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      _isExpiryValid = false;
    }
    if (_dateExpiryController.text.isEmpty) {
      setState(() {
        _cardDateValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      _isYearValid = false;
    }
    if (_cardNumberController.text.isEmpty) {
      setState(() {
        _cardNumberValidationMessage = StringConstants.cardExpiryEnterMsg;
      });
      _isCardNumberValid = false;
    }
    if (_isCardNumberValid &&
        _isExpiryValid &&
        _isCvvValid &&
        _isZipCodeValid) {
      Map<String, dynamic> myData = {};
      myData[ConstantKeys.cardValue] = true;
      myData[ConstantKeys.cardNumber] = _cardNumberController.text;
      myData[ConstantKeys.cardExpiry] = _spliitYear + stringValueYear;
      myData[ConstantKeys.cardCvv] = _cvvController.text;
      myData[ConstantKeys.cardMonth] = _month;
      myData[ConstantKeys.zipcode] = _zipCodeController.text;
      Navigator.pop(context, myData);
    }
  }
}

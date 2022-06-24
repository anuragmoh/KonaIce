import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dialog/dialog_helper.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class RefundPopup extends StatefulWidget {
  num amount;

  RefundPopup({required this.amount, Key? key}) : super(key: key);

  @override
  _RefundPopup createState() => _RefundPopup();
}

class _RefundPopup extends State<RefundPopup> {
  TextEditingController _totalAmoutController = TextEditingController();
  bool _isTotalAmoutValid = true;
  String _amoutValidationMessage = "";
  _RefundPopup() {
    // paymentPresenter = PaymentPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _totalAmoutController =
        TextEditingController(text: widget.amount.toString());
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
                title: StringConstants.refund,
                onTapCloseButton: _onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 23.0, bottom: 15.0),
              child: _amountComponent(
                  StringConstants.totalAmountBlank,
                  _totalAmoutController,
                  _amoutValidationMessage,
                  _amountValidation,
                  10),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.confirm,
                  _onTapConfirmButton,
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

  _onTapConfirmButton() {
    debugPrint('.............$_isTotalAmoutValid');
    if (_isTotalAmoutValid == true) {
      DialogHelper.confirmationDialog(context, _onConfirmTapYes,
          _onConfirmTapNo, StringConstants.confirmAmountMessage);
    }
  }

  _onTapCloseButton() {
    Navigator.of(context).pop();
  }

  _onConfirmTapYes() {
    Map<String, dynamic> myData = Map();
    myData['value'] = true;
    myData['totalAmount'] = _totalAmoutController.text;
    Navigator.of(context).pop();
    Navigator.pop(context, myData);
  }

  _onConfirmTapNo() {
    Navigator.of(context).pop();
  }

  Widget _amountComponent(
          String txtName,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets().textWidget(
                  StringConstants.symbolDollar,
                  StyleConstants.customTextStyle(
                      fontSize: 18.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratRegular),
                  textAlign: TextAlign.left),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 5.0, right: 22.0),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                            color: AppColors.textColor1.withOpacity(0.2),
                            width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, bottom: 3.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: maxLength,
                        onChanged: (value) {
                          _amountValidation();
                        },
                        controller: textEditingController,
                        decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            border: InputBorder.none,
                            hintStyle: StyleConstants.customTextStyle(
                                fontSize: 15.0,
                                color: AppColors.textColor1,
                                fontFamily: FontConstants.montserratRegular)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(validationMessage,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor5),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left)
        ],
      );

  _amountValidation() {
    int myInt = int.parse(_totalAmoutController.text);
    if (_totalAmoutController.text.isEmpty) {
      setState(() {
        _amoutValidationMessage = StringConstants.totalAmountBlank;
      });
      _isTotalAmoutValid = false;
    }
    if (widget.amount < myInt) {
      setState(() {
        _amoutValidationMessage = StringConstants.totalAmountBlank;
      });
      _isTotalAmoutValid = false;
    } else {
      setState(() {
        _amoutValidationMessage = "";
      });
      _isTotalAmoutValid = true;
    }
  }
}

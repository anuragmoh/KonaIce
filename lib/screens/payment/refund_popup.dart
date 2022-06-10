import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
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
  TextEditingController totalAmoutController = TextEditingController();
  bool isTotalAmoutValid = true;
  String amoutValidationMessage = "";
  _RefundPopup() {
    // paymentPresenter = PaymentPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    totalAmoutController =
        TextEditingController(text: widget.amount.toString());
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
                title: StringConstants.refund,
                onTapCloseButton: onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 23.0, bottom: 7.0),
              child: amountComponent(
                  StringConstants.totalAmountBlank,
                  totalAmoutController,
                  amoutValidationMessage,
                  amountValidation,
                  10),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().buttonWidget(
                  StringConstants.confirm,
                  onTapConfirmButton,
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

  onTapConfirmButton() {
    debugPrint('.............$isTotalAmoutValid');
    if (isTotalAmoutValid == true) {
      DialogHelper.confirmationDialog(context, onConfirmTapYes, onConfirmTapNo,
          StringConstants.confirmAmountMessage);
    }
  }

  onTapCloseButton() {
    Navigator.of(context).pop();
  }

  onConfirmTapYes() {
    Map<String, dynamic> myData = Map();
    myData['value'] = true;
    myData['totalAmount'] = totalAmoutController.text;
    Navigator.of(context).pop();
    Navigator.pop(context, myData);
  }

  onConfirmTapNo() {
    Navigator.of(context).pop();
  }

  Widget amountComponent(
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
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets().textWidget(
                  StringConstants.symbolDollar,
                  StyleConstants.customTextStyle(
                      fontSize: 18.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular),
                  textAlign: TextAlign.left),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 0.0, left: 5.0, right: 22.0),
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
                          amountValidation();
                        },
                        controller: textEditingController,
                        decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            border: InputBorder.none,
                            hintStyle: StyleConstants.customTextStyle(
                                fontSize: 15.0,
                                color: getMaterialColor(AppColors.textColor1),
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

  amountValidation() {
    int myInt = int.parse(totalAmoutController.text);
    if (totalAmoutController.text.isEmpty) {
      setState(() {
        amoutValidationMessage = StringConstants.totalAmountBlank;
      });
      isTotalAmoutValid = false;
    }
    if (widget.amount < myInt) {
      setState(() {
        amoutValidationMessage = StringConstants.totalAmountBlank;
      });
      isTotalAmoutValid = false;
    } else {
      setState(() {
        amoutValidationMessage = "";
      });
      isTotalAmoutValid = true;
    }
  }
}

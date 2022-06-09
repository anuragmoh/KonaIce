import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';

import '../../common/base_method.dart';

class PaymentFailPopup extends StatefulWidget {
  String paymentFailMessage;

  PaymentFailPopup({required this.paymentFailMessage, Key? key})
      : super(key: key);

  @override
  _PaymentFailPopupPopupState createState() => _PaymentFailPopupPopupState();
}

class _PaymentFailPopupPopupState extends State<PaymentFailPopup> {
  BaseMethod _baseMethod = BaseMethod();
  _PaymentFailPopupPopupState() {
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: _showCustomMenuPopup(),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _baseMethod.amountTextFieldController.dispose();
    _baseMethod.menuNameTextFieldController.dispose();
    _baseMethod.dateExpiryController.dispose();
    _baseMethod.cardNumberController.dispose();
    _baseMethod.cvcController.dispose();
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
                title: StringConstants.paymentFail,
                onTapCloseButton: _onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 23.0, bottom: 10.0),
              child: CommonWidgets().textWidget(
                  StringConstants.paymentFailMessage,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: AppColors.textColor1,
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
                  _onTapCloseButton,
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

  _onTapCloseButton() {
    Navigator.of(context).pop(false);
  }
}

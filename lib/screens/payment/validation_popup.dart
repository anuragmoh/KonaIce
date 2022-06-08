import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/base_method.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';

class ValidationPopup extends StatefulWidget {
  String validationMessage;

  ValidationPopup({required this.validationMessage, Key? key})
      : super(key: key);

  @override
  _ValidationPopup createState() => _ValidationPopup();
}

class _ValidationPopup extends State<ValidationPopup> {
  BaseMethod baseMethod = BaseMethod();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: showCustomMenuPopup(),
    );
  }

  @override
  void dispose(){
    super.dispose();
    baseMethod.amountTextFieldController.dispose();
    baseMethod.menuNameTextFieldController.dispose();
    baseMethod.dateExpiryController.dispose();
    baseMethod.cardNumberController.dispose();
    baseMethod.cvcController.dispose();
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
                title: StringConstants.error,
                onTapCloseButton: onTapCloseButton),
            Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 23.0, bottom: 10.0),
              child: CommonWidgets().textWidget(
                  widget.validationMessage,
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

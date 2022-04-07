import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/font_constants.dart';
import '../../constants/string_constants.dart';
import '../../constants/style_constants.dart';
import '../../utils/common_widgets.dart';
import '../../utils/utils.dart';

class CustomAddTipDialog extends StatefulWidget {
  const CustomAddTipDialog({Key? key}) : super(key: key);

  @override
  State<CustomAddTipDialog> createState() => _CustomAddTipDialogState();
}

class _CustomAddTipDialogState extends State<CustomAddTipDialog> {
  @override
  Widget build(BuildContext context) {
    return showCustomAddTipDialog();
  }

  Widget showCustomAddTipDialog() {
    return Dialog(
      backgroundColor: getMaterialColor(AppColors.whiteColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: customMenuPopUpComponent(),
    );
  }

  Widget customMenuPopUpComponent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height*0.23,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().popUpTopView(
                  title: StringConstants.addTip,
                  onTapCloseButton: onTapCloseButton),
              amountTextFieldContainer(),
              addFoodExtraPopUpButton(),
            ],
          ),
      ),
    );
  }

  //Action
  onTapCloseButton() {
    Navigator.of(context).pop();
  }

  Widget amountTextFieldContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:10,bottom: 8),
            child: CommonWidgets().textWidget(
                StringConstants.amount,
                StyleConstants.customTextStyle(
                    fontSize: 12,
                    color: getMaterialColor(AppColors.textColor2),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          TextField(
            // controller: amountTextFieldController,
            keyboardType: TextInputType.number,
            style: StyleConstants.customTextStyle(
                fontSize: 22.0,
                color: getMaterialColor(AppColors.textColor6),
                fontFamily: FontConstants.montserratMedium),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: StringConstants.enterAmount,
              hintStyle: StyleConstants.customTextStyle(
                  fontSize: 12,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratRegular),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: getMaterialColor(AppColors.skyBlueBorderColor)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: getMaterialColor(AppColors.skyBlueBorderColor)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CommonWidgets().textWidget(
                        StringConstants.symbolDollar,
                        StyleConstants.customTextStyle(
                            fontSize: 22,
                            color: getMaterialColor(AppColors.textColor2),
                            fontFamily: FontConstants.montserratMedium)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 15.0),
                    child: Container(
                      color: getMaterialColor(AppColors.skyBlueBorderColor),
                      width: 1.0,
                      height: 30,
                    ),
                  )
                ],
              ),
              // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          )
        ],
      ),
    );
  }

  Widget addFoodExtraPopUpButton() {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: getMaterialColor(AppColors.primaryColor2),
                borderRadius: BorderRadius.circular(15.0)),
            child: Center(
              child: CommonWidgets().textWidget(
                  StringConstants.add,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

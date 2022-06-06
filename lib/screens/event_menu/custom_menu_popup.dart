import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';

class CustomMenuPopup extends StatefulWidget {
  const CustomMenuPopup({Key? key}) : super(key: key);

  @override
  _CustomMenuPopupState createState() => _CustomMenuPopupState();
}

class _CustomMenuPopupState extends State<CustomMenuPopup> {
  String menuName = StringConstants.customMenuPackage;
  bool isEditingMenuName = false;
  var amountTextFieldController = TextEditingController();
  var menuNameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return showCustomMenuPopup();
  }

  Widget showCustomMenuPopup() {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: customMenuPopUpComponent(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    amountTextFieldController.dispose();
    menuNameTextFieldController.dispose();
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
                title: StringConstants.customMenu,
                onTapCloseButton: onTapCloseButton),
            isEditingMenuName ? customMenuNameEditable() : customMenuName(),
            amountTextFieldContainer(),
            addMenuPopUpButton()
          ],
        ),
      ),
    );
  }

  Widget customMenuNameEditable() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 18.0, 14.0, 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: customMenuNameTextFieldContainer()),
          saveNameButton()
        ],
      ),
    );
  }

  Widget customMenuName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 24, 24, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textWidget(
              menuName,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratSemiBold)),
          editNameButton(),
        ],
      ),
    );
  }

  Widget customMenuNameTextFieldContainer() {
    return TextField(
      controller: menuNameTextFieldController,
      style: StyleConstants.customTextStyle(
          fontSize: 12.0,
          color: AppColors.textColor1,
          fontFamily: FontConstants.montserratSemiBold),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: StringConstants.enterMenuName,
          hintStyle: StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor2,
              fontFamily: FontConstants.montserratRegular),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.denotiveColor4)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.denotiveColor4))),
    );
  }

  Widget amountTextFieldContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CommonWidgets().textWidget(
                StringConstants.amount,
                StyleConstants.customTextStyle(
                    fontSize: 12,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratMedium)),
          ),
          TextField(
            controller: amountTextFieldController,
            keyboardType: TextInputType.number,
            style: StyleConstants.customTextStyle(
                fontSize: 22.0,
                color: AppColors.textColor6,
                fontFamily: FontConstants.montserratMedium),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: StringConstants.enterAmount,
              hintStyle: StyleConstants.customTextStyle(
                  fontSize: 12,
                  color: AppColors.textColor2,
                  fontFamily: FontConstants.montserratRegular),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.skyBlueBorderColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.skyBlueBorderColor),
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
                            color: AppColors.textColor2,
                            fontFamily: FontConstants.montserratMedium)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 15.0),
                    child: Container(
                      color: AppColors.skyBlueBorderColor,
                      width: 1.0,
                      height: 30,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget editNameButton() {
    return GestureDetector(
      onTap: onTapEditNameButton,
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: Center(
          child: CommonWidgets().image(
              image: AssetsConstants.editIcon, width: 30.0, height: 30.0),
        ),
      ),
    );
  }

  Widget addMenuPopUpButton() {
    return GestureDetector(
      onTap: onTapAddCustomMenu,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 33, 15, 33),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: isEditingMenuName
                  ? AppColors.denotiveColor5
                  : AppColors.primaryColor2,
              borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: CommonWidgets().textWidget(
                StringConstants.add,
                StyleConstants.customTextStyle(
                    fontSize: 16.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratBold),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget saveNameButton() {
    return GestureDetector(
      onTap: onTapSaveButton,
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0),
        child: Container(
          height: 30.0,
          width: 45.0,
          decoration: BoxDecoration(
              color:
                  false ? AppColors.denotiveColor5 : AppColors.gradientColor1,
              borderRadius: BorderRadius.circular(5.0)),
          child: Center(
            child: CommonWidgets().textWidget(
                StringConstants.save,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.whiteColor,
                    fontFamily: FontConstants.montserratSemiBold),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  //Action
  onTapCloseButton() {
    Navigator.of(context).pop();
  }

  onTapEditNameButton() {
    setState(() {
      isEditingMenuName = true;
    });
  }

  onTapSaveButton() {
    FunctionalUtils.hideKeyboard();
    setState(() {
      if (menuNameTextFieldController.text.isNotEmpty) {
        menuName = menuNameTextFieldController.text;
        isEditingMenuName = false;
      }
    });
  }

  onTapAddCustomMenu() {}
}

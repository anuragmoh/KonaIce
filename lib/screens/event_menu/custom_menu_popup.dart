import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _menuName = StringConstants.customMenuPackage;
  bool _isEditingMenuName = false;
  var _amountTextFieldController = TextEditingController();
  var _menuNameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _showCustomMenuPopup();
  }

  Widget _showCustomMenuPopup() {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: _customMenuPopUpComponent(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _amountTextFieldController.dispose();
    _menuNameTextFieldController.dispose();
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
                title: StringConstants.customAmount,
                onTapCloseButton: _onTapCloseButton),
            _isEditingMenuName ? _customMenuNameEditable() : _customMenuName(),
            _amountTextFieldContainer(),
            _addMenuPopUpButton()
          ],
        ),
      ),
    );
  }

  Widget _customMenuNameEditable() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 18.0, 14.0, 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _customMenuNameTextFieldContainer()),
          _saveNameButton()
        ],
      ),
    );
  }

  Widget _customMenuName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 24, 24, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textWidget(
              _menuName,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratSemiBold)),
          _editNameButton(),
        ],
      ),
    );
  }

  Widget _customMenuNameTextFieldContainer() {
    return TextField(
      controller: _menuNameTextFieldController,
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
              borderSide: BorderSide(color: AppColors.denotiveColor4)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.denotiveColor4))),
    );
  }

  Widget _amountTextFieldContainer() {
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
          _buildTextField(),
        ],
      ),
    );
  }

  TextField _buildTextField() {
    return TextField(
      maxLength: 5,
      controller: _amountTextFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
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
          borderSide: BorderSide(color: AppColors.skyBlueBorderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.skyBlueBorderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPadding1(),
            _buildPadding2(),
          ],
        ),
      ),
    );
  }

  Padding _buildPadding1() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: CommonWidgets().textWidget(
          StringConstants.symbolDollar,
          StyleConstants.customTextStyle(
              fontSize: 22,
              color: AppColors.textColor2,
              fontFamily: FontConstants.montserratMedium)),
    );
  }

  Padding _buildPadding2() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
      child: Container(
        color: AppColors.skyBlueBorderColor,
        width: 1.0,
        height: 30,
      ),
    );
  }

  Widget _editNameButton() {
    return GestureDetector(
      onTap: _onTapEditNameButton,
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

  Widget _addMenuPopUpButton() {
    return GestureDetector(
      onTap: onTapAddCustomMenu,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 33, 15, 33),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: _isEditingMenuName
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

  Widget _saveNameButton() {
    return GestureDetector(
      onTap: _onTapSaveButton,
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
  _onTapCloseButton() {
    Navigator.of(context).pop();
  }

  _onTapEditNameButton() {
    setState(() {
      _isEditingMenuName = true;
    });
  }

  _onTapSaveButton() {
    FunctionalUtils.hideKeyboard();
    setState(() {
      if (_menuNameTextFieldController.text.isNotEmpty) {
        _menuName = _menuNameTextFieldController.text;
        _isEditingMenuName = false;
      }
    });
  }

  onTapAddCustomMenu() {}
}

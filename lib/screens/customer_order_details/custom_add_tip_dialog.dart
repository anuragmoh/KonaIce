import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../constants/app_colors.dart';
import '../../constants/font_constants.dart';
import '../../constants/other_constants.dart';
import '../../constants/string_constants.dart';
import '../../constants/style_constants.dart';
import '../../utils/common_widgets.dart';
import '../../utils/number_formatter.dart';

// ignore: must_be_immutable
class CustomerAddTipDialog extends StatefulWidget {
  Function callBack;

  CustomerAddTipDialog({Key? key, required this.callBack}) : super(key: key);

  @override
  State<CustomerAddTipDialog> createState() => _CustomerAddTipDialogState();
}

class _CustomerAddTipDialogState extends State<CustomerAddTipDialog> {
  bool _isValidTip = true;
  TextEditingController _tipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _showCustomAddTipDialog();
  }

  Widget _showCustomAddTipDialog() {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: _customMenuPopUpComponent(),
    );
  }

  Widget _customMenuPopUpComponent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().popUpTopView(
                title: StringConstants.addTip,
                onTapCloseButton: _onTapCloseButton),
            _amountTextFieldContainer(),
            _addTipButton(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tipController.dispose();
  }

  //Action
  _onTapCloseButton() {
    Navigator.of(context).pop();
  }

  Widget _amountTextFieldContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: CommonWidgets().textWidget(
                StringConstants.amount,
                StyleConstants.customTextStyle12MonsterMedium(
                    color: AppColors.textColor2)),
          ),
          _buildTextField(),
        ],
      ),
    );
  }

  TextField _buildTextField() {
    return TextField(
      controller: _tipController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        NumberRemoveExtraDotFormatter(),
      ],
      maxLength: TextFieldLengthConstant.addTip,
      style: StyleConstants.customTextStyle22MonsterMedium(
          color: AppColors.textColor6),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: StringConstants.enterAmount,
        errorText: _isValidTip ? "" : StringConstants.enterTip,
        hintStyle: StyleConstants.customTextStyle12MonsterRegular(
            color: AppColors.textColor2),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.skyBlueBorderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textColor5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.skyBlueBorderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CommonWidgets().textWidget(
                  StringConstants.symbolDollar,
                  StyleConstants.customTextStyle22MonsterMedium(
                      color: AppColors.textColor2)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
              child: Container(
                color: AppColors.skyBlueBorderColor,
                width: 1.0,
                height: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addTipButton() {
    return GestureDetector(
      onTap: () {
        _onTapAddButton();
      },
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.primaryColor2,
                borderRadius: BorderRadius.circular(15.0)),
            child: Center(
              child: CommonWidgets().textWidget(
                  StringConstants.add,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  _onTapAddButton() {
    //debugPrint("Tip from dialog ${tipController.text.toString()}");
    setState(() {
      _isValidTip = _tipController.text.isEmpty ? false : true;
    });
    if (_tipController.text.isNotEmpty) {
      widget.callBack(double.parse(_tipController.text.isEmpty
          ? '0.0'
          : _tipController.text.toString()));
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isValidTip = false;
      });
    }
  }
}

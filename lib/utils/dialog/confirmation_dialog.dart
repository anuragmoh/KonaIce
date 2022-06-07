import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';

class ConfirmationDialog extends StatefulWidget {
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;
  final String confirmMessage;

  const ConfirmationDialog(
      {Key? key, required this.onTapYes, required this.onTapNo,required this.confirmMessage})
      : super(key: key);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      child: dialogUi(),
    );
  }

  Widget dialogUi() => SizedBox(
    height: 208,
    width: 391,
    child: buildColumn(),
  );

  Column buildColumn() {
    return Column(
    children: [
      buildContainer(),
      buildConfirmmsgPadding(),
      buildYesPadding(),
    ],
  );
  }

  Padding buildYesPadding() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 17.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          button(StringConstants.no, widget.onTapNo,
              AppColors.textColor2.withOpacity(0.3)),
          const SizedBox(width: 12.0),
          button(StringConstants.yes, widget.onTapYes,
              AppColors.primaryColor2),
        ],
      ),
    );
  }

  Padding buildConfirmmsgPadding() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 65.0, right: 65, top: 47.0, bottom: 49.0),
      child: Text(widget.confirmMessage,
          style: StyleConstants.customTextStyle(
              fontSize: 14.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratMedium)),
    );
  }

  Container buildContainer() {
    return Container(
      color: AppColors.primaryColor1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(StringConstants.confirm,
                style: StyleConstants.customTextStyle(
                    fontSize: 16.0,
                    color: AppColors.whiteColor,
                    fontFamily: FontConstants.montserratSemiBold)),
            GestureDetector(
                onTap: widget.onTapNo,
                child: const Icon(Icons.clear,
                    color: AppColors.whiteColor, size: 28.0)),
          ],
        ),
      ),
    );
  }

  Widget button(String title, Function onTapButton, Color color) =>
      GestureDetector(
        onTap: () {
          onTapButton();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: color),
          child: Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 31.0, vertical: 8.0),
              child: Text(
                title,
                style: StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratBold),
              ),
            ),
          ),
        ),
      );
}

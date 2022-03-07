import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';

class NewOrderConfirmationDialog extends StatefulWidget {
  final VoidCallback onTapSave;
  final VoidCallback onTapCancel;
   const NewOrderConfirmationDialog({Key? key, required this.onTapSave, required this.onTapCancel}) : super(key: key);

  @override
  State<NewOrderConfirmationDialog> createState() => _NewOrderConfirmationDialogState();
}

class _NewOrderConfirmationDialogState extends State<NewOrderConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      child: dialogUi(),
    );
  }

  Widget dialogUi() =>
      SizedBox(
        height: 225,
        width: 391,
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.confirm,
                        style: StyleConstants.customTextStyle(fontSize: 16.0,
                            color: AppColors.whiteColor,
                            fontFamily: FontConstants.montserratSemiBold)),
                    // GestureDetector(
                    //     onTap: widget.onTapCancel,
                    //     child: const Icon(
                    //         Icons.clear, color: AppColors.whiteColor,
                    //         size: 28.0)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50.0, right: 50, top: 47.0, bottom: 49.0),
              child: Text(StringConstants.confirmNewOrder,
                  style: StyleConstants.customTextStyle(fontSize: 14.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratMedium)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 17.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  button(StringConstants.cancel, widget.onTapCancel,
                      AppColors.textColor2.withOpacity(0.3)),
                  const SizedBox(width: 12.0),
                  button(StringConstants.save, widget.onTapSave,
                      AppColors.primaryColor2),
                ],
              ),
            )
          ],
        ),
      );

  Widget button(String title, Function onTapButton, Color color) =>
      GestureDetector(
        onTap: () {
          onTapButton();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: color
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 31.0, vertical: 8.0),
              child: Text(title, style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratBold),),
            ),
          ),
        ),
      );
}
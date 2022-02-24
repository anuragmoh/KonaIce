import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class CommonWidgets {
  image(
      {required String image, required double width, required double height}) {
    return Image.asset(image, width: width, height: height);
  }

  Widget textWidget(String textTitle, TextStyle textStyle,
      {TextAlign textAlign = TextAlign.start}) {
    return Text(textTitle, style: textStyle, textAlign: textAlign);
  }

  Widget dashboardTopBar(Widget child) {
    // print('check for height in orientation ${8.30*SizeConfig.heightSizeMultiplier}');
    return Container(
      height: 8.30*SizeConfig.heightSizeMultiplier,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: child,
    );
  }

  Widget profileComponent(String userName) {
    //Image parameter todo
    return Row(
      children: [
        const CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage(AssetsConstants.konaIcon),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: textWidget(
              userName,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.whiteColor),
                  fontFamily: FontConstants.montserratSemiBold)),
        ),
        Visibility(
            visible: false,
            child: CommonWidgets().image(
            image: AssetsConstants.dropDownArrowIcon, width: 1.30*SizeConfig.imageSizeMultiplier, height: 1.04*SizeConfig.imageSizeMultiplier)
        )
      ],
    );
  }

  Widget profileImage(String imageName) {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage(AssetsConstants.konaIcon),
        ),
        Positioned(
          child: buildEditIcon(AppColors.whiteColor),
          right: 2,
          top: 110,
        )
      ],
    );
  }

  Widget buildEditIcon(Color color) =>
      buildCircle(
          all: 8,
          child: Icon(
            Icons.edit,
            color: color,
            size: 20,
          ));

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: AppColors.textColor6,
            child: child,
          ));

  Widget textView(String text, TextStyle textStyle) =>
      Text(text, style: textStyle);

  Widget quantityIncrementDecrementContainer(
      {required int quantity, required Function onTapMinus, required Function onTapPlus}) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              onTapMinus();
            },
            child: incrementDecrementButton(StringConstants.minusSymbol)),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: SizedBox(
            width: 3 * SizeConfig.imageSizeMultiplier,
            height: 3 * SizeConfig.imageSizeMultiplier,
            child: Center(
              child: CommonWidgets().textWidget(
                  '$quantity', StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratSemiBold)),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              onTapPlus();
            },
            child: incrementDecrementButton(StringConstants.plusSymbol)),
      ],
    );
  }

  Widget incrementDecrementButton(String title) {
    return Container(
      width: 3.5 * SizeConfig.imageSizeMultiplier,
      height: 3.5 * SizeConfig.imageSizeMultiplier,
      decoration: BoxDecoration(
        color: getMaterialColor(AppColors.primaryColor2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: CommonWidgets().textWidget(title, StyleConstants.customTextStyle(
            fontSize: 12.0,
            color: getMaterialColor(AppColors.textColor4),
            fontFamily: FontConstants.montserratSemiBold),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget popUpTopView(
      {required String title, required Function onTapCloseButton}) {
    return Container(
        decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor1),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 20, 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonWidgets().textWidget(
                      title, StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratSemiBold)),
                  GestureDetector(
                    onTap: () {
                      onTapCloseButton();
                    },
                    child: CommonWidgets().image(
                        image: AssetsConstants.popupCloseIcon,
                        width: 25.0,
                        height: 25.0),
                  ),
                ])
        )
    );
  }

  Widget buttonWidget(String buttonTitle, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 84.0),
            child: Text(
              buttonTitle,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold),
            ),
          ),
        ),
      );

  Widget buttonWidgetUnFilled(String buttonTitle, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            // color: getMaterialColor(AppColors.primaryColor2),
            border:Border.all(color:AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 84.0),
            child: Text(
              buttonTitle,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold),
            ),
          ),
        ),
      );


   showErrorSnackBar({required String errorMessage, required BuildContext context}) {
     final snackBar = SnackBar(
       content: textWidget(errorMessage, StyleConstants.customTextStyle(fontSize: 14.0, color: getMaterialColor(AppColors.whiteColor), fontFamily: FontConstants.montserratMedium)),
       backgroundColor: getMaterialColor(AppColors.denotiveColor1),
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget topEmptyBar() {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: const Padding(
        padding:
        EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0, top: 30.0),
      ),
    );
  }

  Widget bottomEmptyBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 4.19 * SizeConfig.heightSizeMultiplier,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
    );
  }
}

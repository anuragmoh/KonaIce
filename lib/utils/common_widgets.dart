import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class CommonWidgets{

  image({required String image, required double width,required double height}){
    return Image.asset(image,width: width,height: height);
  }

  Widget textWidget(String textTitle, TextStyle textStyle, {TextAlign textAlign = TextAlign.start}) {
    return Text(textTitle, style: textStyle, textAlign: textAlign);
  }

  Widget topBar(Widget child) {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))
      ),
      child: child,
    );
  }

  Widget bottomBar(Widget child) {
    return Container(
      height: 43.0,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
      ),
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
          child: textWidget(userName, StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: getMaterialColor(AppColors.whiteColor),
              fontFamily: FontConstants.montserratSemiBold)
          ),
        ),
        CommonWidgets().image(
            image: AssetsConstants.dropDownArrowIcon, width: 10.0, height: 8.0)
      ],
    );
  }

  Widget textView(String text, TextStyle textStyle) =>
      Text(text, style: textStyle);

  Widget quantityIncrementDecrementContainer({required int quantity, required Function onTapMinus, required Function onTapPlus}) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              onTapMinus();
            },
            child: incrementDecrementButton(StringConstants.minusSymbol)),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: CommonWidgets().textWidget('$quantity', StyleConstants.customTextStyle(
              fontSize: 12.0, color: getMaterialColor(AppColors.textColor2), fontFamily: FontConstants.montserratSemiBold)),
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
    return  Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        color: getMaterialColor(AppColors.primaryColor2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CommonWidgets().textWidget(title, StyleConstants.customTextStyle(
          fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratSemiBold), textAlign: TextAlign.center),
    );
  }

}
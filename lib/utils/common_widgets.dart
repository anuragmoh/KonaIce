import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class CommonWidgets{

  image({required String image, required double width,required double height}){
    return Image.asset(image,width: width,height: height);
  }

  Widget textWidget(String textTitle, TextStyle textStyle) {
    return Text(textTitle, style: textStyle);
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

  

}
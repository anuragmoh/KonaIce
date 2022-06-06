import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class StyleConstants {
  static customTextStyle(
      {required double fontSize,
      required Color color,
      required String fontFamily}) {
    return TextStyle(fontSize: fontSize, fontFamily: fontFamily, color: color);
  }

  //MonsterRegular
  static customTextStyle09MonsterRegular({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 9.0,
        fontFamily: FontConstants.montserratRegular);
  }
  static customTextStyle12MonsterRegular({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 12.0,
        fontFamily: FontConstants.montserratRegular);
  }
  static customTextStyle14MonsterRegular({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 14.0,
        fontFamily: FontConstants.montserratRegular);
  }
  static customTextStyle15MonsterRegular({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 15.0,
        fontFamily: FontConstants.montserratRegular);
  }
  static customTextStyle16MonsterRegular({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 16.0,
        fontFamily: FontConstants.montserratRegular);
  }

  //MonsterRatMedium
  static customTextStyle09MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 9.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle10MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 10.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle12MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 12.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle14MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 14.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle15MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 14.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle16MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 16.0,
        fontFamily: FontConstants.montserratMedium);
  }
  static customTextStyle22MonsterMedium({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 22.0,
        fontFamily: FontConstants.montserratMedium);
  }

  //MonsterBold
  static customTextStyle09MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 9.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle12MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 12.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle14MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 14.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle16MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 16.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle20MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 20.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle22MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 22.0,
        fontFamily: FontConstants.montserratBold);
  }

  static customTextStyle24MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 24.0,
        fontFamily: FontConstants.montserratBold);
  }
  static customTextStyle34MontserratBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 34.0,
        fontFamily: FontConstants.montserratBold);
  }

  //MonsterSemiBold
  static customTextStyle12MontserratSemiBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 12.0,
        fontFamily: FontConstants.montserratSemiBold);
  }
  static customTextStyle16MontserratSemiBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 16.0,
        fontFamily: FontConstants.montserratSemiBold);
  }
  static customTextStyle20MontserratSemiBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 20.0,
        fontFamily: FontConstants.montserratSemiBold);
  }
  static customTextStyle22MontserratSemiBold({required Color color}) {
    return TextStyle(
        color: color,
        fontSize: 22.0,
        fontFamily: FontConstants.montserratSemiBold);
  }
  static customBoxShadowDecorationStyle({required double circularRadius}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(circularRadius),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.textColor1.withOpacity(0.12),
              blurRadius: 4.0,
              offset: const Offset(0.0, 2.0))
        ]);
  }
}

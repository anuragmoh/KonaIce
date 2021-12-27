import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class StyleConstants{

  static customTextStyle({required double fontSize,required Color color, required String fontFamily}){
    return TextStyle(fontSize:fontSize,fontFamily: fontFamily,color: color );
  }

  static customBoxShadowDecorationStyle({required double circularRadius}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(circularRadius),
     color: getMaterialColor(AppColors.whiteColor),
      boxShadow: [
        BoxShadow(
          color: getMaterialColor(AppColors.textColor1).withOpacity(0.12),
          blurRadius: 4.0,
           offset: const Offset(0.0, 2.0)
        )
      ]
    );
  }


}
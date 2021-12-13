import 'package:flutter/cupertino.dart';

class StyleConstants{
  static customTextStyle({required double fontSize,required Color color, required String fontFamily}){
    return TextStyle(fontSize:fontSize,fontFamily: fontFamily,color: color );
  }
}
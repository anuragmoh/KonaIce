import 'package:flutter/material.dart';

class CommonWidgets{

  image({required String image, required double width,required double height}){
    return Image.asset(image,width: width,height: height);
  }

  Widget textView(String text, TextStyle textStyle) =>
      Text(text, style: textStyle);

}
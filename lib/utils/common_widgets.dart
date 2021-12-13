import 'package:flutter/material.dart';

class CommonWidgets{

  image({required String image, required double width,required double height}){
    return Image.asset(image,width: width,height: height);
  }

}
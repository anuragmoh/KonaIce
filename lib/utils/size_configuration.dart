import 'package:flutter/material.dart';

class SizeConfig{
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockHorizontal = 0.0;
  static double _blockVertical = 0.0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightSizeMultiplier;

  void init(BoxConstraints constraints, Orientation orientation){
    if(orientation== Orientation.portrait){
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    }else{
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }
    _blockHorizontal = _screenWidth /100;
    _blockVertical = _screenHeight /100;

    textMultiplier = _blockVertical;
    imageSizeMultiplier = _blockHorizontal;
    heightSizeMultiplier = _blockVertical;


  }


}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/color_extension.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

import 'constants/app_colors.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  Timer(Duration(seconds: 1), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          navigatorKey: FunctionalUtils.navigatorKey,
          title: StringConstants.title,
          theme: ThemeData(
            primarySwatch: AppColors.primaryColor2.toMaterialColor(),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      });
    });
  }
}

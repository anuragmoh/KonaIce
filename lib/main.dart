import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return OrientationBuilder(builder: (context,orientation){
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            navigatorKey: FunctionalUtils.navigatorKey,
            title: StringConstants.title,
            theme: ThemeData(
              primarySwatch: getMaterialColor(AppColors.primaryColor2),
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        });
      }
    );
  }
}

class App {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}


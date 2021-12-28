import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/screens/payment/payment_screen.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.title,
      theme: ThemeData(
        primarySwatch: getMaterialColor(AppColors.primaryColor2),
      ),
      debugShowCheckedModeBanner: false,
      home: const PaymentScreen(),
    );
  }
}


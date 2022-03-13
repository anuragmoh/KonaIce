import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete({Key? key}) : super(key: key);

  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  bool isMovedToNextScreen = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 5),
            () {
          if (!isMovedToNextScreen) {
            showSplashScreen();
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          children: [
            CommonWidgets().topEmptyBar(),
            Expanded(child: paymentSuccess()),
            CommonWidgets().bottomEmptyBar(),
          ],
        ),
      ),
    );
  }

  Widget paymentSuccess() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 68.0),
          CommonWidgets().image(
              image: AssetsConstants.success,
              width: 9.3 * SizeConfig.imageSizeMultiplier,
              height: 9.3 * SizeConfig.imageSizeMultiplier),
          const SizedBox(height: 21.0),
          CommonWidgets().textWidget(
              StringConstants.orderCompleted,
              StyleConstants.customTextStyle(
                  fontSize: 22.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonWidgets().textWidget(
                '${StringConstants.transactionId}:',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
            CommonWidgets().textWidget(
                "35891456",
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
          ]),
          const SizedBox(height: 34.0),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 23.0,
                  vertical: 3.90 * SizeConfig.heightSizeMultiplier),
              child: CommonWidgets().buttonWidget(
                StringConstants.okay,
                onTapOkay,
              ),
            ),
          )
        ],
      );

  onTapOkay() {
    showSplashScreen();
  }

  //Navigation
   showSplashScreen() {
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SplashScreen()));
   }
}

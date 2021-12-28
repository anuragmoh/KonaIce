import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/screens/login/login_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  openNextScreen(){
    Future.delayed(
      const Duration(seconds: 3),
          () {
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const LoginScreen()));
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    openNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    color: getMaterialColor(AppColors.primaryColor1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          splashIcon(),
        ],
      ),
    );
  }

  Widget splashIcon(){
    return CommonWidgets().image(image: AssetsConstants.konaIcon, width: 161.0, height: 120.0);
    //return Image.asset(AssetsConstants.konaIcon,width: 161.0,height: 120.0,);
  }

}

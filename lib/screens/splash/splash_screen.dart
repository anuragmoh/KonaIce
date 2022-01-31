import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/screens/account_switch/account_switch_screen.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/screens/login/login_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

enum NextScreen {
   login,
   dashboard,
   modeSelection,
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  openNextScreen({required NextScreen screenType}){
    Future.delayed(
      const Duration(seconds: 3),
          () {

         switch (screenType) {
           case NextScreen.login:
             Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const LoginScreen()));
             break;

            case NextScreen.dashboard:
              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const Dashboard()));
            break;

            case NextScreen.modeSelection:
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AccountSwitchScreen()));
            break;
          }
      },
    );
  }

 selectNextScreen() async {
   var userLoggedIn = await SessionDAO().getValueForKey(DatabaseKeys.sessionKey);
   if (userLoggedIn != null) {
      var selectedMode = await SessionDAO().getValueForKey(DatabaseKeys.selectedMode);
      if (selectedMode != null) {
       if (selectedMode.value == StringConstants.staffMode) {
         openNextScreen(screenType: NextScreen.dashboard);
       }
      } else {
        openNextScreen(screenType: NextScreen.modeSelection);
      }
   } else {
     openNextScreen(screenType: NextScreen.login);
   }
 }

 openCustomerView() {
   Future.delayed(
       const Duration(seconds: 10),
   () {
     Navigator.of(context).push( MaterialPageRoute(builder: (context) => const Dashboard()));
   });
 }

  @override
  void initState() {
    super.initState();
    selectNextScreen();
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
  }

}

import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/screens/available_device_list/available_device_list_screen.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class AccountSwitchScreen extends StatefulWidget {
  const AccountSwitchScreen({Key? key}) : super(key: key);

  @override
  _AccountSwitchScreenState createState() => _AccountSwitchScreenState();
}

class _AccountSwitchScreenState extends State<AccountSwitchScreen> {

  bool isStaffModeSelected = true;


  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: getMaterialColor(AppColors.primaryColor1),
        child: bodyContainer(),
      ),
    );
  }

  Widget bodyContainer() {
    return Center(
      child: Container(
        width: 360,
        decoration: StyleConstants.customBoxShadowDecorationStyle(circularRadius: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CommonWidgets().textWidget(StringConstants.selectMode, StyleConstants.customTextStyle(fontSize: 22.0,
                        color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratSemiBold)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                    onTap: () {
                      onTapSelectionMode(staffSelected: true);
                    },
                        child: selectionModeContainer(AssetsConstants.staffMode, StringConstants.staffMode, isStaffModeSelected)
                    ),
                    GestureDetector(
                      onTap: () {
                        onTapSelectionMode(staffSelected: false);
                      },
                        child: selectionModeContainer(AssetsConstants.customerMode, StringConstants.customerMode, !isStaffModeSelected)),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: proceedButton(StringConstants.proceed, StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectionModeContainer(String imagePath, String modeText, bool modeSelected) {
    return Container(
      width: 152,
      height: 152,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: getMaterialColor(AppColors.denotiveColor6),
        border: modeSelected ? Border.all(
          color: getMaterialColor(AppColors.primaryColor2),
          width: 2.0
        ) : const Border.fromBorderSide(BorderSide.none)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CommonWidgets().image(image: modeSelected ? AssetsConstants.radioSelected : AssetsConstants.radioUnselected, width: 18, height: 18),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: CommonWidgets().image(image: imagePath, width: 55, height: 55)
              ) 
            ),
        Align(
          alignment: Alignment.center,
          child: CommonWidgets().textWidget(modeText, StyleConstants.customTextStyle(fontSize: 14.0,
                color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratSemiBold))
        )
          ],
        ),
      ),
    );
  }

  Widget proceedButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: () {
        onTapProceedButton();
      },
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 70.0),
          child: Align (
            alignment: Alignment.center,
              child: CommonWidgets().textWidget(buttonText, textStyle)
          ),
        ),
      ),
    );
  }
  
  //Action Event
  onTapProceedButton() {
    storeInformation();
  }
  
  onTapSelectionMode({required bool staffSelected}) {
    setState(() {
      isStaffModeSelected = staffSelected;
    });

  }

  //Store Info
  storeInformation() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.selectedMode, value: isStaffModeSelected ? StringConstants.staffMode : StringConstants.customerMode));
    if(!isStaffModeSelected){
    await P2PConnectionManager.shared.startService(isStaffView: false);
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => isStaffModeSelected ? const AvailableDeviceListScreen() : SplashScreen()));
  }

}


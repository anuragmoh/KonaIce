import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonWidgets().dashboardTopBar(topBarComponent()),
            Expanded(child: bodyWidget()),
            Padding(
              padding:
                   const EdgeInsets.only(left: 23.0, top:15.0),
              child: CommonWidgets().buttonWidget(
                StringConstants.changePassword,
                onTapChangePassword,
              ),
            ),
            SizedBox(height: 4.88*SizeConfig.heightSizeMultiplier,),
            BottomBarWidget(
              onTapCallBack: onTapBottomListItem,
              accountImageVisibility: false,isFromDashboard: false,
            )
            // CommonWidgets().bottomBar(false),
          ],
        ),
      ),
    );
  }

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  onTapChangePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );
  }

  Widget topBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, right: 22.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          konaTopBarIcon(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: CommonWidgets().textWidget(
                  StringConstants.dashboard,
                  StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratBold)),
            ),
          ),
          CommonWidgets().profileComponent('Justin Powell'),
        ],
      ),
    );
  }

  Widget konaTopBarIcon() {
    return CommonWidgets()
        .image(image: AssetsConstants.topBarAppIcon, width: 4.03*SizeConfig.imageSizeMultiplier, height: 4.03*SizeConfig.imageSizeMultiplier);
  }

  Widget bodyWidget() => Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: SingleChildScrollView(child: bodyWidgetComponent()),
      );

  Widget bodyWidgetComponent() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 28.0),
              child: CommonWidgets().textWidget(
                  StringConstants.myProfile,
                  StyleConstants.customTextStyle(
                      fontSize: 22.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.start),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 29.0),
              child: CommonWidgets().profileImage('Justin Powell'),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
              child: Row(
                children: [
                  profileDetailsComponent(StringConstants.firstName, "",StringConstants.enterFirstName),
                  profileDetailsComponent(StringConstants.lastName, "",StringConstants.enterLastName),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
              child: Row(
                children: [
                  profileDetailsComponent(StringConstants.contactNumber, "",StringConstants.enterContactNumber),
                  profileDetailsComponent(StringConstants.emailId, "",StringConstants.enterEmailId),
                ],
              ),
            )
          ]);

  Widget profileDetailsComponent(String txtName, String txtValue,String txtHint) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    hintText: txtHint,
                      border: InputBorder.none,
                      labelText: txtValue,
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: CommonWidgets().textWidget(
          StringConstants.changePassword,
          StyleConstants.customTextStyle(
              fontSize: 22.0,
              color: getMaterialColor(AppColors.textColor1),
              fontFamily: FontConstants.montserratSemiBold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.oldPassword, "",StringConstants.oldPassword),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.newPassword, "",StringConstants.newPassword),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.confirmPassword, "",StringConstants.confirmPassword),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding:
                     EdgeInsets.symmetric(horizontal: 23.0, vertical: 3.90*SizeConfig.heightSizeMultiplier),
                child: CommonWidgets().buttonWidget(
                  StringConstants.submit,
                  onTapSubmitChangePassword,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onTapSubmitChangePassword() {
    Navigator.pop(context);
  }
}

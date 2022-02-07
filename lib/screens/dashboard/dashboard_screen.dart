import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/bottom_items.dart';
import 'package:kona_ice_pos/screens/home/home_screen.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/notifications/notifications_screen.dart';
import 'package:kona_ice_pos/screens/settings/settings.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  String userName = StringExtension.empty();
  List<Widget> bodyWidgets = [
    const HomeScreen(),
    const SettingScreen()
  ];
  List<BottomItems> bottomItemList = [
    BottomItems(
        title: StringConstants.home,
        basicImage: AssetsConstants.homeUnSelectedIcon,
        selectedImage: AssetsConstants.homeSelectedIcon),
/*    BottomItems(
        title: StringConstants.notification,
        basicImage: AssetsConstants.notificationUnSelectedIcon,
        selectedImage: AssetsConstants.notificationSelectedIcon),*/
    BottomItems(
        title: StringConstants.settings,
        basicImage: AssetsConstants.settingsUnSelectedIcon,
        selectedImage: AssetsConstants.settingsSelectedIcon),
  ];

  @override
  void initState() {
    super.initState();
    configureData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getMaterialColor(AppColors.textColor3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommonWidgets().dashboardTopBar(topBarComponent()),
          Expanded(
            child: bodyWidgets[currentIndex],
            //   child: CommonWidgets().bodyWidgets[],
            //   child: body(),
          ),
          // CommonWidgets().bottomBar(true, onTapBottomListItem),
          BottomBarWidget(onTapCallBack: onTapBottomListItem, accountImageVisibility: false,isFromDashboard: true,),
        ],
      ),
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
          GestureDetector(
            onTap: onProfileChange,
              child: CommonWidgets().profileComponent(userName)),
        ],
      ),
    );
  }

  Widget konaTopBarIcon() {
    return CommonWidgets()
        .image(image: AssetsConstants.topBarAppIcon, width: 4.03*SizeConfig.imageSizeMultiplier, height: 4.03*SizeConfig.imageSizeMultiplier);
  }

  Widget bottomBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0),
      child: ListView.builder(
          itemCount: bottomItemList.length,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                onTapBottomListItem(index);
              },
              child: Row(
                children: [
                  CommonWidgets().image(
                      image: currentIndex == index
                          ? bottomItemList[index].selectedImage
                          : bottomItemList[index].basicImage,
                      width: 26.0,
                      height: 26.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 35.0),
                    child: CommonWidgets().textWidget(
                        bottomItemList[index].title,
                        StyleConstants.customTextStyle(
                            fontSize: 13.0,
                            color: currentIndex == index
                                ? AppColors.primaryColor2
                                : AppColors.whiteColor,
                            fontFamily: currentIndex == index
                                ? FontConstants.montserratSemiBold
                                : FontConstants.montserratMedium)),
                  )
                ],
              ),
            );
          }),
    );
  }

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onProfileChange() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyProfile()));
  }


  //Function Other than UI dependency
   configureData() async {
      userName = await FunctionalUtils.getUserName();
      setState(() {
      });
   }
}


import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/bottom_items.dart';
import 'package:kona_ice_pos/screens/home/home_screen.dart';
import 'package:kona_ice_pos/screens/notifications/notifications_screen.dart';
import 'package:kona_ice_pos/screens/settings/settings.dart';
import 'package:kona_ice_pos/utils/utils.dart';

import 'common_widgets.dart';

class BottomBarWidget extends StatefulWidget {
  final Function onTapCallBack;
  final bool accountImageVisibility;

  const BottomBarWidget(
      {Key? key,
        required this.onTapCallBack,
        required this.accountImageVisibility})
      : super(key: key);

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int currentIndex = 0;
  List<Widget> bodyWidgets = [
    const HomeScreen(),
    const NotificationScreen(),
    const SettingScreen()
  ];
  List<BottomItems> bottomItemList = [
    BottomItems(
        title: StringConstants.home,
        basicImage: AssetsConstants.homeUnSelectedIcon,
        selectedImage: AssetsConstants.homeSelectedIcon),
    BottomItems(
        title: StringConstants.notification,
        basicImage: AssetsConstants.notificationUnSelectedIcon,
        selectedImage: AssetsConstants.notificationSelectedIcon),
    BottomItems(
        title: StringConstants.settings,
        basicImage: AssetsConstants.settingsUnSelectedIcon,
        selectedImage: AssetsConstants.settingsSelectedIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 43.0,
          decoration: BoxDecoration(
              color: getMaterialColor(AppColors.primaryColor1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0))),
          child: Row(
            children: [
              bottomBarComponent(),
              const Spacer(),
              bottomBarSwitchAccountImage()
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: bottomItemList.length,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  // onTapBottomListItem(index);
                  currentIndex = index;
                  widget.onTapCallBack(index);
                });
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

  Widget bottomBarSwitchAccountImage() {
    return Visibility(
      visible: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 21.0),
        child: Row(
          children: [
            CommonWidgets().image(
                image: AssetsConstants.switchAccountUnSelectedIcon,
                width: 26.0,
                height: 26.0)
          ],
        ),
      ),
    );
  }
}

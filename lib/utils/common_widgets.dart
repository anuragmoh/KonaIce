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

class CommonWidgets {
  image(
      {required String image, required double width, required double height}) {
    return Image.asset(image, width: width, height: height);
  }

  Widget textWidget(String textTitle, TextStyle textStyle,
      {TextAlign textAlign = TextAlign.start}) {
    return Text(textTitle, style: textStyle, textAlign: textAlign);
  }

  Widget topBar(Widget child) {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: child,
    );
  }

  Widget profileComponent(String userName) {
    //Image parameter todo
    return Row(
      children: [
        const CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage(AssetsConstants.konaIcon),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: textWidget(
              userName,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.whiteColor),
                  fontFamily: FontConstants.montserratSemiBold)),
        ),
        CommonWidgets().image(
            image: AssetsConstants.dropDownArrowIcon, width: 10.0, height: 8.0)
      ],
    );
  }

  Widget profileImage(String imageName) {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage(AssetsConstants.konaIcon),
        ),
        Positioned(
          child: buildEditIcon(AppColors.whiteColor),
          right: 2,
          top: 110,
        )
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: Icon(
        Icons.edit,
        color: color,
        size: 20,
      ));

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: AppColors.textColor6,
        child: child,
      ));

  Widget textView(String text, TextStyle textStyle) =>
      Text(text, style: textStyle);

  Widget quantityIncrementDecrementContainer({required int quantity, required Function onTapMinus, required Function onTapPlus}) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              onTapMinus();
            },
            child: incrementDecrementButton(StringConstants.minusSymbol)),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: CommonWidgets().textWidget('$quantity', StyleConstants.customTextStyle(
              fontSize: 12.0, color: getMaterialColor(AppColors.textColor2), fontFamily: FontConstants.montserratSemiBold)),
        ),
        GestureDetector(
            onTap: () {
              onTapPlus();
            },
            child: incrementDecrementButton(StringConstants.plusSymbol)),
      ],
    );
  }
  Widget incrementDecrementButton(String title) {
    return  Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        color: getMaterialColor(AppColors.primaryColor2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CommonWidgets().textWidget(title, StyleConstants.customTextStyle(
          fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratSemiBold), textAlign: TextAlign.center),
    );
  }

  Widget buttonWidget(String buttonTitle, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 84.0),
            child: Text(
              buttonTitle,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold),
            ),
          ),
        ),
      );
}

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
              bottomBarSwitchAccountImage(widget.accountImageVisibility)
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

  Widget bottomBarSwitchAccountImage(bool accountImageVisibility) {
    return Visibility(
      visible: accountImageVisibility,
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

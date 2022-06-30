import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/customer_view/customer_view_screen.dart';
import 'package:kona_ice_pos/screens/dashboard/bottom_items.dart';
import 'package:kona_ice_pos/utils/bottombar_menu_abstract_class.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

import 'ServiceNotifier.dart';
import 'common_widgets.dart';

class BottomBarWidget extends StatefulWidget {
  final Function onTapCallBack;
  final bool accountImageVisibility;
  final bool isFromDashboard;

  const BottomBarWidget({
    Key? key,
    required this.onTapCallBack,
    required this.accountImageVisibility,
    required this.isFromDashboard,
  }) : super(key: key);

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  BottomBarMenuClass bottomBarMenuClass = BottomBarMenuClass();
  final service = ServiceNotifier();
  int currentIndex = 0;
  List<BottomItems> bottomItemList = [
    BottomItems(
        title: StringConstants.home,
        basicImage: AssetsConstants.homeUnSelectedIcon,
        selectedImage: AssetsConstants.homeSelectedIcon),
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
          height: 4.19 * SizeConfig.heightSizeMultiplier,
          decoration: BoxDecoration(
              color: AppColors.primaryColor1,
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
        itemBuilder: buildWidget,
      ),
    );
  }

  Widget buildWidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
          widget.onTapCallBack(index);
          print('bottombar$index');
        });
        service.increment(index);
        if (!widget.isFromDashboard) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: buildRow(index),
    );
  }

  Row buildRow(int index) {
    return Row(
      children: [
        Container(
          color: AppColors.primaryColor1,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),
            child: CommonWidgets().image(
                image: ServiceNotifier.count == index
                    ? bottomItemList[index].selectedImage
                    : bottomItemList[index].basicImage,
                width: 3.38 * SizeConfig.imageSizeMultiplier,
                height: 3.38 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 35.0),
          child: CommonWidgets().textWidget(
              bottomItemList[index].title,
              StyleConstants.customTextStyle(
                  fontSize: 13.0,
                  color: ServiceNotifier.count == index
                      ? AppColors.primaryColor2
                      : AppColors.whiteColor,
                  fontFamily: currentIndex == index
                      ? FontConstants.montserratSemiBold
                      : FontConstants.montserratMedium)),
        )
      ],
    );
  }

  Widget bottomBarSwitchAccountImage() {
    return Visibility(
      visible: widget.accountImageVisibility,
      child: Padding(
        padding: const EdgeInsets.only(right: 21.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CustomerViewScreen()));
          },
          child: Row(
            children: [
              CommonWidgets().image(
                  image: AssetsConstants.switchAccountUnSelectedIcon,
                  width: 26.0,
                  height: 26.0)
            ],
          ),
        ),
      ),
    );
  }
}

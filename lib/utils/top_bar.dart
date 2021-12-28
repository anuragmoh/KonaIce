import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class TopBar extends StatefulWidget {
  final String userName;
  final String eventName;
  final String eventAddress;
  final bool showCenterWidget;
  final Function onTapCallBack;

  const TopBar(
      {Key? key,
      required this.userName,
      required this.eventName,
      required this.eventAddress,
      required this.showCenterWidget,
      required this.onTapCallBack})
      : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool isProduct = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
          color: getMaterialColor(AppColors.primaryColor1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, right: 18.0, bottom: 20.0, top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child:
                    eventNameAndAddress(widget.eventName, widget.eventAddress),
              ),
            ),
            Visibility(
              visible: widget.showCenterWidget,
              child: Flexible(
                flex: 1,
                child: Container(
                  child: centerWidget(),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonWidgets().profileComponent(widget.userName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventNameAndAddress(String eventName, String eventAddress) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonWidgets().image(
              image: AssetsConstants.konaIcon, width: 31.0, height: 31.0),
          const SizedBox(
            width: 18.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonWidgets().textWidget(
                      eventName,
                      StyleConstants.customTextStyle(
                          fontSize: 16.0,
                          color: getMaterialColor(AppColors.whiteColor),
                          fontFamily: FontConstants.montserratBold)),
                ],
              ),
              CommonWidgets().textWidget(
                  eventAddress,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratRegular))
            ],
          ),
        ],
      );

  Widget centerWidget() => Container(
        width: 244.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border:
                Border.all(color: getMaterialColor(AppColors.primaryColor2))),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isProduct = true;
                });
                widget.onTapCallBack(isProduct);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: isProduct
                      ? getMaterialColor(AppColors.primaryColor2)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 38.0, vertical: 9.0),
                  child: CommonWidgets().textWidget(
                      StringConstants.product,
                      isProduct ? StyleConstants.customTextStyle(
                          fontSize: 12.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratBold) : StyleConstants.customTextStyle(
                          fontSize: 12.0,
                          color: getMaterialColor(AppColors.whiteColor),
                          fontFamily: FontConstants.montserratMedium)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isProduct = false;
                });
                widget.onTapCallBack(isProduct);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: !isProduct
                      ? getMaterialColor(AppColors.primaryColor2)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36.5, vertical: 9.0),
                  child: CommonWidgets().textWidget(
                      StringConstants.orders,
                      !isProduct
                          ? StyleConstants.customTextStyle(
                              fontSize: 12.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratBold)
                          : StyleConstants.customTextStyle(
                              fontSize: 12.0,
                              color: getMaterialColor(AppColors.whiteColor),
                              fontFamily: FontConstants.montserratMedium)),
                ),
              ),
            ),
          ],
        ),
      );
}

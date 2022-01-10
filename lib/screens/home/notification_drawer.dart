import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/notifications/notification_item.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class NotificationDrawer extends StatefulWidget {
  const NotificationDrawer({Key? key}) : super(key: key);

  @override
  _NotificationDrawerState createState() => _NotificationDrawerState();
}

class _NotificationDrawerState extends State<NotificationDrawer> {
  List<NotificationItem> notificationList = [
    NotificationItem(
        notificationStatus: 'Yes',
        notificationTitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
        notificationDate: 'Today, 12.45 PM'),
    NotificationItem(
        notificationStatus: 'Yes',
        notificationTitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
        notificationDate: '03 Jan 2022 - 09 Jan 2022 '),
    NotificationItem(
        notificationStatus: 'KONA DAYS',
        notificationTitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
        notificationDate: 'Today, 12.45 PM '),
    NotificationItem(
        notificationStatus: 'Yes',
        notificationTitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
        notificationDate: 'Today, 12.45 PM '),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 65.0, bottom: 45.0),
      child: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0,right: 15.0,top: 20.0,bottom: 24.0),
                child: Row(
                  children: [
                    CommonWidgets().textWidget(
                        StringConstants.notification,
                        StyleConstants.customTextStyle(
                            fontSize: 16.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratBold)),
                    const Spacer(),
                    CommonWidgets().textWidget(
                        StringConstants.markAllAsRead,
                        StyleConstants.customTextStyle(
                            fontSize: 10.0,
                            color: getMaterialColor(AppColors.textColor6),
                            fontFamily: FontConstants.montserratMedium),),
                  ],
                ),
              ),
              listViewNotificationContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewNotificationContainer() {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: notificationList.length,
        itemBuilder: (BuildContext context, int index) {
          var notificationDetails = notificationList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.denotiveColor1,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CommonWidgets().textWidget(
                                    notificationDetails.notificationTitle,
                                    StyleConstants.customTextStyle(
                                        fontSize: 12.0,
                                        color: getMaterialColor(
                                            AppColors.textColor4),
                                        fontFamily:
                                            FontConstants.montserratMedium)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CommonWidgets().textWidget(
                          notificationDetails.notificationDate,
                          StyleConstants.customTextStyle(
                              fontSize: 9.0,
                              color: getMaterialColor(AppColors.textColor4),
                              fontFamily: FontConstants.montserratRegular),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}

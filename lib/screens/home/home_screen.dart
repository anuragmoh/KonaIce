
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/event_menu/event_menu_screen.dart';
import 'package:kona_ice_pos/screens/home/party_events.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String currentDate = Date.getTodaysDate(formatValue: DateFormatsConstant.ddMMMYYYYDay);
  String clockInTime = StringConstants.defaultClockInTime;
  late DateTime startDateTime;
  late Timer clockInTimer;
  bool isClockIn = false;

  var tempEventHomeNavigation = false;

  List <PartyEvents> eventList = [
    PartyEvents(eventName: 'NEW YEAR EVE EVENT', location: 'Houston, Texas, 77001', date: '31 Dec 2021 - 01 Jan 2022', time: '04:30 PM - 10:30 PM'),
    PartyEvents(eventName: 'OCKERMAN SCHOOL EVENT', location: 'Houston, Texas, 77001', date: '03 Jan 2022 - 09 Jan 2022 ', time: '04:30 PM - 8:50 PM'),
    PartyEvents(eventName: 'KONA DAYS', location: 'Houston, Texas, 77001', date: '03 Jan 2022 - 09 Jan 2022 ', time: '04:30 PM - 8:50 PM'),
    PartyEvents(eventName: 'OCKERMAN SCHOOL EVENT', location: 'Houston, Texas, 77001', date: '03 Jan 2022 - 09 Jan 2022 ', time: '04:30 PM - 8:50 PM'),
    PartyEvents(eventName: 'OCKERMAN SCHOOL EVENT', location: 'Houston, Texas, 77001', date: '03 Jan 2022 - 09 Jan 2022 ', time: '04:30 PM - 8:50 PM'),
    PartyEvents(eventName: 'OCKERMAN SCHOOL EVENT', location: 'Houston, Texas, 77001', date: '03 Jan 2022 - 09 Jan 2022 ', time: '04:30 PM - 8:50 PM'),

  ];

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         color: getMaterialColor(AppColors.textColor3),
          child: tempEventHomeNavigation ? showEventMenuScreen() : body()
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 23.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createEventButton(StringConstants.createAdhocEvent,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold)),
              CommonWidgets().textWidget(
                  currentDate, StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)),
              clockInOutButton(
                  isClockIn ? StringConstants.clockOut : StringConstants
                      .clockIn,
                  StyleConstants.customTextStyle(fontSize: 12.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: isClockIn
                          ? FontConstants.montserratBold
                          : FontConstants.montserratMedium),
                  StyleConstants.customTextStyle(fontSize: 12.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratMedium))
            ],
          ),
          Expanded(child:
          FractionallySizedBox(
            widthFactor: 0.68,
              alignment: Alignment.topLeft,
              child: listViewContainer())
          )
        ],
      ),
    );
  }

  Widget listViewContainer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
            itemCount: eventList.length,
              itemBuilder: (BuildContext context, int index) {
              var eventDetails = eventList[index];
            return  Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  onTapEventItem(index);
                },
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CommonWidgets().textWidget(eventDetails.eventName,
                              StyleConstants.customTextStyle(fontSize:
                              16.0, color: getMaterialColor(AppColors.textColor1),
                                  fontFamily: FontConstants.montserratBold)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              CommonWidgets().image(image: AssetsConstants.locationPinIcon, width: 14.0, height: 19.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CommonWidgets().textWidget(eventDetails.location,
                                    StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            CommonWidgets().image(image: AssetsConstants.dateIcon, width: 14.0, height: 19.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CommonWidgets().textWidget(eventDetails.date,
                                  StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: CommonWidgets().textWidget(eventDetails.time,
                                StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ),
            );
          }
          ),
    );
  }

  Widget createEventButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: onTapCreateEventButton,
      child: Container(
        decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(30.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: CommonWidgets().textWidget(buttonText, textStyle),
        ),
      ),
    );
  }

  Widget clockInOutButton(String buttonText, TextStyle textStyle, TextStyle timeTextStyle) {
    return GestureDetector(
      onTap: onTapClockInOutButton,
      child: Container(
        height: 43.0,
        decoration: BoxDecoration(
          color: getMaterialColor(isClockIn ? AppColors.denotiveColor1 : AppColors.denotiveColor2),
          borderRadius: BorderRadius.circular(21.5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 40.0),
          child: Row(
            children: [
              CommonWidgets().image(image: AssetsConstants.clockInOutIcon, width: 26.0, height: 26.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().textWidget(buttonText, textStyle),
                    Visibility(
                        visible: isClockIn,
                        child: CommonWidgets().textWidget(clockInTime, timeTextStyle))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Action Events
  onTapCreateEventButton() {

  }

  onTapClockInOutButton() {

    setState(() {
      isClockIn = !isClockIn;
    });
       isClockIn ? startTimer() : stopTimer();
  }

  onTapEventItem(int index) {
    setState(() {
      tempEventHomeNavigation = true;
    });
  }

    startTimer() {
      startDateTime = DateTime.now();
    clockInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        clockInTime = Date.getDateInHrMinSec(date: startDateTime);
      });
    });
  }

    stopTimer() {
      clockInTimer.cancel();
      clockInTime = StringConstants.defaultClockInTime;
    }

   //Navigation Events
  Widget showEventMenuScreen() {
    return EventMenuScreen();
  }
}
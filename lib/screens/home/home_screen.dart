import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/events_dao.dart';
import 'package:kona_ice_pos/database/daos/food_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/item_categories_dao.dart';
import 'package:kona_ice_pos/database/daos/item_dao.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/models/data_models/item_categories.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/clock_in_out/clock_in_out_presenter.dart';
import 'package:kona_ice_pos/network/repository/sync/sync_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/dashboard/clock_in_out_model.dart';
import 'package:kona_ice_pos/screens/event_menu/event_menu_screen.dart';
import 'package:kona_ice_pos/screens/home/create_adhvoc_event_popup.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  var onCallback;
  HomeScreen({Key? key, this.onCallback}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements ClockInOutResponseContractor, SyncResponseContractor {
  late SyncPresenter _syncPresenter;

  _HomeScreenState() {
    clockInOutPresenter = ClockInOutPresenter(this);
    _syncPresenter = SyncPresenter(this);
  }

  String currentDate =
  Date.getTodaysDate(formatValue: DateFormatsConstant.ddMMMYYYYDay);
  String clockInTime = StringConstants.defaultClockInTime;
  late DateTime startDateTime;
  Timer? clockInTimer;
  bool isClockIn = false;
  bool isApiProcess = false;

  List<Events> eventList = [];
  final List<SyncEventMenu> _syncEventMenuResponseModel = [];
  List<POsSyncEventDataDtoList> pOsSyncEventDataDtoList = [];
  List<POsSyncItemCategoryDataDtoList> pOsSyncItemCategoryDataDtoList = [];
  List<POsSyncEventItemDataDtoList> pOsSyncEventItemDataDtoList = [];
  List<POsSyncEventItemExtrasDataDtoList> pOsSyncEventItemExtrasDataDtoList =
  [];
  List<POsSyncEventDataDtoList> pOsSyncDeletedEventDataDtoList = [];
  List<POsSyncItemCategoryDataDtoList> pOsSyncDeletedItemCategoryDataDtoList =
  [];
  List<POsSyncEventItemDataDtoList> pOsSyncDeletedEventItemDataDtoList = [];
  List<POsSyncEventItemExtrasDataDtoList>
  pOsSyncDeletedEventItemExtrasDataDtoList = [];

  late ClockInOutPresenter clockInOutPresenter;
  ClockInOutRequestModel clockInOutRequestModel = ClockInOutRequestModel();

  // Future<void> getSyncData() async {
  //   eventList.clear();
  //   await SessionDAO().getValueForKey(DatabaseKeys.events).then((value) {
  //     if (value != null) {
  //       int lastSyncTime = int.parse(value.value);
  //       CheckConnection().connectionState().then((value) {
  //         if (value == true) {
  //           setState(() {
  //             isApiProcess = true;
  //           });
  //           _syncPresenter.syncData(lastSyncTime);
  //         } else {
  //           CommonWidgets().showErrorSnackBar(
  //               errorMessage: StringConstants.noInternetConnection,
  //               context: context);
  //         }
  //       });
  //     } else {
  //       CheckConnection().connectionState().then((value) {
  //         if (value == true) {
  //           setState(() {
  //             isApiProcess = true;
  //           });
  //           _syncPresenter.syncData(0);
  //         } else {
  //           CommonWidgets().showErrorSnackBar(
  //               errorMessage: StringConstants.noInternetConnection,
  //               context: context);
  //         }
  //       });
  //     }
  //   });
  //
  //  // Old Code
  //
  //   // var result = await EventsDAO().getTodayEvent(
  //   //     Date.getStartOfDateTimeStamp(date: DateTime.now()),
  //   //    Date.getEndOfDateTimeStamp(date: DateTime.now()));
  //   // //var result = await EventsDAO().getValues();
  //   // if (result != null) {
  //   //   setState(() {
  //   //     eventList.addAll(result);
  //   //   });
  //   // } else {
  //   //   await SessionDAO().getValueForKey(DatabaseKeys.events).then((value) {
  //   //     if (value != null) {
  //   //       int lastSyncTime = int.parse(value.value);
  //   //       CheckConnection().connectionState().then((value) {
  //   //         if (value == true) {
  //   //           setState(() {
  //   //             isApiProcess = true;
  //   //           });
  //   //           _syncPresenter.syncData(lastSyncTime);
  //   //         } else {
  //   //           CommonWidgets().showErrorSnackBar(
  //   //               errorMessage: StringConstants.noInternetConnection,
  //   //               context: context);
  //   //         }
  //   //       });
  //   //     } else {
  //   //       CheckConnection().connectionState().then((value) {
  //   //         if (value == true) {
  //   //           setState(() {
  //   //             isApiProcess = true;
  //   //           });
  //   //           _syncPresenter.syncData(0);
  //   //         } else {
  //   //           CommonWidgets().showErrorSnackBar(
  //   //               errorMessage: StringConstants.noInternetConnection,
  //   //               context: context);
  //   //         }
  //   //       });
  //   //     }
  //   //   });
  //   // }
  // }
  refreshDataOnRequest() async {
    await SessionDAO().getValueForKey(DatabaseKeys.events).then((value) {
      if (value != null) {
        int lastSyncTime = int.parse(value.value);
        CheckConnection().connectionState().then((value) {
          if (value == true) {
            //eventList.clear();
            setState(() {
              isApiProcess = true;
            });
            _syncPresenter.syncData(lastSyncTime);
          } else {
            loadDataFromDb();
            CommonWidgets().showErrorSnackBar(
                errorMessage: StringConstants.noInternetConnection,
                context: context);
          }
        });
      } else {
        CheckConnection().connectionState().then((value) {
          if (value == true) {
            setState(() {
              isApiProcess = true;
            });
            _syncPresenter.syncData(0);
          } else {
            loadDataFromDb();
            CommonWidgets().showErrorSnackBar(
                errorMessage: StringConstants.noInternetConnection,
                context: context);
          }
        });
      }
    });
  }

  loadDataFromDb() async {
    setState(() {
      eventList.clear();
    });
    var result = await EventsDAO().getTodayEvent(
        Date.getStartOfDateTimeStamp(date: DateTime.now()),
        Date.getEndOfDateTimeStamp(date: DateTime.now()));
    // var result = await EventsDAO().getValues();
    if (result != null) {
      setState(() {
        eventList.addAll(result);
      });
    } else {
      setState(() {
        eventList.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshDataOnRequest();
    if (FunctionalUtils.clockInTimestamp == 0) {
      callClockInOutDetailsAPI();
    } else {
      setState(() {
        isApiProcess = false;
        isClockIn = true;
        var timeStamp = FunctionalUtils.clockInTimestamp;
        startDateTime = Date.getDateFromTimeStamp(timestamp: timeStamp);
        isClockIn ? startTimer() : stopTimer();
      });
    }
    callClockInOutDetailsAPI();
    if (!P2PConnectionManager.shared.isServiceStarted) {
      P2PConnectionManager.shared.startService(isStaffView: true);
    }
    P2PConnectionManager.shared.updateData(action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
          color: getMaterialColor(AppColors.textColor3), child: body()),
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
              createEventButton(
                  StringConstants.createAdhocEvent,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold)),
              CommonWidgets().textWidget(
                  currentDate,
                  StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold)),
              clockInOutButton(
                  isClockIn
                      ? StringConstants.clockOut
                      : StringConstants.clockIn,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: isClockIn
                          ? FontConstants.montserratBold
                          : FontConstants.montserratMedium),
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratMedium))
            ],
          ),
          Expanded(
              child: FractionallySizedBox(
                  widthFactor: eventList.isNotEmpty ? 0.68 : 1.0,
                  alignment: Alignment.topLeft,
                  child: listViewContainer()))
        ],
      ),
    );
  }

  Widget listViewContainer() {
    return RefreshIndicator(
      onRefresh: () async {
        refreshDataOnRequest();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: eventList.isNotEmpty
            ? ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (BuildContext context, int index) {
              var eventDetails = eventList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    onTapEventItem(eventDetails);
                  },
                  child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 12.0, 16.0, 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CommonWidgets().textWidget(
                                  eventDetails.getEventName(),
                                  StyleConstants.customTextStyle(
                                      fontSize: 16.0,
                                      color: getMaterialColor(
                                          AppColors.textColor1),
                                      fontFamily:
                                      FontConstants.montserratBold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: [
                                  CommonWidgets().image(
                                      image:
                                      AssetsConstants.locationPinIcon,
                                      width: 2 *
                                          SizeConfig.imageSizeMultiplier,
                                      height: 2.47 *
                                          SizeConfig.imageSizeMultiplier),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8.0),
                                    child: CommonWidgets().textWidget(
                                        eventDetails.getEventAddress(),
                                        StyleConstants.customTextStyle(
                                            fontSize: 12.0,
                                            color: getMaterialColor(
                                                AppColors.textColor4),
                                            fontFamily: FontConstants
                                                .montserratMedium)),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                CommonWidgets().image(
                                    image: AssetsConstants.dateIcon,
                                    width:
                                    2 * SizeConfig.imageSizeMultiplier,
                                    height: 2.47 *
                                        SizeConfig.imageSizeMultiplier),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CommonWidgets().textWidget(
                                    eventDetails.getEventDate(),
                                    StyleConstants.customTextStyle(
                                        fontSize: 12.0,
                                        color: getMaterialColor(
                                            AppColors.textColor4),
                                        fontFamily:
                                        FontConstants.montserratMedium),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: CommonWidgets().textWidget(
                                    eventDetails.getEventTime(),
                                    StyleConstants.customTextStyle(
                                        fontSize: 12.0,
                                        color: getMaterialColor(
                                            AppColors.textColor4),
                                        fontFamily:
                                        FontConstants.montserratMedium),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              );
            })
            : Center(
          child: ListView(
            children: [
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.27),
              Center(
                child: Text(StringConstants.eventNotAvailable,
                    style: StyleConstants.customTextStyle(fontSize: 20.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratSemiBold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createEventButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: onTapCreateEventButton,
      child: Container(
        decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 1.17 * SizeConfig.heightSizeMultiplier,
              horizontal: 15.0),
          child: CommonWidgets().textWidget(buttonText, textStyle),
        ),
      ),
    );
  }

  Widget clockInOutButton(String buttonText, TextStyle textStyle,
      TextStyle timeTextStyle) {
    return GestureDetector(
      onTap: onTapClockInOutButton,
      child: Container(
        height: 4.19 * SizeConfig.heightSizeMultiplier,
        decoration: BoxDecoration(
          color: getMaterialColor(
              isClockIn ? AppColors.denotiveColor1 : AppColors.denotiveColor2),
          borderRadius: BorderRadius.circular(21.5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 40.0),
          child: Row(
            children: [
              CommonWidgets().image(
                  image: AssetsConstants.clockInOutIcon,
                  width: 3.38 * SizeConfig.imageSizeMultiplier,
                  height: 3.38 * SizeConfig.imageSizeMultiplier),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().textWidget(buttonText, textStyle),
                    Visibility(
                        visible: isClockIn,
                        child: CommonWidgets()
                            .textWidget(clockInTime, timeTextStyle))
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
  onTapCreateEventButton()async{
    await showDialog(
        barrierDismissible: false,
        barrierColor:AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return const CreateAdhocEvent();
        }).then((value){
        if(value){
          refreshDataOnRequest();
        }
    });
  }

  onTapClockInOutButton() {
    callClockInOutAPI();
  }


  onTapEventItem(Events events) {

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventMenuScreen(events: events))).then((value) {
      P2PConnectionManager.shared.updateData(action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
      widget.onCallback(value);
    });
  }

  startTimer() {
    clockInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        clockInTime = Date.getDateInHrMinSec(date: startDateTime);
      });
    });
  }

  stopTimer() {
    setState(() {
      if (clockInTimer != null) {
        clockInTimer!.cancel();
        clockInTime = StringConstants.defaultClockInTime;
      }
    });
  }

  //API Call
  callClockInOutAPI() async {
    setState(() {
      isApiProcess = true;
    });
    clockInOutRequestModel.dutyStatus = !isClockIn;
    String userID = await FunctionalUtils.getUserID();
    clockInOutPresenter.clockInOutUpdate(clockInOutRequestModel, userID);
  }

  callClockInOutDetailsAPI() async {
    setState(() {
      isApiProcess = true;
    });

    String startTimestamp = Date.getStartOfDateTimeStamp(date: DateTime.now());
    String endTimestamp = Date.getEndOfDateTimeStamp(date: DateTime.now());
    String userID = await FunctionalUtils.getUserID();
    clockInOutPresenter.clockInOutDetails(
        userID: userID,
        startTimestamp: startTimestamp,
        endTimestamp: endTimestamp);
  }


  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    List<ClockInOutDetailsResponseModel> clockInOutList = response;
    ClockInOutDetailsResponseModel? clockInOutDetailsModel =
    clockInOutList.isNotEmpty
        ? clockInOutList.firstWhere((element) => element.clockOutAt == 0,
        orElse: () => ClockInOutDetailsResponseModel())
        : null;
    if (clockInOutDetailsModel != null &&
        clockInOutDetailsModel.clockInAt != null) {
      setState(() {
        isApiProcess = false;
        var timeStamp = clockInOutDetailsModel.clockInAt ??
            DateTime
                .now()
                .millisecondsSinceEpoch;
        startDateTime = Date.getDateFromTimeStamp(timestamp: timeStamp);
        FunctionalUtils.clockInTimestamp = timeStamp;
        isClockIn = true;
      });
    } else {
      setState(() {
        isApiProcess = false;
        FunctionalUtils.clockInTimestamp = 0;
        startDateTime = Date.getDateFromTimeStamp(timestamp: DateTime.now().millisecondsSinceEpoch);
        isClockIn = false;
      });
    }
    isClockIn ? startTimer() : stopTimer();
  }

  @override
  void showErrorForUpdateClockIN(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccessForUpdateClockIN(response) {
    if (!isClockIn) {
      setState(() {
        isApiProcess = false;
        //isClockIn = !isClockIn;
      });
      callClockInOutDetailsAPI();
    } else {
      setState(() {
        isApiProcess = false;
        isClockIn = !isClockIn;
        FunctionalUtils.clockInTimestamp = 0;
        startDateTime = Date.getDateFromTimeStamp(timestamp: DateTime.now().millisecondsSinceEpoch);
      });
    }
  }


  @override
  void showSyncError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSyncSuccess(response) {
    _syncEventMenuResponseModel.clear();
    pOsSyncEventDataDtoList.clear();
    pOsSyncItemCategoryDataDtoList.clear();
    pOsSyncEventItemDataDtoList.clear();
    pOsSyncEventItemExtrasDataDtoList.clear();
    pOsSyncDeletedEventDataDtoList.clear();
    pOsSyncDeletedItemCategoryDataDtoList.clear();
    pOsSyncDeletedEventItemDataDtoList.clear();
    pOsSyncDeletedEventItemExtrasDataDtoList.clear();

    setState(() {
      isApiProcess = false;
      eventList.clear();
      _syncEventMenuResponseModel.add(response);
    });
    storeDataIntoDB();
  }

  void storeDataIntoDB() {
    setState(() {
      pOsSyncEventDataDtoList
          .addAll(_syncEventMenuResponseModel[0].pOsSyncEventDataDtoList);
      pOsSyncItemCategoryDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncItemCategoryDataDtoList);
      pOsSyncEventItemDataDtoList
          .addAll(_syncEventMenuResponseModel[0].pOsSyncEventItemDataDtoList);
      pOsSyncEventItemExtrasDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncEventItemExtrasDataDtoList);
      pOsSyncDeletedEventDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedEventDataDtoList);
      pOsSyncDeletedItemCategoryDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedItemCategoryDataDtoList);
      pOsSyncDeletedEventItemDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedEventItemDataDtoList);
      pOsSyncDeletedEventItemExtrasDataDtoList.addAll(
          _syncEventMenuResponseModel[0]
              .pOsSyncDeletedEventItemExtrasDataDtoList);
    });

    insertEventSync();
  }

  Future<void> insertEventSync() async {
    if (pOsSyncEventDataDtoList.isNotEmpty) {
      for (int i = 0; i < pOsSyncEventDataDtoList.length; i++) {
        await EventsDAO().insert(Events(
            id: pOsSyncEventDataDtoList[i].eventId!,
            eventCode: pOsSyncEventDataDtoList[i].eventCode!,
            name: pOsSyncEventDataDtoList[i].name!,
            startDateTime: pOsSyncEventDataDtoList[i].startDateTime!,
            endDateTime: pOsSyncEventDataDtoList[i].endDateTime!,
            delivery: "empty",
            link: "empty",
            addressLine1: pOsSyncEventDataDtoList[i].addressLine1!,
            addressLine2: pOsSyncEventDataDtoList[i].addressLine2 ?? "",
            country: pOsSyncEventDataDtoList[i].country!,
            state: pOsSyncEventDataDtoList[i].state!,
            city: pOsSyncEventDataDtoList[i].city!,
            zipCode: pOsSyncEventDataDtoList[i].zipCode!,
            contactName: "empty",
            contactEmail: "empty",
            contactPhoneNumCountryCode: "empty",
            contactPhoneNumber: "empty",
            key: "empty",
            values: "empty",
            displayAdditionalPaymentField: false,
            additionalPaymentFieldLabel: "empty",
            activated: false,
            createdBy: pOsSyncEventDataDtoList[i].createdBy!,
            createdAt: pOsSyncEventDataDtoList[i].createdAt!,
            updatedBy: pOsSyncEventDataDtoList[i].updatedBy!,
            updatedAt: pOsSyncEventDataDtoList[i].updatedAt!,
            deleted: pOsSyncEventDataDtoList[i].deleted!,
            franchiseId: "empty",
            minimumOrderAmount: 0.0,
            eventStatus: "empty",
            specialInstructionLabel: "empty",
            displayGratuityField: false,
            gratuityFieldLabel: "empty",
            campaignId: "empty",
            enableDonation: false,
            donationFieldLabel: "empty",
            assetId: "empty",
            weatherType: "empty",
            paymentTerm: "empty",
            secondaryContactName: "empty",
            secondaryContactEmail: "empty",
            secondaryContactPhoneNumCountryCode: "empty",
            secondaryContactPhoneNumber: "empty",
            notes: "empty",
            eventType: "empty",
            preOrder: false,
            radius: 0,
            timeSlot: 0,
            maxOrderInSlot: 0,
            locationNotes: "empty",
            orderAttribute: "empty",
            minimumDeliveryTime: 0,
            startAddress: "empty",
            useTimeSlot: false,
            maxAllowedOrders: 0,
            deliveryMessage: "empty",
            recipientNameLabel: "empty",
            orderStartDateTime: 0,
            orderEndDateTime: 0,
            smsNotification: false,
            emailNotification: false,
            clientId: "empty",
            recurringType: "empty",
            days: "empty",
            monthlyDateTime: 0,
            expiryDate: 0,
            lastDayOfMonth: false,
            seriesId: "empty",
            manualStatus: "empty",
            entryFee: 0,
            cashAmount: 0,
            checkAmount: 0,
            ccAmount: 0,
            eventSalesCollected: 0,
            salesTax: pOsSyncEventDataDtoList[i].salesTax ?? 0,
            giveback: 0,
            tipAmount: 0,
            netEventSales: 0,
            eventSales: 0,
            collected: 0,
            balance: 0,
            givebackPaid: false,
            clientInvoice: false,
            givebackSettledDate: 0,
            invoiceSettledDate: 0,
            givebackCheck: "empty",
            thankYouEmail: false,
            eventSalesTypeId: "empty",
            minimumFee: 0,
            keepCupCount: false,
            cupCountTotal: 0,
            packageFee: 0,
            prePay: false,
            contactTitle: "empty",
            clientIndustriesTypeId: "empty",
            invoiceCheck: "string",
            oldDbEventId: "string",
            confirmedEmailSent: false,
            givebackSubtotal: 0));
      }
    }
    updateLastEventSync();
    loadDataFromDb();
    if (pOsSyncItemCategoryDataDtoList.isNotEmpty) {
      for (int i = 0; i < pOsSyncItemCategoryDataDtoList.length; i++) {
        await ItemCategoriesDAO().insert(ItemCategories(
            id: pOsSyncItemCategoryDataDtoList[i].categoryId!,
            eventId: pOsSyncItemCategoryDataDtoList[i].eventId!,
            categoryCode: pOsSyncItemCategoryDataDtoList[i].categoryCode != null
                ? pOsSyncItemCategoryDataDtoList[i].categoryCode!
                : "empty",
            categoryName: pOsSyncItemCategoryDataDtoList[i].categoryName!,
            description: pOsSyncItemCategoryDataDtoList[i].categoryName!,
            activated: false,
            createdBy: pOsSyncItemCategoryDataDtoList[i].createdBy!,
            createdAt: pOsSyncItemCategoryDataDtoList[i].createdAt!,
            updatedBy: pOsSyncItemCategoryDataDtoList[i].updatedBy!,
            updatedAt: pOsSyncItemCategoryDataDtoList[i].updatedAt!,
            deleted: pOsSyncItemCategoryDataDtoList[i].deleted!,
            franchiseId: "empty"));
      }
    }
    updateLastCategoriesSync();
    if (pOsSyncEventItemExtrasDataDtoList.isNotEmpty) {
      for (int i = 0; i < pOsSyncEventItemExtrasDataDtoList.length; i++) {
        await FoodExtraItemsDAO().insert(FoodExtraItems(
            id: pOsSyncEventItemExtrasDataDtoList[i].foodExtraItemId!,
            foodExtraItemCategoryId: '0',
            itemId: pOsSyncEventItemExtrasDataDtoList[i].itemId!,
            eventId: pOsSyncEventItemExtrasDataDtoList[i].eventId!,
            itemName: pOsSyncEventItemExtrasDataDtoList[i].itemName!,
            sellingPrice: pOsSyncEventItemExtrasDataDtoList[i].sellingPrice!,
            selection: "empty",
            imageFileId: pOsSyncEventItemExtrasDataDtoList[i].imageFileId!,
            minQtyAllowed: pOsSyncEventItemExtrasDataDtoList[i].minQtyAllowed!,
            maxQtyAllowed: pOsSyncEventItemExtrasDataDtoList[i].maxQtyAllowed!,
            activated: false,
            createdBy: pOsSyncEventItemExtrasDataDtoList[i].createdBy!,
            createdAt: pOsSyncEventItemExtrasDataDtoList[i].createdAt!,
            updatedBy: pOsSyncEventItemExtrasDataDtoList[i].updatedBy!,
            updatedAt: pOsSyncEventItemExtrasDataDtoList[i].updatedAt!,
            deleted: pOsSyncEventItemExtrasDataDtoList[i].deleted!));
      }
    }
    updateLastItemExtrasSync();
    if (pOsSyncEventItemDataDtoList.isNotEmpty) {
      for (int i = 0; i < pOsSyncEventItemDataDtoList.length; i++) {
        await ItemDAO().insert(Item(
            id: pOsSyncEventItemDataDtoList[i].itemId!,
            eventId: pOsSyncEventItemDataDtoList[i].eventId!,
            itemCategoryId: pOsSyncEventItemDataDtoList[i].itemCategoryId!,
            itemCode: pOsSyncEventItemDataDtoList[i].itemCode!,
            imageFileId: "empty",
            name: pOsSyncEventItemDataDtoList[i].name!,
            description: pOsSyncEventItemDataDtoList[i].description!,
            price: pOsSyncEventItemDataDtoList[i].price!,
            activated: false,
            createdBy: pOsSyncEventItemDataDtoList[i].createdBy!,
            createdAt: pOsSyncEventItemDataDtoList[i].createdAt!,
            updatedBy: pOsSyncEventItemDataDtoList[i].updatedBy!,
            updatedAt: pOsSyncEventItemDataDtoList[i].updatedAt!,
            deleted: pOsSyncEventItemDataDtoList[i].deleted!,
            franchiseId: "empty"));
      }
    }
    updateLastItemSync();
  }

  Future<void> updateLastEventSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.events,
        value: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
  }

  Future<void> updateLastItemSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.items,
        value: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
  }

  Future<void> updateLastCategoriesSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.categories,
        value: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
  }

  Future<void> updateLastItemExtrasSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.itemExtras,
        value: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
  }
}

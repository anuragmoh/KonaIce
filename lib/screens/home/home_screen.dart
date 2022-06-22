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
import 'package:kona_ice_pos/models/network_model/clock_in_clock_out/clock_in_out_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/clock_in_out/clock_in_out_presenter.dart';
import 'package:kona_ice_pos/network/repository/sync/sync_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/event_menu/event_menu_screen.dart';
import 'package:kona_ice_pos/screens/home/create_adhvoc_event_popup.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

import '../../common/base_method.dart';
import '../../common/extensions/string_extension.dart';

//ignore: must_be_immutable
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
    _clockInOutPresenter = ClockInOutPresenter(this);
    _syncPresenter = SyncPresenter(this);
  }

  String _currentDate =
      Date.getTodaysDate(formatValue: DateFormatsConstant.ddMMMYYYYDay);
  String _clockInTime = StringConstants.defaultClockInTime;
  late DateTime _startDateTime;
  Timer? _clockInTimer;
  bool _isClockIn = false;
  bool _isApiProcess = false;
  bool _isCreateAdhocEventButtonEnable = true;
  List<Events> _eventList = [];
  final List<SyncEventMenu> _syncEventMenuResponseModel = [];
  List<POsSyncEventDataDtoList> _pOsSyncEventDataDtoList = [];
  List<POsSyncItemCategoryDataDtoList> _pOsSyncItemCategoryDataDtoList = [];
  List<POsSyncEventItemDataDtoList> _pOsSyncEventItemDataDtoList = [];
  List<POsSyncEventItemExtrasDataDtoList> _pOsSyncEventItemExtrasDataDtoList =
      [];
  List<POsSyncEventDataDtoList> _pOsSyncDeletedEventDataDtoList = [];
  List<POsSyncItemCategoryDataDtoList> _pOsSyncDeletedItemCategoryDataDtoList =
      [];
  List<POsSyncEventItemDataDtoList> _pOsSyncDeletedEventItemDataDtoList = [];
  List<POsSyncEventItemExtrasDataDtoList>
      _pOsSyncDeletedEventItemExtrasDataDtoList = [];

  late ClockInOutPresenter _clockInOutPresenter;
  ClockInOutRequestModel _clockInOutRequestModel = ClockInOutRequestModel();

  _refreshDataOnRequest() async {
    await SessionDAO().getValueForKey(DatabaseKeys.events).then((value) {
      _refreshDB(value);
    });
  }

  Future<void> _refreshDB(Session? value) async {
    if (value != null) {
      int lastSyncTime = int.parse(value.value);

      if (await CheckConnection.connectionState() == true) {
        //eventList.clear();
        setState(() {
          _isApiProcess = true;
        });
        _syncPresenter.syncData(lastSyncTime);
      } else {
        _loadDataFromDb();
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
    } else {
      if (await CheckConnection.connectionState() == true) {
        setState(() {
          _isApiProcess = true;
        });
        _syncPresenter.syncData(0);
      } else {
        _loadDataFromDb();
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
    }
  }

  _loadDataFromDb() async {
    setState(() {
      _eventList.clear();
    });
    var result = await EventsDAO().getTodayEvent(
        Date.getStartOfDateTimeStamp(date: DateTime.now()),
        Date.getEndOfDateTimeStamp(date: DateTime.now()));
    // var result = await EventsDAO().getValues();
    if (result != null) {
      setState(() {
        _eventList.addAll(result);
      });
    } else {
      setState(() {
        _eventList.clear();
      });
    }
  }

  _getAdhocEventDate() async {
    var result = await SessionDAO().getValueForKey(DatabaseKeys.adhocEvent);
    if (result != null) {
      String lastValue = result.value;
      if (lastValue == Date.getTimeStampFromDate()) {
        setState(() {
          _isCreateAdhocEventButtonEnable = true;
        });
      } else {
        setState(() {
          _isCreateAdhocEventButtonEnable = true;
        });
      }
    } else {
      setState(() {
        _isCreateAdhocEventButtonEnable = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshDataOnRequest();
    _getAdhocEventDate();
    if (FunctionalUtils.clockInTimestamp == 0) {
      _callClockInOutDetailsAPI();
    } else {
      setState(() {
        _isApiProcess = false;
        _isClockIn = true;
        var timeStamp = FunctionalUtils.clockInTimestamp;
        _startDateTime = Date.getDateFromTimeStamp(timestamp: timeStamp);
        _isClockIn ? _startTimer() : _stopTimer();
      });
    }
    _callClockInOutDetailsAPI();
    if (!P2PConnectionManager.shared.isServiceStarted) {
      P2PConnectionManager.shared.startService(isStaffView: true);
    }
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(color: AppColors.textColor3, child: _body()),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 23.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _createEventButton(
                  StringConstants.createAdhocEvent,
                  StyleConstants.customTextStyle12MontserratBold(
                      color: AppColors.textColor1)),
              CommonWidgets().textWidget(
                  _currentDate,
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.textColor1)),
              _clockInOutButton(
                  _isClockIn
                      ? StringConstants.clockOut
                      : StringConstants.clockIn,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.whiteColor,
                      fontFamily: _isClockIn
                          ? FontConstants.montserratBold
                          : FontConstants.montserratMedium),
                  StyleConstants.customTextStyle12MonsterMedium(
                      color: AppColors.whiteColor))
            ],
          ),
          Expanded(
              child: FractionallySizedBox(
                  widthFactor: _eventList.isNotEmpty ? 0.68 : 1.0,
                  alignment: Alignment.topLeft,
                  child: _listViewContainer()))
        ],
      ),
    );
  }

  Widget _listViewContainer() {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshDataOnRequest();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: _eventList.isNotEmpty
            ? _builListViewBuilder()
            : Center(
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.27),
                    Center(
                      child: Text(StringConstants.eventNotAvailable,
                          style: StyleConstants.customTextStyle20MontserratBold(
                              color: AppColors.textColor1)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ListView _builListViewBuilder() {
    return ListView.builder(
      itemCount: _eventList.length,
      itemBuilder: (BuildContext context, int index) {
        var eventDetails = _eventList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onTap: () {
              _onTapEventItem(eventDetails);
            },
            child: _buildCard(eventDetails),
          ),
        );
      },
    );
  }

  Card _buildCard(Events eventDetails) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CommonWidgets().textWidget(
                  eventDetails.getEventName(),
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.textColor1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                children: [
                  CommonWidgets().image(
                      image: AssetsConstants.locationPinIcon,
                      width: 2 * SizeConfig.imageSizeMultiplier,
                      height: 2.47 * SizeConfig.imageSizeMultiplier),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommonWidgets().textMultiLineWidget(
                          eventDetails.getEventAddress(),
                          StyleConstants.customTextStyle12MonsterMedium(
                              color: AppColors.textColor4)),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                CommonWidgets().image(
                    image: AssetsConstants.dateIcon,
                    width: 2 * SizeConfig.imageSizeMultiplier,
                    height: 2.47 * SizeConfig.imageSizeMultiplier),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CommonWidgets().textWidget(
                    eventDetails.getEventDate(),
                    StyleConstants.customTextStyle12MonsterMedium(
                        color: AppColors.textColor4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: CommonWidgets().textWidget(
                    eventDetails.getEventTime(),
                    StyleConstants.customTextStyle12MonsterMedium(
                        color: AppColors.textColor4),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createEventButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: _isCreateAdhocEventButtonEnable ? _onTapCreateEventButton : null,
      child: Container(
        decoration: BoxDecoration(
            color: _isCreateAdhocEventButtonEnable
                ? AppColors.primaryColor2
                : AppColors.denotiveColor4,
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

  Widget _clockInOutButton(
      String buttonText, TextStyle textStyle, TextStyle timeTextStyle) {
    return GestureDetector(
      onTap: _onTapClockInOutButton,
      child: Container(
        height: 4.19 * SizeConfig.heightSizeMultiplier,
        decoration: BoxDecoration(
          color:
              _isClockIn ? AppColors.denotiveColor1 : AppColors.denotiveColor2,
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
                        visible: _isClockIn,
                        child: CommonWidgets()
                            .textWidget(_clockInTime, timeTextStyle))
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
  _onTapCreateEventButton() async {
    await showDialog(
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return const CreateAdhocEvent();
        }).then((value) {
      if (value) {
        _refreshDataOnRequest();
        _getAdhocEventDate();
      }
    });
  }

  _onTapClockInOutButton() {
    _callClockInOutAPI();
  }

  _onTapEventItem(Events events) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => EventMenuScreen(events: events)))
        .then((value) {
      P2PConnectionManager.shared.updateData(
          action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
      widget.onCallback(value);
    });
  }

  _startTimer() {
    _clockInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _clockInTime = Date.getDateInHrMinSec(date: _startDateTime);
      });
    });
  }

  _stopTimer() {
    setState(() {
      if (_clockInTimer != null) {
        _clockInTimer!.cancel();
        _clockInTime = StringConstants.defaultClockInTime;
      }
    });
  }

  //API Call
  _callClockInOutAPI() async {
    setState(() {
      _isApiProcess = true;
    });
    _clockInOutRequestModel.dutyStatus = !_isClockIn;
    String userID = await FunctionalUtils.getUserID();
    _clockInOutPresenter.clockInOutUpdate(_clockInOutRequestModel, userID);
  }

  _callClockInOutDetailsAPI() async {
    setState(() {
      _isApiProcess = true;
    });

    String startTimestamp = Date.getStartOfDateTimeStamp(date: DateTime.now());
    String endTimestamp = Date.getEndOfDateTimeStamp(date: DateTime.now());
    String userID = await FunctionalUtils.getUserID();
    _clockInOutPresenter.clockInOutDetails(
        userID: userID,
        startTimestamp: startTimestamp,
        endTimestamp: endTimestamp);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
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
        _isApiProcess = false;
        var timeStamp = clockInOutDetailsModel.clockInAt ??
            DateTime.now().millisecondsSinceEpoch;
        _startDateTime = Date.getDateFromTimeStamp(timestamp: timeStamp);
        FunctionalUtils.clockInTimestamp = timeStamp;
        _isClockIn = true;
      });
    } else {
      setState(() {
        _isApiProcess = false;
        FunctionalUtils.clockInTimestamp = 0;
        _startDateTime = Date.getDateFromTimeStamp(
            timestamp: DateTime.now().millisecondsSinceEpoch);
        _isClockIn = false;
      });
    }
    _isClockIn ? _startTimer() : _stopTimer();
  }

  @override
  void showErrorForUpdateClockIN(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccessForUpdateClockIN(response) {
    if (!_isClockIn) {
      setState(() {
        _isApiProcess = false;
        //isClockIn = !isClockIn;
      });
      _callClockInOutDetailsAPI();
    } else {
      setState(() {
        _isApiProcess = false;
        _isClockIn = !_isClockIn;
        FunctionalUtils.clockInTimestamp = 0;
        _startDateTime = Date.getDateFromTimeStamp(
            timestamp: DateTime.now().millisecondsSinceEpoch);
      });
    }
  }

  @override
  void showSyncError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSyncSuccess(response) {
    _syncEventMenuResponseModel.clear();
    _pOsSyncEventDataDtoList.clear();
    _pOsSyncItemCategoryDataDtoList.clear();
    _pOsSyncEventItemDataDtoList.clear();
    _pOsSyncEventItemExtrasDataDtoList.clear();
    _pOsSyncDeletedEventDataDtoList.clear();
    _pOsSyncDeletedItemCategoryDataDtoList.clear();
    _pOsSyncDeletedEventItemDataDtoList.clear();
    _pOsSyncDeletedEventItemExtrasDataDtoList.clear();

    setState(() {
      _isApiProcess = false;
      _eventList.clear();
      _syncEventMenuResponseModel.add(response);
    });
    _storeDataIntoDB();
  }

  void _storeDataIntoDB() async {
    setState(() {
      _pOsSyncEventDataDtoList
          .addAll(_syncEventMenuResponseModel[0].pOsSyncEventDataDtoList);
      _pOsSyncItemCategoryDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncItemCategoryDataDtoList);
      _pOsSyncEventItemDataDtoList
          .addAll(_syncEventMenuResponseModel[0].pOsSyncEventItemDataDtoList);
      _pOsSyncEventItemExtrasDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncEventItemExtrasDataDtoList);
      _pOsSyncDeletedEventDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedEventDataDtoList);
      _pOsSyncDeletedItemCategoryDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedItemCategoryDataDtoList);
      _pOsSyncDeletedEventItemDataDtoList.addAll(
          _syncEventMenuResponseModel[0].pOsSyncDeletedEventItemDataDtoList);
      _pOsSyncDeletedEventItemExtrasDataDtoList.addAll(
          _syncEventMenuResponseModel[0]
              .pOsSyncDeletedEventItemExtrasDataDtoList);
    });

    await _deleteEventSync();
    _insertEventSync();
  }

  Future<void> _deleteEventSync() async {
    if (_pOsSyncDeletedEventDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncDeletedEventDataDtoList.length; i++) {
        String eventID = _pOsSyncDeletedEventDataDtoList[i].eventId ??
            StringExtension.empty();
        await EventsDAO().clearEventsByEventID(eventID: eventID);
        await ItemCategoriesDAO().clearCategoriesByEventID(eventID: eventID);
        await ItemDAO().clearItemsByEventID(eventID: eventID);
        await FoodExtraItemsDAO()
            .clearFoodExtraItemsByEventID(eventID: eventID);
      }
    }

    if (_pOsSyncDeletedItemCategoryDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncDeletedItemCategoryDataDtoList.length; i++) {
        String eventID = _pOsSyncDeletedItemCategoryDataDtoList[i].eventId ??
            StringExtension.empty();
        await ItemCategoriesDAO().clearCategoriesByEventID(eventID: eventID);
      }
    }

    if (_pOsSyncDeletedEventItemDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncDeletedEventItemDataDtoList.length; i++) {
        String eventID = _pOsSyncDeletedEventItemDataDtoList[i].eventId ??
            StringExtension.empty();
        String itemID = _pOsSyncDeletedEventItemDataDtoList[i].itemId ??
            StringExtension.empty();
        await ItemDAO().clearItemsByEventID(eventID: eventID);
        await FoodExtraItemsDAO().clearFoodExtraItemsByEventIDAndItemID(
            eventID: eventID, itemID: itemID);
      }
    }

    if (_pOsSyncDeletedEventItemExtrasDataDtoList.isNotEmpty) {
      for (int i = 0;
          i < _pOsSyncDeletedEventItemExtrasDataDtoList.length;
          i++) {
        String eventID = _pOsSyncDeletedEventItemExtrasDataDtoList[i].eventId ??
            StringExtension.empty();
        String itemID = _pOsSyncDeletedEventItemExtrasDataDtoList[i].itemId ??
            StringExtension.empty();
        await FoodExtraItemsDAO().clearFoodExtraItemsByEventIDAndItemID(
            eventID: eventID, itemID: itemID);
      }
    }
  }

  BaseMethod _baseMethod = BaseMethod();

  Future<void> _insertEventSync() async {
    if (_pOsSyncEventDataDtoList.isNotEmpty) {
      await _baseMethod.insertData(_pOsSyncEventDataDtoList);
    }
    _updateLastEventSync();
    _loadDataFromDb();
    if (_pOsSyncItemCategoryDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncItemCategoryDataDtoList.length; i++) {
        await ItemCategoriesDAO().insert(ItemCategories(
            id: _pOsSyncItemCategoryDataDtoList[i].categoryId!,
            eventId: _pOsSyncItemCategoryDataDtoList[i].eventId!,
            categoryCode:
                _pOsSyncItemCategoryDataDtoList[i].categoryCode != null
                    ? _pOsSyncItemCategoryDataDtoList[i].categoryCode!
                    : "empty",
            categoryName: _pOsSyncItemCategoryDataDtoList[i].categoryName!,
            description: _pOsSyncItemCategoryDataDtoList[i].categoryName!,
            activated: false,
            createdBy: _pOsSyncItemCategoryDataDtoList[i].createdBy!,
            createdAt: _pOsSyncItemCategoryDataDtoList[i].createdAt!,
            updatedBy: _pOsSyncItemCategoryDataDtoList[i].updatedBy!,
            updatedAt: _pOsSyncItemCategoryDataDtoList[i].updatedAt!,
            deleted: _pOsSyncItemCategoryDataDtoList[i].deleted!,
            franchiseId: "empty"));
      }
    }
    _updateLastCategoriesSync();
    if (_pOsSyncEventItemExtrasDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncEventItemExtrasDataDtoList.length; i++) {
        await FoodExtraItemsDAO().insert(FoodExtraItems(
            id: _pOsSyncEventItemExtrasDataDtoList[i].foodExtraItemId!,
            foodExtraItemCategoryId: '0',
            itemId: _pOsSyncEventItemExtrasDataDtoList[i].itemId!,
            eventId: _pOsSyncEventItemExtrasDataDtoList[i].eventId!,
            itemName: _pOsSyncEventItemExtrasDataDtoList[i].itemName!,
            sellingPrice: _pOsSyncEventItemExtrasDataDtoList[i].sellingPrice!,
            selection: "empty",
            sequence: _pOsSyncEventItemExtrasDataDtoList[i].sequence!,
            imageFileId: _pOsSyncEventItemExtrasDataDtoList[i].imageFileId!,
            minQtyAllowed: _pOsSyncEventItemExtrasDataDtoList[i].minQtyAllowed!,
            maxQtyAllowed: _pOsSyncEventItemExtrasDataDtoList[i].maxQtyAllowed!,
            activated: false,
            createdBy: _pOsSyncEventItemExtrasDataDtoList[i].createdBy!,
            createdAt: _pOsSyncEventItemExtrasDataDtoList[i].createdAt!,
            updatedBy: _pOsSyncEventItemExtrasDataDtoList[i].updatedBy!,
            updatedAt: _pOsSyncEventItemExtrasDataDtoList[i].updatedAt!,
            deleted: _pOsSyncEventItemExtrasDataDtoList[i].deleted!));
      }
    }
    _updateLastItemExtrasSync();
    if (_pOsSyncEventItemDataDtoList.isNotEmpty) {
      for (int i = 0; i < _pOsSyncEventItemDataDtoList.length; i++) {
        await ItemDAO().insert(Item(
            id: _pOsSyncEventItemDataDtoList[i].itemId!,
            eventId: _pOsSyncEventItemDataDtoList[i].eventId!,
            itemCategoryId: _pOsSyncEventItemDataDtoList[i].itemCategoryId!,
            itemCode: _pOsSyncEventItemDataDtoList[i].itemCode!,
            imageFileId: "empty",
            name: _pOsSyncEventItemDataDtoList[i].name!,
            description: _pOsSyncEventItemDataDtoList[i].description!,
            price: _pOsSyncEventItemDataDtoList[i].price!,
            activated: false,
            sequence: _pOsSyncEventItemDataDtoList[i].sequence!,
            createdBy: _pOsSyncEventItemDataDtoList[i].createdBy!,
            createdAt: _pOsSyncEventItemDataDtoList[i].createdAt!,
            updatedBy: _pOsSyncEventItemDataDtoList[i].updatedBy!,
            updatedAt: _pOsSyncEventItemDataDtoList[i].updatedAt!,
            deleted: _pOsSyncEventItemDataDtoList[i].deleted!,
            franchiseId: "empty"));
      }
    }
    _updateLastItemSync();
  }

  Future<void> _updateLastEventSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.events,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastItemSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.items,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastCategoriesSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.categories,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastItemExtrasSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.itemExtras,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  eventCreatedCallBack(dynamic value) {}
}

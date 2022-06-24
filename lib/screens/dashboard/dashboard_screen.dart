import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
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
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/dashboard/bottom_items.dart';
import 'package:kona_ice_pos/screens/home/home_screen.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/settings/settings.dart';
import 'package:kona_ice_pos/utils/ServiceNotifier.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/bottombar_menu_abstract_class.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

import '../../common/base_method.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    implements ResponseContractor, BottomBarMenu {
  List<Events> _eventList = [];
  final _service = ServiceNotifier();
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
  bool _isApiProcess = false;
  int _currentIndex = 0;
  String _userName = StringExtension.empty();
  List<BottomItems> _bottomItemList = [
    BottomItems(
        title: StringConstants.home,
        basicImage: AssetsConstants.homeUnSelectedIcon,
        selectedImage: AssetsConstants.homeSelectedIcon),
    BottomItems(
        title: StringConstants.settings,
        basicImage: AssetsConstants.settingsUnSelectedIcon,
        selectedImage: AssetsConstants.settingsSelectedIcon),
  ];

  Future<void> _getSyncData() async {
    var result = await EventsDAO().getValues();
    if (result != null) {
      _eventList.addAll(result);
    } else {
      setState(() {
        _isApiProcess = true;
      });
    }
  }

  void _getIndex() {
    setState(() {
      _currentIndex = ServiceNotifier.count;
      debugPrint(_currentIndex.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _configureData();
    _getIndex();
    // getSyncData();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textColor3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommonWidgets().dashboardTopBar(_topBarComponent()),
          Expanded(
            child: _currentIndex == 0
                ? HomeScreen(onCallback: _onReloadDashboardScreen)
                : const SettingScreen(),
          ),
          BottomBarWidget(
            onTapCallBack: _onTapBottomListItem,
            accountImageVisibility: false,
            isFromDashboard: true,
          ),
        ],
      ),
    );
  }

  Widget _topBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, right: 22.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _konaTopBarIcon(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: CommonWidgets().textWidget(
                  StringConstants.dashboard,
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.whiteColor)),
            ),
          ),
          GestureDetector(
              onTap: _onProfileChange,
              child: CommonWidgets().profileComponent(_userName)),
        ],
      ),
    );
  }

  Widget _konaTopBarIcon() {
    return CommonWidgets().image(
        image: AssetsConstants.topBarAppIcon,
        width: 4.03 * SizeConfig.imageSizeMultiplier,
        height: 4.03 * SizeConfig.imageSizeMultiplier);
  }

  Widget _bottomBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0),
      child: ListView.builder(
          itemCount: _bottomItemList.length,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _onTapBottomListItem(index);
              },
              child: Row(
                children: [
                  CommonWidgets().image(
                      image: _currentIndex == index
                          ? _bottomItemList[index].selectedImage
                          : _bottomItemList[index].basicImage,
                      width: 26.0,
                      height: 26.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 35.0),
                    child: CommonWidgets().textWidget(
                        _bottomItemList[index].title,
                        StyleConstants.customTextStyle(
                            fontSize: 13.0,
                            color: _currentIndex == index
                                ? AppColors.primaryColor2
                                : AppColors.whiteColor,
                            fontFamily: _currentIndex == index
                                ? FontConstants.montserratSemiBold
                                : FontConstants.montserratMedium)),
                  )
                ],
              ),
            );
          }),
    );
  }

  _onTapBottomListItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()))
        .then((value) {
      _onReloadDashboardScreen(value);
    });
  }

  //Function Other than UI dependency
  _configureData() async {
    _userName = await FunctionalUtils.getUserName();
    setState(() {});
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSuccess(response) {
    setState(() {
      _isApiProcess = false;
      _syncEventMenuResponseModel.add(response);
    });
    _storeDataIntoDB();
  }

  void _storeDataIntoDB() {
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

    _insertEventSync();
  }

  Future<void> _insertEventSync() async {
    await _posSyncEventDtoList();
    _updateLastEventSync();
    await _posSyncItemCategoryDataDtoList();
    _updateLastCategoriesSync();
    await _posSyncEventItemExtrasDataDtoList();
    _updateLastItemExtrasSync();
    await _posSyncEventItemDataDtoList();
    _updateLastItemSync();
  }

  Future<void> _posSyncEventItemDataDtoList() async {
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

  Future<void> _posSyncEventItemExtrasDataDtoList() async {
    for (int i = 0; i < _pOsSyncEventItemExtrasDataDtoList.length; i++) {
      await FoodExtraItemsDAO().insert(FoodExtraItems(
          id: _pOsSyncEventItemExtrasDataDtoList[i].eventId!,
          foodExtraItemCategoryId:
              _pOsSyncEventItemExtrasDataDtoList[i].foodExtraItemId!,
          itemId: _pOsSyncEventItemExtrasDataDtoList[i].itemId!,
          eventId: _pOsSyncEventItemExtrasDataDtoList[i].eventId!,
          itemName: _pOsSyncEventItemExtrasDataDtoList[i].itemName!,
          sellingPrice: _pOsSyncEventItemExtrasDataDtoList[i].sellingPrice!,
          selection: "empty",
          imageFileId: _pOsSyncEventItemExtrasDataDtoList[i].imageFileId!,
          minQtyAllowed: _pOsSyncEventItemExtrasDataDtoList[i].minQtyAllowed!,
          maxQtyAllowed: _pOsSyncEventItemExtrasDataDtoList[i].maxQtyAllowed!,
          activated: false,
          sequence: _pOsSyncEventItemExtrasDataDtoList[i].sequence!,
          createdBy: _pOsSyncEventItemExtrasDataDtoList[i].createdBy!,
          createdAt: _pOsSyncEventItemExtrasDataDtoList[i].createdAt!,
          updatedBy: _pOsSyncEventItemExtrasDataDtoList[i].updatedBy!,
          updatedAt: _pOsSyncEventItemExtrasDataDtoList[i].updatedAt!,
          deleted: _pOsSyncEventItemExtrasDataDtoList[i].deleted!));
    }
  }

  Future<void> _posSyncItemCategoryDataDtoList() async {
    for (int i = 0; i < _pOsSyncItemCategoryDataDtoList.length; i++) {
      await ItemCategoriesDAO().insert(ItemCategories(
          id: _pOsSyncItemCategoryDataDtoList[i].categoryId!,
          eventId: _pOsSyncItemCategoryDataDtoList[i].eventId!,
          categoryCode: _pOsSyncItemCategoryDataDtoList[i].categoryCode != null
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

  BaseMethod _baseMethod = BaseMethod();
  Future<void> _posSyncEventDtoList() async {
    await _baseMethod.insertData(_pOsSyncEventDataDtoList);
  }

  Future<void> _updateLastEventSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.events,
        value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastItemSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.items,
        value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastCategoriesSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.categories,
        value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> _updateLastItemExtrasSync() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.itemExtras,
        value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  @override
  void changeIndex(index) {
    setState(() {
      _currentIndex = index;
      debugPrint('Dashboard$index');
    });
  }

  void _onReloadDashboardScreen(dynamic value) {
    setState(() {
      _currentIndex = ServiceNotifier.count;
    });
  }
}

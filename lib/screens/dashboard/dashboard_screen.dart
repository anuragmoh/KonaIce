import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/events_dao.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/sync/sync_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/dashboard/bottom_items.dart';
import 'package:kona_ice_pos/screens/home/home_screen.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/notifications/notifications_screen.dart';
import 'package:kona_ice_pos/screens/settings/settings.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements ResponseContractor {
  late SyncPresenter _syncPresenter;
  SyncEventRequestModel _eventRequestModel = SyncEventRequestModel();

  _DashboardState() {
    _syncPresenter = SyncPresenter(this);
  }
  List<SyncEventMenu> _syncEventMenuResponseModel=[];

  bool isApiProcess = false;
  int currentIndex = 0;
  String userName = StringExtension.empty();
  List<Widget> bodyWidgets = [const HomeScreen(), const SettingScreen()];
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



  void getSyncData() {
    _syncPresenter.syncData();
  }

  @override
  void initState() {
    super.initState();
    configureData();
    setState(() {
      isApiProcess=true;
    });
    getSyncData();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
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
          BottomBarWidget(
            onTapCallBack: onTapBottomListItem,
            accountImageVisibility: false,
            isFromDashboard: true,
          ),
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
    return CommonWidgets().image(
        image: AssetsConstants.topBarAppIcon,
        width: 4.03 * SizeConfig.imageSizeMultiplier,
        height: 4.03 * SizeConfig.imageSizeMultiplier);
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  //Function Other than UI dependency
  configureData() async {
    userName = await FunctionalUtils.getUserName();
    setState(() {});
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess=false;
    });
    CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);
  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess=false;
      _syncEventMenuResponseModel.addAll(response);

    });
    storeDataIntoDB();
  }

  void storeDataIntoDB(){
    List<POsSyncEventDataDtoList> pOsSyncEventDataDtoList=[];
    List<POsSyncItemCategoryDataDtoList> pOsSyncItemCategoryDataDtoList=[];
    List<POsSyncEventItemDataDtoList> pOsSyncEventItemDataDtoList=[];
    List<POsSyncEventItemExtrasDataDtoList> pOsSyncEventItemExtrasDataDtoList=[];
    List<POsSyncEventDataDtoList> pOsSyncDeletedEventDataDtoList=[];
    List<POsSyncItemCategoryDataDtoList> pOsSyncDeletedItemCategoryDataDtoList=[];
    List<POsSyncEventItemDataDtoList> pOsSyncDeletedEventItemDataDtoList=[];
    List<POsSyncEventItemExtrasDataDtoList> pOsSyncDeletedEventItemExtrasDataDtoList=[];

    setState(() {
      pOsSyncEventDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncEventDataDtoList);
      pOsSyncItemCategoryDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncItemCategoryDataDtoList);
      pOsSyncEventItemDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncEventItemDataDtoList);
      pOsSyncEventItemExtrasDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncEventItemExtrasDataDtoList);
      pOsSyncDeletedEventDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncDeletedEventDataDtoList);
      pOsSyncDeletedItemCategoryDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncDeletedItemCategoryDataDtoList);
      pOsSyncDeletedEventItemDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncDeletedEventItemDataDtoList);
      pOsSyncDeletedEventItemExtrasDataDtoList.addAll(_syncEventMenuResponseModel[0].pOsSyncDeletedEventItemExtrasDataDtoList);

    });

  }

  Future<void> updateLastEventSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.events, value: "0"));
  }

  Future<void> updateLastItemSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.items, value: "0"));
  }
  Future<void> updateLastCategoriesSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.categories, value: "0"));
  }
  Future<void> updateLastItemExtrasSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.itemExtras, value: "0"));
  }

}

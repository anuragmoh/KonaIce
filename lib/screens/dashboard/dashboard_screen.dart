import 'package:flutter/material.dart';
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
import 'package:kona_ice_pos/utils/utils.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements ResponseContractor,BottomBarMenu {
  List<Events> eventList = [];
  final service = ServiceNotifier();
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
  bool isApiProcess = false;
  int currentIndex = 0;
  String userName = StringExtension.empty();
  // List<Widget> bodyWidgets = [HomeScreen(onCallback:onCallBackDashboard), const SettingScreen()];
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

  Future<void> getSyncData() async {
    var result = await EventsDAO().getValues();
    if (result != null) {
      eventList.addAll(result);
    } else {
      setState(() {
        isApiProcess = true;
      });
    }
  }

  void getIndex() {
    setState(() {
      currentIndex=ServiceNotifier.count;
      debugPrint(currentIndex.toString());
    });

    debugPrint('getIndexCalled');
  }

  @override
  void initState() {
    super.initState();
    configureData();
    getIndex();
    // getSyncData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('dashboardScreen');
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
            child: currentIndex==0?HomeScreen(onCallback: onReloadDashboardScreen):const SettingScreen(),
            // child: bodyWidgets[currentIndex],
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
        .push(MaterialPageRoute(builder: (context) => const MyProfile())).then((value){onReloadDashboardScreen(value);});
  }

  //Function Other than UI dependency
  configureData() async {
    userName = await FunctionalUtils.getUserName();
    setState(() {});
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess = false;
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
          addressLine2: pOsSyncEventDataDtoList[i].addressLine2!,
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
    updateLastEventSync();
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
    updateLastCategoriesSync();
    for (int i = 0; i < pOsSyncEventItemExtrasDataDtoList.length; i++) {
      await FoodExtraItemsDAO().insert(FoodExtraItems(
          id: pOsSyncEventItemExtrasDataDtoList[i].eventId!,
          foodExtraItemCategoryId:
          pOsSyncEventItemExtrasDataDtoList[i].foodExtraItemId!,
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
    updateLastItemExtrasSync();
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
    updateLastItemSync();
  }

  Future<void> updateLastEventSync() async {
    await SessionDAO().insert(Session(key: DatabaseKeys.events, value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> updateLastItemSync() async {
    await SessionDAO().insert(Session(key: DatabaseKeys.items, value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> updateLastCategoriesSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.categories, value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  Future<void> updateLastItemExtrasSync() async {
    await SessionDAO()
        .insert(Session(key: DatabaseKeys.itemExtras, value: DateTime.now().microsecondsSinceEpoch.toString()));
  }

  @override
  void changeIndex(index) {
    setState(() {
      currentIndex = index;
      debugPrint('Dashboard$index');
    });
  }

  void onReloadDashboardScreen(dynamic value){
    print('onReloadDashboardScreen');
    setState(() {
      currentIndex=ServiceNotifier.count;
    });
  }


}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/food_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/item_categories_dao.dart';
import 'package:kona_ice_pos/database/daos/item_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/models/data_models/item_categories.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_items.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/orders/order_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/all_orders/all_orders_screen.dart';
import 'package:kona_ice_pos/screens/event_menu/custom_menu_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/food_extra_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/customer_model.dart';
import 'package:kona_ice_pos/screens/home/notification_drawer.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/search_customers_widget.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/payment/payment_screen.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dialog/dialog_helper.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';

import 'order_model/order_request_model.dart';
import 'order_model/order_response_model.dart';

class EventMenuScreen extends StatefulWidget {
  final Events events;
  const EventMenuScreen({Key? key, required this.events}) : super(key: key);

  @override
  _EventMenuScreenState createState() => _EventMenuScreenState();
}

class _EventMenuScreenState extends State<EventMenuScreen> implements
    OrderResponseContractor{

  late OrderPresenter orderPresenter;
  PlaceOrderResponseModel placeOrderResponseModel = PlaceOrderResponseModel();

  _EventMenuScreenState() {
    orderPresenter = OrderPresenter(this);
  }

  bool isApiProcess = false;
  List<ItemCategories> itemCategoriesList = [];
  List<FoodExtraItems> foodExtraItemList = [];

  bool isProduct = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchCustomer = false;
  TextEditingController addTipTextFieldController = TextEditingController();
  TextEditingController addDiscountTextFieldController = TextEditingController();
  TextEditingController applyCouponTextFieldController = TextEditingController();


  int selectedCategoryIndex = 1;
  int currentIndex = 0;

  List<Item> dbItemList = [];
  List<Item> itemList = [];
  List<Item> selectedMenuItems = [];
  String customerName = StringConstants.addCustomer;
  CustomerDetails? customer;
  double tip = 0.0;
  double salesTax = 0.0;
  double discount = 0.0;
  double totalAmount = 0.0;
  String orderID = '';

  double get totalAmountOfSelectedItems {
    if (selectedMenuItems.isEmpty) {
      return 0.0;
    } else {
      double sum = 0;
      for (var element in selectedMenuItems) {
        sum += element.getTotalPrice();
      }
      return sum;
    }
  }

  String userName = StringExtension.empty();

  onTapCallBack(bool callBackValue) {
    setState(() {
      isProduct = callBackValue;
    });
  }

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  // LocalDB call start from here.

  getItemCategoriesByEventId(String eventId) async {
    // Event Id need to pass
    var result = await ItemCategoriesDAO().getCategoriesByEventId(eventId);
    if (result != null) {
        setState(() {
          itemCategoriesList.add(ItemCategories.getCustomMenuCategory(
              eventId: eventId, name: StringConstants.customMenu));
          itemCategoriesList.add(ItemCategories.getCustomMenuCategory(
              eventId: eventId, name: StringConstants.allCategories));
          itemCategoriesList.addAll(result);
      });
    } else {
      setState(() {
        itemCategoriesList.clear();
      });
    }
  }

  getAllItems(String eventId) async {
    // Event Id need to pass
    var result = await ItemDAO().getAllItemsByEventId(eventId);
    if (result != null) {
      setState(() {
        itemList.clear();
        dbItemList.clear();
        itemList.addAll(result);
        dbItemList.addAll(itemList);
      });
    } else {
      setState(() {
        itemList.clear();
      });
    }
  }

  getItemsByCategory(String categoryId) async {
    // Category Id need to pass
    var result = await ItemDAO().getAllItemsByCategories(categoryId);
    if (result != null) {
      setState(() {
        itemList.addAll(result);
      });
    } else {
      setState(() {
        itemList.clear();
      });
    }
  }

  getExtraFoodItem() async {
    var result = await FoodExtraItemsDAO().getFoodExtraByEventIdAndItemId(
        "", "");
    if (result != null) {
      setState(() {
        foodExtraItemList.addAll(result);
      });
    } else {
      setState(() {
        foodExtraItemList.clear();
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getItemCategoriesByEventId(widget.events.id);
    getAllItems(widget.events.id);
    getUserName();
   // setSalesTax();
  }

  @override
  Widget build(BuildContext context) {
    updateCustomerName();
    calculateTotal();

    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }


  Widget mainUi(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: getMaterialColor(AppColors.textColor3),
      endDrawer: const NotificationDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(userName: userName,
            eventName: widget.events.getEventName(),
            eventAddress: widget.events.getEventAddress(),
            showCenterWidget: true,
            onTapCallBack: onTapCallBack,
            onDrawerTap: onDrawerTap,
             onProfileTap: onProfileChange,
             isProduct: isProduct),
          Expanded(
            child: isProduct ? body() : AllOrdersScreen(onBackTap: (saveOrders, orderItemList, extraItemList ) {
              onBackFromAllOrder(savedOrder: saveOrders, savedOrderItemList: orderItemList, savedOrderExtraItemList: extraItemList);
            }, events: widget.events),
          ),
          BottomBarWidget(onTapCallBack: onTapBottomListItem,
            accountImageVisibility: false,
            isFromDashboard: false,)
        ],
      ),
    );
  }

  Widget body() {
    return itemList.isNotEmpty ? Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(child: leftContainer()),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: rightContainer(),
          ),
        ],
      ),
    ) :
     Align(
        alignment: Alignment.center,
        child: CommonWidgets().textWidget(StringConstants.noMenuItemsAvailable, StyleConstants.customTextStyle(fontSize: 20.0, color: AppColors.textColor1, fontFamily: FontConstants.montserratSemiBold))
    );
  }

  Widget leftContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Row(
            children: [
              Flexible(child: categoriesListContainer()),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: addCategoriesButton(),
                ),
              )
            ],
          ),
        ),
        Expanded(child: menuGridContainer())
      ],
    );
  }

  Widget rightContainer() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.24,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.78,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: getMaterialColor(AppColors.textColor1).withOpacity(
                      0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2)
              )
            ]
        ),
        child: isSearchCustomer
            ? searchCustomerContainer()
            : rightCartViewContainer(),
      ),
    );
  }

  //Add to cart Container
  Widget rightCartViewContainer() {
    debugPrint('onRight cartView ${selectedMenuItems.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.topRight,
            child: clearButton()
        ),
        customerDetails(),
        Expanded(child: selectedMenuItems.isNotEmpty ? CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: selectedItemList()
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: couponContainer(),
            )
          ],

        ) : emptyCartView()
        ),
        chargeButton(),
        saveAndNewOrderButton()
      ],
    );
  }

  Widget searchCustomerContainer() {
    return SearchCustomers(onTapCustomer: onTapCustomerName,);
  }

  Widget categoriesListContainer() {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
          itemCount: itemCategoriesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: categoriesNameButton(index)
            );
          }
      ),
    );
  }

  Widget menuGridContainer() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 139 / 80
        ),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                onTapGridItem(index);
              },
              child: menuItem(index));
          //index == 0 ? addNewMenuItem() : menuItem(index));
        });
  }

  Widget menuItem(int index) {
    Item menuObject = itemList[index];
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: menuObject.isItemSelected ?
              [
                getMaterialColor(AppColors.gradientColor1),
                getMaterialColor(AppColors.gradientColor2)
              ]
                  : [
                getMaterialColor(AppColors.whiteColor),
                getMaterialColor(AppColors.whiteColor)
              ]
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: (menuObject.isItemHasExtras() &&
                              menuObject.isItemSelected) ? MainAxisAlignment
                              .start : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 3.0, right: 3.0),
                              child: Text(menuObject.name,
                                style: StyleConstants.customTextStyle(
                                    fontSize: 16.0,
                                    color: getMaterialColor(
                                        menuObject.isItemSelected ? AppColors
                                            .whiteColor : AppColors.textColor1),
                                    fontFamily: FontConstants
                                        .montserratSemiBold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            CommonWidgets().textWidget('\$${menuObject.price}',
                                StyleConstants.customTextStyle(
                                    fontSize: 12.0,
                                    color: getMaterialColor(
                                        menuObject.isItemSelected ? AppColors
                                            .whiteColor : AppColors.textColor2),
                                    fontFamily: FontConstants.montserratMedium))
                          ],
                        ),
                      ),
                      Flexible(
                        flex: menuObject.isItemSelected ? 1 : 0,
                        child: Visibility(
                          visible: menuObject.isItemSelected,
                          child: CommonWidgets().textWidget(
                              '${menuObject.selectedItemQuantity}',
                              StyleConstants.customTextStyle(
                                  fontSize: 16.0,
                                  color: getMaterialColor(AppColors.whiteColor),
                                  fontFamily: FontConstants.montserratRegular)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: menuObject.isItemSelected &&
                    menuObject.isItemHasExtras(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: InkWell(
                    onTap: () {
                      onTapFoodExtras(index);
                    },
                    child: CommonWidgets().textWidget(
                        StringConstants.addFoodItems,
                        StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor3),
                            fontFamily: FontConstants.montserratMedium)),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget addNewMenuItem() {
    return Container(
      decoration: BoxDecoration(
        color: getMaterialColor(AppColors.whiteColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: plusSymbolText(),
          ),
          SizedBox(
            width: 70.0,
            child: CommonWidgets().textWidget(
                StringConstants.addNewMenuItem, StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor2),
                fontFamily: FontConstants.montserratMedium),
                textAlign: TextAlign.center
            ),
          )
        ],
      ),
    );
  }

  Widget plusSymbolText() {
    return CommonWidgets().textWidget(
        StringConstants.plusSymbol, StyleConstants.customTextStyle(
        fontSize: 16.0, color: getMaterialColor(AppColors.primaryColor1),
        fontFamily: FontConstants.montserratBold)
    );
  }

  Widget customerDetails() {
    return GestureDetector(
      onTap: onTapAddCustomer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
        child: Row(
          children: [
            CommonWidgets().image(image: AssetsConstants.addCustomerIcon,
                width: 25.0,
                height: 25.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 5.0),
                child: CommonWidgets().textWidget(
                    customerName, StyleConstants.customTextStyle(
                    fontSize: 16.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold)),
              ),
            ),
            Visibility(
              visible: invalidCustomerName(),
              child: CommonWidgets().textWidget(
                  StringConstants.plusSymbol, StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)),
            )
          ],
        ),
      ),
    );
  }

  Widget emptyCartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonWidgets().image(
            image: AssetsConstants.addToCartIcon, width: 50.0, height: 50.0),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CommonWidgets().textWidget(
              StringConstants.noItemsAdded, StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: getMaterialColor(AppColors.textColor2),
              fontFamily: FontConstants.montserratSemiBold)),
        ),
      ],
    );
  }

  Widget selectedItemList() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedMenuItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: selectedItemDetailsComponent(index)),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CommonWidgets().quantityIncrementDecrementContainer(
                          quantity: selectedMenuItems[index].selectedItemQuantity,
                          onTapPlus: () {
                            onTapIncrementCountButton(index);
                          },
                          onTapMinus: () {
                            onTapDecrementCountButton(index);
                          }
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget selectedItemDetailsComponent(index) {
    Item menuObjet = selectedMenuItems[index];
    return GestureDetector(
      onTap: () {
        if (menuObjet.isItemHasExtras()) {
          onTapAddFoodExtras(index);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: CommonWidgets().textWidget(
                menuObjet.name, StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor4),
                fontFamily: FontConstants.montserratMedium)),
          ),
          Visibility(
            visible: (menuObjet.selectedExtras).isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
              child: CommonWidgets().textWidget(
                  menuObjet.getExtraItemsName(), StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium)),
            ),
          ),
          Visibility(
            visible: menuObjet.isItemHasExtras(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CommonWidgets().textWidget(
                  StringConstants.addFoodItemsExtras,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.primaryColor1),
                      fontFamily: FontConstants.montserratMedium)),
            ),
          ),
          CommonWidgets().textWidget(
              '${StringConstants.symbolDollar}${menuObjet.getTotalPrice().toStringAsFixed(2)}',
              StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)),
        ],
      ),
    );
  }

  Widget couponContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Divider(
              height: 1.0,
              color: getMaterialColor(AppColors.textColor1).withOpacity(0.2),
            ),
          ),
          Visibility(
              visible: false,
              child: commonTextFieldContainer(
                  hintText: StringConstants.applyCoupon,
                  imageName: AssetsConstants.couponIcon,
                  controller: applyCouponTextFieldController)),
          commonTextFieldContainer(hintText: StringConstants.addTip,
              imageName: AssetsConstants.dollarIcon,
              controller: addTipTextFieldController),
     /*     commonTextFieldContainer(hintText: StringConstants.addDiscount,
              imageName: AssetsConstants.dollarIcon,
              controller: addDiscountTextFieldController),*/
          orderBillDetailContainer(),

        ],
      ),
    );
  }

  Widget orderBillDetailContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          commonOrderBillComponents(text: StringConstants.foodCost,
              price: totalAmountOfSelectedItems),
          commonOrderBillComponents(
              text: StringConstants.salesTax, price: getSalesTax()),
          commonOrderBillComponents(
              text: StringConstants.subTotal, price: getSubTotal()),
          commonOrderBillComponents(text: StringConstants.tip, price: tip),
          Visibility(
            visible: false,
            child: commonOrderBillComponents(
                text: StringConstants.discount, price: discount),
          ),
        ],
      ),
    );
  }

  Widget commonOrderBillComponents(
      {required String text, required double price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textWidget(
              text, StyleConstants.customTextStyle(fontSize: 12,
              color: getMaterialColor(AppColors.textColor1),
              fontFamily: FontConstants.montserratMedium)),
          CommonWidgets().textWidget(
              StringConstants.symbolDollar + price.toStringAsFixed(2),
              StyleConstants.customTextStyle(fontSize: 12,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratRegular)),

        ],
      ),
    );
  }

  Widget commonTextFieldContainer(
      {required String hintText, required String imageName, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 3.34 * SizeConfig.heightSizeMultiplier,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: getMaterialColor(AppColors.whiteBorderColor))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CommonWidgets().image(image: imageName,
                    width: 1.75 * SizeConfig.heightSizeMultiplier,
                    height: 1.75 * SizeConfig.heightSizeMultiplier)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: StyleConstants.customTextStyle(fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratMedium),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //  contentPadding: const EdgeInsets.only(bottom: 20),
                    hintText: hintText,
                    hintStyle: StyleConstants.customTextStyle(fontSize: 12.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium),
                  ),
                  onEditingComplete: () {
                    onCompleteTextFieldEditing();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoriesNameButton(int index) {
    return InkWell(
      onTap: () {
        onTapCategoriesButton(index: index);
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: getMaterialColor(index == selectedCategoryIndex
                ? AppColors.primaryColor2
                : AppColors.whiteColor),
            border: Border.all(width: 1.0,
                color: getMaterialColor(AppColors.whiteBorderColor)),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: CommonWidgets().textWidget(
              itemCategoriesList[index].categoryName,
              index == selectedCategoryIndex ?
              StyleConstants.customTextStyle(fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)
                  : StyleConstants.customTextStyle(fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor4),
                  fontFamily: FontConstants.montserratMedium)

          ),
        ),
      ),
    );
  }

  Widget addCategoriesButton() {
    return InkWell(
      onTap: onTapAddCategoryButton,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: getMaterialColor(AppColors.whiteColor),
          shape: BoxShape.circle,
          border: Border.all(
              width: 1.0, color: getMaterialColor(AppColors.whiteBorderColor)),
        ),
        child: Center(
          child: plusSymbolText(),
        ),
      ),
    );
  }

  Widget clearButton() {
    return GestureDetector(
      onTap: () {
        if (selectedMenuItems.isNotEmpty) {
          onTapClearButton();
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(
            StringConstants.clear, StyleConstants.customTextStyle(
            fontSize: 9.0,
            color: getMaterialColor(AppColors.textColor5),
            fontFamily: FontConstants.montserratSemiBold)
        ),
      ),
    );
  }

  Widget chargeButton() {
    return GestureDetector(
      onTap: () {
        if (selectedMenuItems.isNotEmpty) {
          onTapChargeButton();
        }
      } ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: getMaterialColor(selectedMenuItems.isEmpty
                  ? AppColors.denotiveColor5
                  : AppColors.primaryColor2),
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
                  child: CommonWidgets().textWidget(
                      StringConstants.charge, StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(selectedMenuItems.isEmpty
                          ? AppColors.textColor4
                          : AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                  child: CommonWidgets().textWidget(
                      '${StringConstants.symbolDollar}${totalAmount
                          .toStringAsFixed(2)}', StyleConstants.customTextStyle(
                      fontSize: 23.3,
                      color: getMaterialColor(selectedMenuItems.isEmpty
                          ? AppColors.textColor4
                          : AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                      textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget saveAndNewOrderButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0, right: 9.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (selectedMenuItems.isNotEmpty) {
                onTapSaveButton();
              }
            } ,
            child: CommonWidgets().textWidget(
                StringConstants.saveOrder, StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(selectedMenuItems.isEmpty
                    ? AppColors.denotiveColor4
                    : AppColors.textColor6),
                fontFamily: FontConstants.montserratSemiBold)),
          ),
          InkWell(
            onTap: () {
              if (selectedMenuItems.isNotEmpty) {
                onTapNewOrderButton();
              }
            },
            child: CommonWidgets().textWidget(
                StringConstants.newOrder, StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(selectedMenuItems.isEmpty
                    ? AppColors.denotiveColor4
                    : AppColors.textColor7),
                fontFamily: FontConstants.montserratSemiBold)),
          )
        ],
      ),
    );
  }

  //FoodExtra popup
  showAddFoodExtrasPopUp(int index, bool selectedFromMenu) async {
    await showDialog(
        barrierDismissible: false,
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return FoodExtraPopup(item: selectedFromMenu ? itemList[index] : selectedMenuItems[index]);
        });
    setState(() {

    });
  }

  //Custom Menu popup
  showCustomMenuPopup() {
    showDialog(
        barrierDismissible: false,
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return const CustomMenuPopup();
        }).then((value) {
      onTapCategoriesButton(index: 1);
    });
  }

  //Other functions
  getUserName() async {
    userName = await FunctionalUtils.getUserName();
    setState(() {});
  }

  double getSalesTax() {
    salesTax = (widget.events.salesTax.toDouble()/100) * totalAmountOfSelectedItems;
    return salesTax;
  }

  double getSubTotal() {
    return totalAmountOfSelectedItems + getSalesTax();
  }

  updateCustomerName() {
    if (customerName == StringConstants.addCustomer &&
        selectedMenuItems.isNotEmpty) {
      customerName = StringConstants.guestCustomer;
    } else if (customerName == StringConstants.guestCustomer &&
        selectedMenuItems.isEmpty) {
      customerName = StringConstants.addCustomer;
    }
  }

  bool invalidCustomerName() {
    return (customerName == StringConstants.addCustomer ||
        customerName == StringConstants.guestCustomer);
  }

  calculateTotal() {
    if (selectedMenuItems.isNotEmpty) {
      totalAmount = totalAmountOfSelectedItems + tip + getSalesTax() - discount;
    } else {
      totalAmount = 0.0;
    }
  }

  clearCart() {
    setState(() {
      selectedMenuItems.clear();
      itemList.clear();
      tip = 0.0;
      discount = 0.0;
      addTipTextFieldController.clear();
      addDiscountTextFieldController.clear();
      customerName = StringConstants.addCustomer;
      orderID = '';
     getAllItems(widget.events.id);
    });
  }

  //Action Event
  onTapAddCategoryButton() {
  }

  onTapCategoriesButton({required int index}) {
    if (index != selectedCategoryIndex) {
      setState(() {
        selectedCategoryIndex = index;
        if (index == 0) {
          showCustomMenuPopup();
        } else if (index == 1) {
          itemList.clear();
          itemList.addAll(dbItemList);
        } else {
          itemList.clear();
          var list = dbItemList.where((element) => element.itemCategoryId == itemCategoriesList[index].id).toList();
          itemList.addAll(list);
        }
      });
    }
  }

  onTapClearButton() {
    DialogHelper.confirmationDialog(context, onConfirmTapYes, onConfirmTapNo);
  }
  onConfirmTapYes(){
  clearCart();
  onConfirmTapNo();
  }
  onConfirmTapNo(){
    Navigator.of(context).pop();
  }

  onTapChargeButton() {
    showPaymentScreen();
  }

  onTapSaveButton() {
    if (orderID.isEmpty) {
      callPlaceOrderAPI();
    } else {
      saveOrderIntoLocalDB(orderID);
    }
  }

  onTapNewOrderButton() {
    clearCart();
  }

  onTapIncrementCountButton(index) {
    setState(() {
      selectedMenuItems[index].selectedItemQuantity += 1;
    });
  }

  onTapDecrementCountButton(index) {
    setState(() {
      selectedMenuItems[index].selectedItemQuantity -= 1;
      if (selectedMenuItems[index].selectedItemQuantity == 0) {
        selectedMenuItems[index].isItemSelected = false;
        selectedMenuItems.removeAt(index);
      }
    });
  }

  onTapAddCustomer() {
    setState(() {
      isSearchCustomer = true;
    });
  }

  onTapGridItem(int index) {
    // if (index == 0) {
    //   print('add New Item');
    // } else {
    setState(() {
      itemList[index].selectedItemQuantity =
      itemList[index].isItemSelected ? 0 : 1;
      itemList[index].isItemSelected
          ? selectedMenuItems.remove(itemList[index])
          : selectedMenuItems.add(itemList[index]);
      itemList[index].isItemSelected = !itemList[index].isItemSelected;
      if (itemList[index].isItemSelected) {
        itemList[index].selectedExtras = [];
      }
    });
    // }
  }

  onTapFoodExtras(int index) {
    showAddFoodExtrasPopUp(index, true);
  }

  onTapAddFoodExtras(int index) {
    showAddFoodExtrasPopUp(index, false);
  }

  onTapCustomerName(CustomerDetails? customerObj) {
    setState(() {
      if (customerObj != null) {
        customerName = customerObj.getFullName();
      }
      customer = customerObj;
      isSearchCustomer = false;
    });
  }

  onCompleteTextFieldEditing() {
    String tipText = addTipTextFieldController.text;
    String discountText = addDiscountTextFieldController.text;
    setState(() {
      tip = double.parse(tipText.isEmpty ? '0.0' : tipText);
      discount = double.parse(discountText.isEmpty ? '0.0' : discountText);
    });

    FocusScope.of(context).unfocus();
  }

  onDrawerTap() {
    _scaffoldKey.currentState!.openEndDrawer();
    // Scaffold.of(context).openDrawer();
  }
  onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  onBackFromAllOrder({required SavedOrders savedOrder, required List<SavedOrdersItem> savedOrderItemList, required List<SavedOrdersExtraItems> savedOrderExtraItemList}) async {

    await clearCart();
    setState(() {
      isProduct = true;
    });
    Future.delayed(
        const Duration(milliseconds: 100),
            () {


    setState(() {
    tip = savedOrder.tip.toDouble();
    addTipTextFieldController.text = savedOrder.tip.toString();
    discount = savedOrder.discount.toDouble();
    addDiscountTextFieldController.text = savedOrder.discount.toString();
    customerName = savedOrder.customerName;
    orderID = savedOrder.orderId;
  //  salesTax = setSalesTax();
    if (savedOrder.customerName != StringConstants.guestCustomer) {
      customer = CustomerDetails();
      List<String> names = customerName.split(' ');
      if (names.length > 1) {
        customer!.firstName = names[0];
        customer!.lastName = names[1];
      }
      customer!.email = savedOrder.email;
      customer!.phoneNum = savedOrder.phoneNumber;
      customer!.numCountryCode = savedOrder.phoneCountryCode;
    }
    for (var itemSaveOrder in savedOrderItemList) {
      for (var item in itemList) {
        if (item.id == itemSaveOrder.itemId) {
          item.selectedItemQuantity = itemSaveOrder.quantity;
          item.isItemSelected = true;
          for (var extraSaveOrder in savedOrderExtraItemList) {
            for (var extraItem in item.foodExtraItemList) {
              if (extraItem.id == extraSaveOrder.extraFoodItemId && item.id == extraSaveOrder.itemId) {
                extraItem.selectedItemQuantity = extraSaveOrder.quantity;
                extraItem.isItemSelected = true;
                item.selectedExtras.add(extraItem);
              }
            }
          }
          selectedMenuItems.add(item);
          break;
        }
      }
    }

    });
            }
    );
  }

  //data required for next screen
  PlaceOrderRequestModel getOrderRequestModel() {
    PlaceOrderRequestModel orderRequestModel = PlaceOrderRequestModel();
     orderRequestModel.eventId = widget.events.id;
     orderRequestModel.cardId = "9db195092bc44d9db117f03a5a541025";
     orderRequestModel.campaignId = "";

     if (orderID.isNotEmpty) {
       orderRequestModel.id = orderID;
     }

     //addCustomer Details
     if (customer != null) {
       orderRequestModel.firstName = customer!.firstName;
       orderRequestModel.lastName = customer!.lastName;
       orderRequestModel.email = customer!.email;
       orderRequestModel.phoneNumCountryCode = customer!.numCountryCode;
       orderRequestModel.phoneNumber = customer!.phoneNum;
       orderRequestModel.addressLine1 = "";
       orderRequestModel.addressLine2 = "";
       orderRequestModel.country = "";
       orderRequestModel.state = "";
       orderRequestModel.city = "";
       orderRequestModel.zipCode = "";
       orderRequestModel.anonymous = false;
       orderRequestModel.donation = 0;
       orderRequestModel.gratuity = 0;
       orderRequestModel.addressLatitude = 0.0;
       orderRequestModel.addressLongitude = 0.0;
     } else {
       orderRequestModel.anonymous = true;
     }

     orderRequestModel.corporateDonationBeforeCcCharges = 0.0;

     orderRequestModel.allowPromoNotifications = false;
     orderRequestModel.orderDate = DateTime.now().millisecondsSinceEpoch;
     orderRequestModel.orderItemsList = getOrderItemList();

    return orderRequestModel;
  }

  List<OrderItemsList> getOrderItemList() {
    List<OrderItemsList> orderList = [];
    for(var item in selectedMenuItems) {
      OrderItemsList orderItem = OrderItemsList();
      orderItem.name = item.name;
      orderItem.itemId = item.id;
      orderItem.quantity = item.selectedItemQuantity;
      orderItem.unitPrice = item.price.toDouble();
      orderItem.totalAmount = item.getOnlyMenuItemTotalPrice();
      orderItem.itemCategoryId = item.itemCategoryId;
      orderItem.recipientName = "";
      orderItem.key = "";
      orderItem.values = "";
      orderItem.foodExtraItemMappingList = item.selectedExtras.isNotEmpty ? getExtraItemsList(item.selectedExtras) : [];

      orderList.add(orderItem);
    }

    return orderList;
  }

  List<FoodExtraItemMappingList> getExtraItemsList(List<FoodExtraItems> selectedExtras) {
    List<FoodExtraItemMappingList> extrasList = [];
    FoodExtraItemMappingList mappingObj = FoodExtraItemMappingList();
    List<OrderFoodExtraItemDetailDto> orderFoodExtraList = [];
    mappingObj.foodExtraCategoryId = selectedExtras[0].foodExtraItemCategoryId;
    for(var extraItem in selectedExtras) {
      OrderFoodExtraItemDetailDto orderExtraItem = OrderFoodExtraItemDetailDto();
      orderExtraItem.id = extraItem.id;
      orderExtraItem.quantity = extraItem.selectedItemQuantity;
      orderExtraItem.unitPrice = extraItem.sellingPrice.toDouble();
      orderExtraItem.totalAmount = extraItem.getTotalPrice();
      orderExtraItem.specialInstructions = "";

      orderFoodExtraList.add(orderExtraItem);
    }

    mappingObj.orderFoodExtraItemDetailDto = orderFoodExtraList;

    extrasList.add(mappingObj);


    return extrasList;
  }

  //Navigation
  showPaymentScreen() {
    PlaceOrderRequestModel requestModel = getOrderRequestModel();
    Map billDetails = {'tip': tip, "discount": discount, 'totalAmount': totalAmount, 'foodCost': totalAmountOfSelectedItems, 'salesTax': getSalesTax()};
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaymentScreen(events: widget.events, placeOrderRequestModel: requestModel, selectedMenuItems: selectedMenuItems, billDetails: billDetails,userName: userName,))
    ).then((value) => {
      if (value != null) {
         if (value["isOrderComplete"] == "True"){
           clearCart()
         } else if (value["orderID"] != "NA") {
           orderID = value["orderID"]
         }
      }
    });
  }

  //API Call

  callPlaceOrderAPI({bool isPreviousRequestFail = false}) async {
    PlaceOrderRequestModel requestModel = getOrderRequestModel();
    orderPresenter.placeOrder(requestModel);
    setState(() {
      isApiProcess = true;
    });
  }

  @override
  void showError(GeneralErrorResponse exception) {
    // TODO: implement showError
  }

  @override
  void showSuccess(response) {
    // TODO: implement showSuccess
  }

  @override
  void showErrorForPlaceOrder(GeneralErrorResponse exception) {
    // TODO: implement showErrorForPay
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);

    });
  }

  @override
  void showSuccessForPlaceOrder(response) {
    // TODO: implement showSuccessForPay
    placeOrderResponseModel = response;
    if (placeOrderResponseModel.id != null) {
      setState(() {
        isApiProcess = false;
        orderID = placeOrderResponseModel.id!;
        saveOrderIntoLocalDB(orderID);
      });
    }
  }


  saveOrderIntoLocalDB(String orderId)async{
    var result = await SavedOrdersDAO().getOrder(orderId);
    if(result != null){
      await SavedOrdersDAO().clearEventDataByOrderID(orderID);
      insertSavedOrderData(orderId);
    }else{
      insertSavedOrderData(orderId);
    }

  }
  insertSavedOrderData(String orderId)async{

    PlaceOrderRequestModel orderRequestModel = getOrderRequestModel();
    String customerName = orderRequestModel.firstName !=null ? "${orderRequestModel.firstName} " + orderRequestModel.lastName! : StringConstants.guestCustomer;

    // Insert Order into DB
    await SavedOrdersDAO().insert(SavedOrders(eventId:orderRequestModel.eventId!,cardId:orderRequestModel.cardId!,orderId:orderId,customerName:customerName,email:orderRequestModel.email.toString(),phoneNumber:orderRequestModel.phoneNumber.toString(),phoneCountryCode:orderRequestModel.phoneNumCountryCode.toString(),address1:orderRequestModel.addressLine1.toString(),address2:orderRequestModel.addressLine2.toString(),country:orderRequestModel.country.toString(),state:orderRequestModel.state.toString(),city:orderRequestModel.city.toString(),zipCode:orderRequestModel.zipCode.toString(),orderDate:orderRequestModel.orderDate!,tip:tip,discount:discount,foodCost:totalAmountOfSelectedItems,totalAmount:totalAmount,payment:"NA",orderStatus:"saved",deleted:false));
    // Insert Items into DB
    List<OrderItemsList> orderItem = getOrderItemList();
    for(var items in orderItem) {
      await SavedOrdersItemsDAO().insert(SavedOrdersItem(orderId:orderId,itemId:items.itemId.toString(),itemName:items.name.toString(),quantity:items.quantity!,unitPrice:items.unitPrice!,totalPrice:items.totalAmount!,itemCategoryId:items.itemCategoryId.toString(),deleted:false));
    }

    // Insert extra item into DB
    for(var items in selectedMenuItems) {
      if(items.selectedExtras.isNotEmpty){
        for(var extra in items.selectedExtras){
          await SavedOrdersExtraItemsDAO().insert(SavedOrdersExtraItems(orderId:orderId,itemId:items.id,extraFoodItemId:extra.id,extraFoodItemName:extra.itemName,extraFoodItemCategoryId:extra.foodExtraItemCategoryId,quantity:extra.selectedItemQuantity,unitPrice:extra.sellingPrice,totalPrice:extra.getTotalPrice(),deleted:false));
        }
      }
    }
    clearCart();
    CommonWidgets().showSuccessSnackBar(message: StringConstants.savedOrderSuccess, context: context);
  }

}
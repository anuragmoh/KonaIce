import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/food_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/item_categories_dao.dart';
import 'package:kona_ice_pos/database/daos/item_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/models/data_models/item_categories.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/all_orders/all_orders_screen.dart';
import 'package:kona_ice_pos/screens/event_menu/custom_menu_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/food_extra_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/menu_items.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/customer_model.dart';
import 'package:kona_ice_pos/screens/home/notification_drawer.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/search_customers_widget.dart';
import 'package:kona_ice_pos/screens/payment/payment_screen.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class EventMenuScreen extends StatefulWidget {
  final Events events;
  const EventMenuScreen({Key? key, required this.events}) : super(key: key);

  @override
  _EventMenuScreenState createState() => _EventMenuScreenState();
}

class _EventMenuScreenState extends State<EventMenuScreen> implements ResponseContractor {

  bool isApiProcess = false;

  List<Item> itemList = [];
  List<ItemCategories> itemCategoriesList = [];
  List<FoodExtraItems> foodExtraItemList = [];

  bool isProduct = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchCustomer = false;
  TextEditingController addTipTextFieldController = TextEditingController();
  TextEditingController addDiscountTextFieldController = TextEditingController();
  TextEditingController applyCouponTextFieldController = TextEditingController();

  List<String> categoriesList = [
    StringConstants.customMenu,
    'All Categories',
    'Kona Krafted',
    'Kona Koffee',
    'Fruit Flavours'
  ];
  int selectedCategoryIndex = -1;

  List<MenuItems> menuItems = getMenuItems();
  List<MenuItems> selectedMenuItems = [];
  String customerName = StringConstants.addCustomer;
  CustomerDetails? customer;
  double tip = 0.0;
  double salesTax = 0.0;
  double discount = 0.0;
  double totalAmount = 0.0;
  double get totalAmountOfSelectedItems {
    if (selectedMenuItems.isEmpty) {
      return 0.0;
    } else {
      double sum = 0;
      for (var element in selectedMenuItems) {
        sum += element.totalPrice;
      }
      return sum;
    }
  }

  onTapCallBack(bool callBackValue){
    setState(() {
      isProduct = callBackValue;
    });
  }
  onTapBottomListItem(int index){

  }


  // LocalDB call start from here.
  getAllItemCategories()async{
    var result = await ItemCategoriesDAO().getAllCategories();
    if(result !=null){
     setState(() {
       itemCategoriesList.addAll(result);
     });
    }else{
      setState(() {
        itemCategoriesList.clear();
      });
    }

  }
  getItemCategoriesByEventId(String eventId)async{
    // Event Id need to pass
    var result = await ItemCategoriesDAO().getCategoriesByEventId(eventId);
    if(result !=null){
      setState(() {
        itemCategoriesList.addAll(result);
      });
    }else{
      setState(() {
        itemCategoriesList.clear();
      });

    }
  }
  getAllItems(String eventId)async{
    // Event Id need to pass
   var result = await ItemDAO().getAllItemsByEventId(eventId);
   if(result !=null){
     setState(() {
       itemList.addAll(result);
     });
   }else{
     setState(() {
       itemList.clear();
     });
   }
  }
  getItemsByCategory(String categoryId)async{
    // Category Id need to pass
    var result = await ItemDAO().getAllItemsByCategories(categoryId);
    if(result !=null){
      setState(() {
        itemList.addAll(result);
      });
    }else{
      setState(() {
        itemList.clear();
      });
    }
  }
  getExtraFoodItem()async{
    var result = await FoodExtraItemsDAO().getFoodExtraByEventIdAndItemId("", "");
    if(result !=null){
      setState(() {
         foodExtraItemList.addAll(result);
      });
    }else{
      setState(() {
        foodExtraItemList.clear();
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getAllItemCategories();
  }

  @override
  Widget build(BuildContext context) {
    updateCustomerName();
    calculateTotal();

    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }


  Widget mainUi(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: getMaterialColor(AppColors.textColor3),
      endDrawer: const NotificationDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(userName: 'Justin', eventName: widget.events.name, eventAddress: widget.events.addressLine1, showCenterWidget: true, onTapCallBack: onTapCallBack,onDrawerTap: onDrawerTap,),
          Expanded(
            child: isProduct ? body() :  AllOrdersScreen(onBackTap: onTapCallBack),
          ),
          BottomBarWidget(onTapCallBack: onTapBottomListItem, accountImageVisibility: false,isFromDashboard: false,)
        ],
      ),
    );
  }

  Widget body() {
    return Padding(
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
         height: MediaQuery.of(context).size.height*0.78,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: getMaterialColor(AppColors.textColor1).withOpacity(0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2)
              )
            ]
        ),
        child: isSearchCustomer ? searchCustomerContainer() : rightCartViewContainer(),
      ),
    );
  }

  //Add to cart Container
  Widget rightCartViewContainer () {
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
          itemCount: categoriesList.length,
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
            childAspectRatio: 139/80
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index){
          return GestureDetector(
              onTap: () {
                onTapGridItem(index);
              },
              child: menuItem(index));
              //index == 0 ? addNewMenuItem() : menuItem(index));
        });
  }

  Widget menuItem(int index) {
    MenuItems menuObject = menuItems[index];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: menuObject.isItemSelected ?
          [getMaterialColor(AppColors.gradientColor1), getMaterialColor(AppColors.gradientColor2)]
              : [getMaterialColor(AppColors.whiteColor), getMaterialColor(AppColors.whiteColor)]
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
                      Column(
                        mainAxisAlignment: (menuObject.isItemHasExtras && menuObject.isItemSelected) ? MainAxisAlignment.start : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: CommonWidgets().textWidget(menuObject.itemName, StyleConstants.customTextStyle(
                              fontSize: 16.0, color: getMaterialColor(menuObject.isItemSelected ? AppColors.whiteColor : AppColors.textColor1), fontFamily: FontConstants.montserratSemiBold)),
                        ),
                        CommonWidgets().textWidget('\$${menuObject.price}', StyleConstants.customTextStyle(
                            fontSize: 12.0, color: getMaterialColor(menuObject.isItemSelected ? AppColors.whiteColor :AppColors.textColor2), fontFamily: FontConstants.montserratMedium))
                      ],
            ),
                      Visibility(
                        visible: menuObject.isItemSelected,
                        child: CommonWidgets().textWidget('${menuObject.selectedItemQuantity}', StyleConstants.customTextStyle(
                            fontSize: 16.0, color: getMaterialColor(AppColors.whiteColor), fontFamily: FontConstants.montserratRegular)),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: menuObject.isItemSelected && menuObject.isItemHasExtras,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: InkWell(
                    onTap: () {
                      onTapFoodExtras(index);
                    },
                    child: CommonWidgets().textWidget(StringConstants.addFoodItems, StyleConstants.customTextStyle(
                        fontSize: 12.0, color: getMaterialColor(AppColors.textColor3), fontFamily: FontConstants.montserratMedium)),
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
            child: CommonWidgets().textWidget(StringConstants.addNewMenuItem, StyleConstants.customTextStyle(
                fontSize: 12.0, color: getMaterialColor(AppColors.textColor2), fontFamily: FontConstants.montserratMedium),
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
            CommonWidgets().image(image: AssetsConstants.addCustomerIcon, width: 25.0, height: 25.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: CommonWidgets().textWidget(customerName, StyleConstants.customTextStyle(
                    fontSize: 16.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),
              ),
            ),
            Visibility(
              visible: invalidCustomerName(),
              child: CommonWidgets().textWidget(StringConstants.plusSymbol, StyleConstants.customTextStyle(
                  fontSize: 16.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),
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
        CommonWidgets().image(image: AssetsConstants.addToCartIcon, width: 50.0, height: 50.0),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CommonWidgets().textWidget(StringConstants.noItemsAdded, StyleConstants.customTextStyle(
              fontSize: 12.0, color: getMaterialColor(AppColors.textColor2), fontFamily: FontConstants.montserratSemiBold)),
        ),
      ],
    );
  }

  Widget selectedItemList() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 20.0),
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
              selectedItemDetailsComponent(index),
              CommonWidgets().quantityIncrementDecrementContainer(
                quantity: selectedMenuItems[index].selectedItemQuantity,
                onTapPlus: () {
                  onTapIncrementCountButton(index);
                },
                onTapMinus: () {
                  onTapDecrementCountButton(index);
                }
              ),
            ],
          ),
        );
      }
      ),
    );
  }

  Widget selectedItemDetailsComponent(index) {
    MenuItems menuObjet = selectedMenuItems[index];
     return GestureDetector(
       onTap: () {
         if (menuObjet.isItemHasExtras) {
           onTapAddFoodExtras(index);
         }
       },
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.only(bottom: 2.0),
             child: CommonWidgets().textWidget(menuObjet.itemName, StyleConstants.customTextStyle(
                 fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium)),
           ),
           Visibility(
             visible: (menuObjet.selectedExtras).isNotEmpty,
             child: Padding(
               padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
               child: CommonWidgets().textWidget("Pumpkin Pie Syrup \n Sugar Free Vanilla", StyleConstants.customTextStyle(
                   fontSize: 9.0, color: getMaterialColor(AppColors.textColor2), fontFamily: FontConstants.montserratMedium)),
             ),
           ),
           Visibility(
             visible: menuObjet.isItemHasExtras,
             child: Padding(
               padding: const EdgeInsets.only(bottom: 2.0),
               child: CommonWidgets().textWidget(StringConstants.addFoodItemsExtras, StyleConstants.customTextStyle(
                   fontSize: 9.0, color: getMaterialColor(AppColors.primaryColor1), fontFamily: FontConstants.montserratMedium)),
             ),
           ),
           CommonWidgets().textWidget('${StringConstants.symbolDollar}${menuObjet.totalPrice}', StyleConstants.customTextStyle(
               fontSize: 16.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),
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
              child: commonTextFieldContainer(hintText: StringConstants.applyCoupon, imageName: AssetsConstants.couponIcon, controller: applyCouponTextFieldController)),
          commonTextFieldContainer(hintText: StringConstants.addTip, imageName: AssetsConstants.dollarIcon, controller: addTipTextFieldController),
          commonTextFieldContainer(hintText: StringConstants.addDiscount, imageName: AssetsConstants.dollarIcon, controller: addDiscountTextFieldController),
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
          commonOrderBillComponents(text: StringConstants.foodCost, price: totalAmountOfSelectedItems),
          commonOrderBillComponents(text: StringConstants.salesTax, price: salesTax),
          commonOrderBillComponents(text: StringConstants.tip, price: tip),
          commonOrderBillComponents(text: StringConstants.discount, price: discount),
        ],
      ),
    );
  }

  Widget commonOrderBillComponents({required String text, required double price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textWidget(text, StyleConstants.customTextStyle(fontSize: 12,
              color: getMaterialColor(AppColors.textColor1),
              fontFamily: FontConstants.montserratMedium)),
          CommonWidgets().textWidget(StringConstants.symbolDollar + price.toString(), StyleConstants.customTextStyle(fontSize: 12,
              color: getMaterialColor(AppColors.textColor2),
              fontFamily: FontConstants.montserratRegular)),

        ],
      ),
    );
  }

  Widget commonTextFieldContainer({required String hintText, required String imageName, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 3.34 * SizeConfig.heightSizeMultiplier,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: getMaterialColor(AppColors.whiteBorderColor))
          ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: CommonWidgets().image(image: imageName, width: 1.75*SizeConfig.heightSizeMultiplier, height: 1.75*SizeConfig.heightSizeMultiplier)
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
          child: CommonWidgets().textWidget(categoriesList[index],
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
      onTap: onTapClearButton,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(StringConstants.clear, StyleConstants.customTextStyle(
            fontSize: 9.0, color: getMaterialColor(AppColors.textColor5), fontFamily: FontConstants.montserratSemiBold)
        ),
      ),
    );
  }

  Widget chargeButton() {
    return GestureDetector(
      onTap: onTapChargeButton,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: getMaterialColor(selectedMenuItems.isEmpty ? AppColors.denotiveColor5 : AppColors.primaryColor2),
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
                  child: CommonWidgets().textWidget(StringConstants.charge, StyleConstants.customTextStyle(
                      fontSize: 16.0, color: getMaterialColor(selectedMenuItems.isEmpty ? AppColors.textColor4 : AppColors.textColor1), fontFamily: FontConstants.montserratBold), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                  child: CommonWidgets().textWidget('${StringConstants.symbolDollar}$totalAmount', StyleConstants.customTextStyle(
                      fontSize: 23.3, color: getMaterialColor(selectedMenuItems.isEmpty ? AppColors.textColor4 : AppColors.textColor1), fontFamily: FontConstants.montserratBold), textAlign: TextAlign.center),
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
            onTap: onTapSaveButton,
            child: CommonWidgets().textWidget(StringConstants.saveOrder, StyleConstants.customTextStyle(
                fontSize: 12.0, color: getMaterialColor(selectedMenuItems.isEmpty ? AppColors.denotiveColor4 : AppColors.textColor6), fontFamily: FontConstants.montserratSemiBold)),
          ),
          InkWell(
            onTap: onTapNewOrderButton,
            child: CommonWidgets().textWidget(StringConstants.newOrder, StyleConstants.customTextStyle(
                fontSize: 12.0, color: getMaterialColor(selectedMenuItems.isEmpty ? AppColors.denotiveColor4 : AppColors.textColor7), fontFamily: FontConstants.montserratSemiBold)),
          )
        ],
      ),
    );
  }

  //FoodExtra popup
  showAddFoodExtrasPopUp(MenuItems item) async {
  await showDialog(
        barrierDismissible: false,
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return FoodExtraPopup(item: item);
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
        });
  }

  //Other functions
  updateCustomerName() {
    if (customerName == StringConstants.addCustomer && selectedMenuItems.isNotEmpty) {
      customerName = StringConstants.guestCustomer;
    } else if (customerName == StringConstants.guestCustomer && selectedMenuItems.isEmpty) {
      customerName = StringConstants.addCustomer;
    }
  }

  bool invalidCustomerName() {
    return (customerName == StringConstants.addCustomer || customerName == StringConstants.guestCustomer);
  }

  calculateTotal() {
    totalAmount = totalAmountOfSelectedItems + tip + salesTax - discount ;
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
        }
      });
    }
  }

  onTapClearButton() {
    setState(() {
      selectedMenuItems.clear();
      menuItems.clear();
      menuItems = getMenuItems();
    });
  }

  onTapChargeButton() {
    showPaymentScreen();
  }

  onTapSaveButton() {
    setState(() {
      selectedMenuItems.clear();
      menuItems.clear();
      menuItems = getMenuItems();
    });
  }

  onTapNewOrderButton() {
    setState(() {
      selectedMenuItems.clear();
      menuItems.clear();
      menuItems = getMenuItems();
    });
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
      menuItems[index].selectedItemQuantity = menuItems[index].isItemSelected ? 0 : 1;
      menuItems[index].isItemSelected ? selectedMenuItems.remove(menuItems[index]) : selectedMenuItems.add(menuItems[index]);
      menuItems[index].isItemSelected = !menuItems[index].isItemSelected;

    });
   // }
  }

  onTapFoodExtras(int index) {
   showAddFoodExtrasPopUp(menuItems[index]);
  }

  onTapAddFoodExtras(int index) {
    showAddFoodExtrasPopUp(menuItems[index]);
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
       String discountText =  addDiscountTextFieldController.text;
       setState(() {
         tip = double.parse(tipText.isEmpty ? '0.0' : tipText);
         discount = double.parse(discountText.isEmpty ? '0.0' : discountText);
       });

       FocusScope.of(context).unfocus();
  }

  //Navigation
  showPaymentScreen() {
   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen( events:widget.events)));
 }


  onDrawerTap() {
    _scaffoldKey.currentState!.openEndDrawer();
    // Scaffold.of(context).openDrawer();
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);

  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess = false;
    });

    // response is ItemCategories ? print("true") : print("false");
  }
}
  
  getMenuItems() {
    return [
      // MenuItems(itemName: StringConstants.addNewMenuItem, price: 0.0),
      MenuItems(itemName: 'Kiddie', price: 5.0),
      MenuItems(itemName: 'Klassic', price: 3.0, isItemHasExtras: true, extraContents: getFoodExtras()),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0),
      MenuItems(itemName: 'Kiddie', price: 5.0),
      MenuItems(itemName: 'Klassic', price: 3.0),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0, isItemHasExtras: true, extraContents: getFoodExtras()),
      MenuItems(itemName: 'Kiddie', price: 5.0),
      MenuItems(itemName: 'Klassic', price: 3.0),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0),
      MenuItems(itemName: 'Kiddie', price: 5.0),
      MenuItems(itemName: 'Klassic', price: 3.0),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0),
      MenuItems(itemName: 'Kiddie', price: 5.0, isItemHasExtras: true, extraContents: getFoodExtras()),
      MenuItems(itemName: 'Klassic', price: 3.0),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0),
      MenuItems(itemName: 'Kiddie', price: 5.0, isItemHasExtras: true, extraContents: getFoodExtras()),
      MenuItems(itemName: 'Klassic', price: 3.0),
      MenuItems(itemName: 'Kollectible', price: 5.0),
      MenuItems(itemName: 'Kona Special', price: 5.0),
      MenuItems(itemName: 'Fruityful', price: 5.0),
    ];
  }

List<FoodExtras> getFoodExtras() {
  return [
    FoodExtras(contentName: 'Pumpkin Pie Syrup', price: 5.0),
    FoodExtras(contentName: 'Sugar Free Vanilla', price: 4.0),
    FoodExtras(contentName: 'Hazelnut Syrup', price: 3.0),
    FoodExtras(contentName: 'Sugar Free Caramel', price: 2.0),
    FoodExtras(contentName: 'Lemonade Flavour Shots', price: 5.0),
    FoodExtras(contentName: 'Dairy Additives', price: 4.0),
    FoodExtras(contentName: 'Frappe Flavour Shots', price: 4.0),
    FoodExtras(contentName: 'Tea Flavour Shots', price: 5.0),
    FoodExtras(contentName: 'Coffee Flavour Shots', price: 5.0),
  ];
}

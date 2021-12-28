import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/all_orders/all_orders_screen.dart';
import 'package:kona_ice_pos/screens/event_menu/custom_menu_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/food_extra_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/menu_items.dart';
import 'package:kona_ice_pos/screens/home/party_events.dart';
import 'package:kona_ice_pos/screens/payment/payment_screen.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class EventMenuScreen extends StatefulWidget {
  final PartyEvents events;
  const EventMenuScreen({Key? key, required this.events}) : super(key: key);

  @override
  _EventMenuScreenState createState() => _EventMenuScreenState();
}

class _EventMenuScreenState extends State<EventMenuScreen> {

  bool isProduct = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getMaterialColor(AppColors.textColor3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(userName: 'Justin', eventName: widget.events.eventName, eventAddress: widget.events.location, showCenterWidget: true, onTapCallBack: onTapCallBack),
          Expanded(
            child: isProduct ? body() :  AllOrdersScreen(onBackTap: onTapCallBack),
          ),
          BottomBarWidget(onTapCallBack: onTapBottomListItem, accountImageVisibility: false,isFromDashboard: false,)
        ],
      ),
    );
  }

  Widget body() {
    customerName = selectedMenuItems.isEmpty ? StringConstants.addCustomer : 'Nicholas Gibson';
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
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.24,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
              child: clearButton()
          ),
          customerDetails(),
          Expanded(child: selectedMenuItems.isNotEmpty ? selectedItemList() : emptyCartView()
          ),
          chargeButton(),
          saveAndNewOrderButton()
        ],
      ),
    );
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
              visible: !selectedMenuItems.isNotEmpty,
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
                  child: CommonWidgets().textWidget('${StringConstants.symbolDollar}$totalAmountOfSelectedItems', StyleConstants.customTextStyle(
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
   var result = await showDialog(
        barrierDismissible: false,
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return FoodExtraPopup(item: item);
        });
   setState(() {

   });
   print('$result');
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

  //Action Event
  onTapAddCategoryButton() {
    print('tapped');
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

  }

  onTapGridItem(int index) {
    // if (index == 0) {
    //   print('add New Item');
    // } else {
    if (!menuItems[index].isItemSelected) {
    setState(() {
    menuItems[index].isItemSelected = true;
    menuItems[index].selectedItemQuantity = 1;
    selectedMenuItems.add(menuItems[index]);
    });
    }
   // }
  }

  onTapFoodExtras(int index) {
   showAddFoodExtrasPopUp(menuItems[index]);
  }

  onTapAddFoodExtras(int index) {
    showAddFoodExtrasPopUp(menuItems[index]);
  }

  //Navigation
  showPaymentScreen() {
   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen( events:widget.events)));
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

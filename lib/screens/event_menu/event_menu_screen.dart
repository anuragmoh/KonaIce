import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/event_menu/menu_items.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class EventMenuScreen extends StatefulWidget {
  const EventMenuScreen({Key? key}) : super(key: key);

  @override
  _EventMenuScreenState createState() => _EventMenuScreenState();
}

class _EventMenuScreenState extends State<EventMenuScreen> {

  List<String> categoriesList = [StringConstants.customMenu, 'All Categories', 'Kona Krafted', 'Kona Koffee', 'Fruit Flavours'];
  int selectedCategoryIndex = 0;

  //List<MenuItems> menuItems =

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3),
          child: body()
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
            child: Container(
                child: Row(
                  children: [
                    Flexible(child: categoriesListContainer()),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: addCategoriesButton(),
                    )
                  ],
                )),
          ),
          Expanded(child: Container(
          color: Colors.red,
          ))
        ],
    );
  }

  Widget rightContainer() {
    return  Container(
      width: MediaQuery.of(context).size.width * 0.24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow> [
          BoxShadow(
            color: getMaterialColor(AppColors.textColor1).withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0,2)
          )
        ]
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

  // Widget menuGridContainer() {
  //   return GridView.builder(
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 5,
  //           crossAxisSpacing: 8.0,
  //           mainAxisSpacing: 8.0,
  //           childAspectRatio: 139/80
  //       ),
  //       itemCount: items.length,
  //       itemBuilder: (context, index){
  //         return GestureDetector(
  //             onTap: () {
  //               onTapGridItem(index);
  //             },
  //             child: menuItem());
  //       });
  // }

  Widget categoriesNameButton(int index) {
    return InkWell(
      onTap: () {
        onTapCategoriesButton(index: index);
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: getMaterialColor(index == selectedCategoryIndex ? AppColors.primaryColor2 : AppColors.whiteColor),
          border: Border.all(width: 1.0, color: getMaterialColor(AppColors.whiteBorderColor)),
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: CommonWidgets().textWidget(categoriesList[index],
              index == selectedCategoryIndex ?
              StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)
                  : StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium)

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
          border: Border.all(width: 1.0, color: getMaterialColor(AppColors.whiteBorderColor)),
        ),
        child: Center(
          child: CommonWidgets().textWidget(StringConstants.plusSymbol, StyleConstants.customTextStyle(
            fontSize: 16.0, color: getMaterialColor(AppColors.primaryColor1),
            fontFamily: FontConstants.montserratBold)),
        ),
      ),
    );
  }



  //Action Event
   onTapAddCategoryButton() {
    print('tapped');
  }

  onTapCategoriesButton({required int index}) {
    if (index != selectedCategoryIndex) {
    setState(() {
    selectedCategoryIndex = index;
    });
    }
  }
}
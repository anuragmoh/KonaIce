import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

import 'menu_items.dart';
//ignore: must_be_immutable
class FoodExtraPopup extends StatefulWidget {
  Item item;
   FoodExtraPopup({required this.item, Key? key}) : super(key: key);

  @override
  _FoodExtraPopupState createState() => _FoodExtraPopupState();
}

class _FoodExtraPopupState extends State<FoodExtraPopup> {

   
  @override
  Widget build(BuildContext context) {
    return showFoodExtrasPopUp(widget.item);
  }

  showFoodExtrasPopUp(Item item) {
    return Dialog(
      backgroundColor: getMaterialColor(AppColors.whiteColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: SingleChildScrollView(child: foodExtraPopUpComponent(item)),
    );
  }

  Widget foodExtraPopUpComponent(Item item) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.49,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().popUpTopView(title: '${StringConstants.customize} \'${item.name}\'',
            onTapCloseButton: onTapCloseButton, ),
          popUpBodyContainer(item),
          addFoodExtraPopUpButton(item)
        ],
      ),
    );
  }

  Widget popUpBodyContainer(Item item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 21, 10),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: FlexColumnWidth(0.2), 1: FlexColumnWidth(1.0), 2: FlexColumnWidth(0.4), 3: FlexColumnWidth(0.4)},
        children: (item.foodExtraItemList).map((foodExtraObject) => popUpTableContent(foodExtraObject)).toList(),
      ),
    );
  }

  TableRow popUpTableContent(FoodExtraItems foodExtraObject) {
    int index = (widget.item.foodExtraItemList).indexOf(foodExtraObject);
    return TableRow(
        children: [
          SizedBox(
            height: 40,
            child: Checkbox(
                side: BorderSide(color: getMaterialColor(AppColors.textColor2)),
                activeColor: getMaterialColor(AppColors.primaryColor1),
                value: widget.item.selectedExtras.contains(foodExtraObject),
                onChanged: (isSelected) {
                  onTapCheckBox((isSelected ?? false),index,foodExtraObject);
                }),
          ),
          CommonWidgets().textWidget(foodExtraObject.itemName, StyleConstants.customTextStyle(
              fontSize: 12, color: getMaterialColor(AppColors.textColor4), fontFamily: FontConstants.montserratMedium),),
          Center(
            child: CommonWidgets().quantityIncrementDecrementContainer(quantity: foodExtraObject.selectedItemQuantity,
                onTapMinus: () {
                  onTapDecrementForFoodExtra(index);
                },
                onTapPlus: () {
                  onTapIncrementForFoodExtra(index);
                }),
          ),
          Center(
            child: CommonWidgets().textWidget('${StringConstants.symbolDollar}${foodExtraObject.getTotalPrice().toStringAsFixed(2)}',
                StyleConstants.customTextStyle(fontSize: 12,
                    color: getMaterialColor(foodExtraObject.selectedItemQuantity > 0 ? AppColors.textColor4 : AppColors.textColor2),
                    fontFamily: FontConstants.montserratBold)),
          )
        ]
    );
  }

  Widget addFoodExtraPopUpButton(Item item) {
    return GestureDetector(
      onTap: onTapAddExtrasButton,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 21, 15),
          child: Container(
            height: 30.0,
            width: 90.0,
            decoration: BoxDecoration(
                color: getMaterialColor(item.selectedExtras.isEmpty ? AppColors.denotiveColor5 : AppColors.primaryColor2),
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Center(
              child: CommonWidgets().textWidget(StringConstants.add, StyleConstants.customTextStyle(
                  fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold), textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  //Action Event

  onTapIncrementForFoodExtra(index) {
   setState(() {
    if (widget.item.foodExtraItemList[index].isItemSelected) {
       widget.item.foodExtraItemList[index].selectedItemQuantity += 1;
     }
   });
  }

  onTapDecrementForFoodExtra(index) {
    setState(() {
      if (widget.item.foodExtraItemList[index].selectedItemQuantity != 0 &&
          (widget.item.foodExtraItemList[index].isItemSelected)) {
      widget.item.foodExtraItemList[index].selectedItemQuantity -= 1;
      if (widget.item.foodExtraItemList[index].selectedItemQuantity == 0) {
        widget.item.foodExtraItemList[index].isItemSelected = false;
        widget.item.selectedExtras.remove(widget.item.foodExtraItemList[index]);
      }
      }
    });
  }

  onTapCheckBox(bool isSelected, int index, FoodExtraItems foodExtraObject) {
    setState(() {
      widget.item.foodExtraItemList[index].isItemSelected = isSelected;
      isSelected ? widget.item.selectedExtras.add(foodExtraObject) :
      widget.item.selectedExtras.remove(foodExtraObject);

       if (isSelected) {
        if (widget.item.foodExtraItemList[index].selectedItemQuantity == 0) {
        widget.item.foodExtraItemList[index].selectedItemQuantity = 1;
        }
       } else {
         widget.item.foodExtraItemList[index].selectedItemQuantity = 0;
       }
    });
  }

  onTapCloseButton() {
    Navigator.of(context).pop('text to reach back');
  }

  onTapAddExtrasButton() {
    Navigator.of(context).pop(widget.item);
  }

}

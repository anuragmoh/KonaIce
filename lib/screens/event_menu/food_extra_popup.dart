import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
//ignore: must_be_immutable
class FoodExtraPopup extends StatefulWidget {
  Item item;

  FoodExtraPopup({required this.item, Key? key}) : super(key: key);

  @override
  _FoodExtraPopupState createState() => _FoodExtraPopupState();
}

class _FoodExtraPopupState extends State<FoodExtraPopup> {
  List<FoodExtraItems> _foodExtraItemList = [];
  List<FoodExtraItems> _selectedExtras = [];

  @override
  void initState() {
    super.initState();
    _foodExtraItemList.clear();
    for (var extra in widget.item.foodExtraItemList) {
      FoodExtraItems extraCopy = extra.getCopy();
      extraCopy.isItemSelected = extra.isItemSelected;
      extraCopy.selectedItemQuantity = extra.selectedItemQuantity;
      if (extraCopy.isItemSelected) {
        _selectedExtras.add(extraCopy);
      }
      _foodExtraItemList.add(extraCopy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showFoodExtrasPopUp(widget.item);
  }

  _showFoodExtrasPopUp(Item item) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: SingleChildScrollView(child: _foodExtraPopUpComponent(item)),
    );
  }

  Widget _foodExtraPopUpComponent(Item item) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.49,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().popUpTopView(
            title: '${StringConstants.customize} \'${item.name}\'',
            onTapCloseButton: _onTapCloseButton,
          ),
          Container(color: Colors.white, child: _popUpBodyContainer()),
          Container(color: Colors.white, child: _addFoodExtraPopUpButton(item)),
        ],
      ),
    );
  }

  Widget _popUpBodyContainer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 21, 10),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(0.2),
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(0.4),
          3: FlexColumnWidth(0.4)
        },
        children: (_foodExtraItemList)
            .map((foodExtraObject) => _popUpTableContent(foodExtraObject))
            .toList(),
      ),
    );
  }

  TableRow _popUpTableContent(FoodExtraItems foodExtraObject) {
    int index = (_foodExtraItemList).indexOf(foodExtraObject);
    return TableRow(children: [
      SizedBox(
        height: 40,
        child: Checkbox(
            side: BorderSide(color: AppColors.textColor2),
            activeColor: AppColors.primaryColor1,
            // value: widget.item.selectedExtras.contains(foodExtraObject),
            value: _foodExtraItemList[index].isItemSelected,
            onChanged: (isSelected) {
              _onTapCheckBox((isSelected ?? false), index, foodExtraObject);
            }),
      ),
      CommonWidgets().textWidget(
        foodExtraObject.itemName,
        StyleConstants.customTextStyle12MonsterMedium(
            color: AppColors.textColor4),
      ),
      Center(
        child: CommonWidgets().quantityIncrementDecrementContainer(
            quantity: foodExtraObject.selectedItemQuantity,
            onTapMinus: () {
              _onTapDecrementForFoodExtra(index);
            },
            onTapPlus: () {
              if (!_foodExtraItemList[index].isItemSelected) {
                _onTapCheckBox((true), index, foodExtraObject);
              } else {
                _onTapIncrementForFoodExtra(index);
              }
            }),
      ),
      Center(
        child: CommonWidgets().textWidget(
            '${StringConstants.symbolDollar}${foodExtraObject.getTotalPrice().toStringAsFixed(2)}',
            StyleConstants.customTextStyle12MontserratBold(
                color: foodExtraObject.selectedItemQuantity > 0
                    ? AppColors.textColor4
                    : AppColors.textColor2)),
      )
    ]);
  }

  Widget _addFoodExtraPopUpButton(Item item) {
    return GestureDetector(
      onTap: () {
        _onTapAddExtrasButton(item);
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 21, 15),
          child: Container(
            height: 30.0,
            width: 90.0,
            decoration: BoxDecoration(
                color:
                    (item.selectedExtras.isEmpty && _selectedExtras.isEmpty)
                        ? AppColors.denotiveColor5
                        : AppColors.primaryColor2,
                borderRadius: BorderRadius.circular(15.0)),
            child: Center(
              child: CommonWidgets().textWidget(
                  item.selectedExtras.isEmpty
                      ? StringConstants.add
                      : StringConstants.update,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  //Action Event

  _onTapIncrementForFoodExtra(index) {
    setState(() {
      if (_foodExtraItemList[index].isItemSelected) {
        _foodExtraItemList[index].selectedItemQuantity += 1;
      }
    });
  }

  _onTapDecrementForFoodExtra(index) {
    setState(() {
      if (_foodExtraItemList[index].selectedItemQuantity != 0 &&
          (_foodExtraItemList[index].isItemSelected)) {
        _foodExtraItemList[index].selectedItemQuantity -= 1;
        if (_foodExtraItemList[index].selectedItemQuantity == 0) {
          _foodExtraItemList[index].isItemSelected = false;
          _selectedExtras.remove(_foodExtraItemList[index]);
        }
      }
    });
  }

  _onTapCheckBox(bool isSelected, int index, FoodExtraItems foodExtraObject) {
    setState(() {
      _foodExtraItemList[index].isItemSelected = isSelected;
      isSelected
          ? _selectedExtras.add(foodExtraObject)
          : _selectedExtras.remove(foodExtraObject);

      if (isSelected) {
        if (_foodExtraItemList[index].selectedItemQuantity == 0) {
          _foodExtraItemList[index].selectedItemQuantity = 1;
        }
      } else {
        _foodExtraItemList[index].selectedItemQuantity = 0;
      }
    });
  }

  _onTapCloseButton() {
    Navigator.of(context).pop('text to reach back');
  }

  _onTapAddExtrasButton(Item item) {
    if (!(item.selectedExtras.isEmpty && _selectedExtras.isEmpty)) {
      widget.item.selectedExtras.clear();
      widget.item.foodExtraItemList.clear();
      widget.item.foodExtraItemList.addAll(_foodExtraItemList);
      widget.item.selectedExtras.addAll(_selectedExtras);
      Navigator.of(context).pop(widget.item);
    }
  }
}

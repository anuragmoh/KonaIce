import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
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
import 'package:kona_ice_pos/models/network_model/search_customer/customer_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/general_success_model.dart';
import 'package:kona_ice_pos/network/repository/event/event_presenter.dart';
import 'package:kona_ice_pos/network/repository/orders/order_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/all_orders/all_orders_screen.dart';
import 'package:kona_ice_pos/screens/event_menu/custom_menu_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/food_extra_popup.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/search_customers_widget.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/payment/payment_screen.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dialog/dialog_helper.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_order_details_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';

import '../../models/network_model/order_model/order_request_model.dart';
import '../../models/network_model/order_model/order_response_model.dart';

class EventMenuScreen extends StatefulWidget {
  final Events events;

  const EventMenuScreen({Key? key, required this.events}) : super(key: key);

  @override
  _EventMenuScreenState createState() => _EventMenuScreenState();
}

class _EventMenuScreenState extends State<EventMenuScreen>
    implements OrderResponseContractor, P2PContractor {
  late OrderPresenter _orderPresenter;
  late EventPresenter _eventPresenter;
  PlaceOrderResponseModel _placeOrderResponseModel = PlaceOrderResponseModel();

  _EventMenuScreenState() {
    _orderPresenter = OrderPresenter(this);
    _eventPresenter = EventPresenter(this);
    P2PConnectionManager.shared.getP2PContractor(this);
  }

  bool _isApiProcess = false;

  List<ItemCategories> _itemCategoriesList = [];
  List<FoodExtraItems> _foodExtraItemList = [];

  bool _isProduct = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearchCustomer = false;
  TextEditingController _addTipTextFieldController = TextEditingController();
  TextEditingController _addDiscountTextFieldController =
      TextEditingController();
  TextEditingController _applyCouponTextFieldController =
      TextEditingController();

  int _selectedCategoryIndex = 1;
  int _currentIndex = 0;
  bool _isPaymentScreen = false;

  List<Item> _dbItemList = [];
  List<Item> _itemList = [];
  List<Item> _selectedMenuItems = [];
  String _customerName = StringConstants.addCustomer;
  CustomerDetails? _customer;
  double _tip = 0.0;
  double _salesTax = 0.0;
  double _discount = 0.0;
  double totalAmount = 0.0;
  String _orderID = '';
  String _orderCode = '';

  double get totalAmountOfSelectedItems {
    if (_selectedMenuItems.isEmpty) {
      return 0.0;
    } else {
      double sum = 0;
      for (var element in _selectedMenuItems) {
        sum += element.getTotalPrice();
      }
      return sum;
    }
  }

  String _userName = StringExtension.empty();

  _onTapCallBack(bool callBackValue) {
    setState(() {
      _isProduct = callBackValue;
    });
  }

  _onTapBottomListItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // LocalDB call start from here.
  _getItemCategoriesByEventId(String eventId) async {
    // Event Id need to pass
    var result = await ItemCategoriesDAO().getCategoriesByEventId(eventId);
    if (result != null) {
      setState(() {
        _itemCategoriesList.add(ItemCategories.getCustomMenuCategory(
            eventId: eventId, name: StringConstants.customMenu));
        _itemCategoriesList.add(ItemCategories.getCustomMenuCategory(
            eventId: eventId, name: StringConstants.allCategories));
        _itemCategoriesList.addAll(result);
      });
    } else {
      setState(() {
        _itemCategoriesList.clear();
      });
    }
  }

  _getAllItems(String eventId) async {
    // Event Id need to pass
    setState(() {
      _isPaymentScreen = false;
    });
    var result = await ItemDAO().getAllItemsByEventId(eventId);
    if (result != null) {
      setState(() {
        _itemList.clear();
        _dbItemList.clear();
        _itemList.addAll(result);
        _dbItemList.addAll(_itemList);
        debugPrint("=======$_itemList");
      });
    } else {
      setState(() {
        _itemList.clear();
      });
    }
  }

  _getItemsByCategory(String categoryId) async {
    // Category Id need to pass
    var result = await ItemDAO().getAllItemsByCategories(categoryId);
    if (result != null) {
      setState(() {
        _itemList.addAll(result);
      });
    } else {
      setState(() {
        _itemList.clear();
      });
    }
  }

  _getExtraFoodItem() async {
    var result =
        await FoodExtraItemsDAO().getFoodExtraByEventIdAndItemId("", "");
    if (result != null) {
      setState(() {
        _foodExtraItemList.addAll(result);
      });
    } else {
      setState(() {
        _foodExtraItemList.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getItemCategoriesByEventId(widget.events.id);
    _getAllItems(widget.events.id);
    getUserName();
    // setSalesTax();
  }

  @override
  void dispose() {
    super.dispose();
    _addTipTextFieldController.dispose();
    _addDiscountTextFieldController.dispose();
    _applyCouponTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_isPaymentScreen.toString());
    if (!_isPaymentScreen) {
      _updateCustomerName();
      _calculateTotal();
      _updateOrderDataToCustomer();
    }

    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: AppColors.textColor3,
        //  endDrawer: const NotificationDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopBar(
                userName: _userName,
                eventName: widget.events.getEventName(),
                eventAddress: widget.events.getEventAddress(),
                showCenterWidget: true,
                onTapCallBack: _onTapCallBack,
                //onDrawerTap: onDrawerTap,
                onProfileTap: _onProfileChange,
                isProduct: _isProduct),
            Expanded(
              child: _isProduct
                  ? _body()
                  : AllOrdersScreen(
                      onBackTap: (saveOrders, orderItemList, extraItemList) {
                        _onBackFromAllOrder(
                            savedOrder: saveOrders,
                            savedOrderItemList: orderItemList,
                            savedOrderExtraItemList: extraItemList);
                      },
                      events: widget.events),
            ),
            Visibility(
              visible: _selectedMenuItems.isEmpty ? true : false,
              child: BottomBarWidget(
                onTapCallBack: _onTapBottomListItem,
                accountImageVisibility: false,
                isFromDashboard: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return _itemList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(child: _leftContainer()),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _rightContainer(),
                ),
              ],
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: CommonWidgets().textWidget(
                StringConstants.noMenuItemsAvailable,
                StyleConstants.customTextStyle20MontserratSemiBold(
                    color: AppColors.textColor1)));
  }

  Widget _leftContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Row(
            children: [
              Flexible(child: _categoriesListContainer()),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _addCategoriesButton(),
                ),
              )
            ],
          ),
        ),
        Expanded(child: _menuGridContainer())
      ],
    );
  }

  Widget _rightContainer() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppColors.textColor1.withOpacity(0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2))
            ]),
        child: _isSearchCustomer
            ? _searchCustomerContainer()
            : _rightCartViewContainer(),
      ),
    );
  }

  //Add to cart Container
  Widget _rightCartViewContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(alignment: Alignment.topRight, child: _clearButton()),
        _customerDetails(),
        Expanded(
            child: _selectedMenuItems.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _selectedItemList()),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        fillOverscroll: true,
                        child: _couponContainer(),
                      )
                    ],
                  )
                : _emptyCartView()),
        _chargeButton(),
        _saveAndNewOrderButton()
      ],
    );
  }

  Widget _searchCustomerContainer() {
    return SearchCustomers(
      onTapCustomer: _onTapCustomerName,
    );
  }

  Widget _categoriesListContainer() {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
          itemCount: _itemCategoriesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _categoriesNameButton(index));
          }),
    );
  }

  Widget _menuGridContainer() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 139 / 80),
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                _onTapGridItem(index);
              },
              child: _menuItem(index));
        });
  }

  Widget _menuItem(int index) {
    Item menuObject = _itemList[index];
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: menuObject.isItemSelected
                  ? [AppColors.gradientColor1, AppColors.gradientColor2]
                  : [AppColors.whiteColor, AppColors.whiteColor]),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _buildMainPadding(menuObject, index));
  }

  Padding _buildMainPadding(Item menuObject, int index) {
    return Padding(
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
                    child: _buildColumn(menuObject),
                  ),
                  _buildFlexibleWidget(menuObject),
                ],
              ),
            ),
          ),
          _builVisibilityWidget(menuObject, index),
        ],
      ),
    );
  }

  Column _buildColumn(Item menuObject) {
    return Column(
      mainAxisAlignment:
          (menuObject.isItemHasExtras() && menuObject.isItemSelected)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
          child: Text(
            menuObject.name,
            style: StyleConstants.customTextStyle16MontserratSemiBold(
                color: menuObject.isItemSelected
                    ? AppColors.whiteColor
                    : AppColors.textColor1),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        CommonWidgets().textWidget(
            '\$${menuObject.price}',
            StyleConstants.customTextStyle12MonsterMedium(
                color: menuObject.isItemSelected
                    ? AppColors.whiteColor
                    : AppColors.textColor2))
      ],
    );
  }

  Flexible _buildFlexibleWidget(Item menuObject) {
    return Flexible(
      flex: menuObject.isItemSelected ? 1 : 0,
      child: Visibility(
        visible: menuObject.isItemSelected,
        child: CommonWidgets().textWidget(
            '${menuObject.selectedItemQuantity}',
            StyleConstants.customTextStyle16MonsterRegular(
                color: AppColors.whiteColor)),
      ),
    );
  }

  Visibility _builVisibilityWidget(Item menuObject, int index) {
    return Visibility(
      visible: menuObject.isItemSelected && menuObject.isItemHasExtras(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: InkWell(
          onTap: () {
            _onTapFoodExtras(index);
          },
          child: CommonWidgets().textWidget(
              StringConstants.addFoodItems,
              StyleConstants.customTextStyle12MonsterMedium(
                  color: AppColors.textColor3)),
        ),
      ),
    );
  }

  Widget _addNewMenuItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: _plusSymbolText(),
          ),
          SizedBox(
            width: 70.0,
            child: CommonWidgets().textWidget(
                StringConstants.addNewMenuItem,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratMedium),
                textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _plusSymbolText() {
    return CommonWidgets().textWidget(
        StringConstants.plusSymbol,
        StyleConstants.customTextStyle16MontserratBold(
            color: AppColors.primaryColor1));
  }

  Widget _customerDetails() {
    return GestureDetector(
      onTap: _onTapAddCustomer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
        child: Row(
          children: [
            CommonWidgets().image(
                image: AssetsConstants.addCustomerIcon,
                width: 25.0,
                height: 25.0),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: CommonWidgets().textWidget(
                    _customerName,
                    StyleConstants.customTextStyle16MontserratBold(
                        color: AppColors.textColor1)),
              ),
            ),
            Visibility(
              visible: _invalidCustomerName(),
              child: CommonWidgets().textWidget(
                  StringConstants.plusSymbol,
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.textColor1)),
            )
          ],
        ),
      ),
    );
  }

  Widget _emptyCartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonWidgets().image(
            image: AssetsConstants.addToCartIcon, width: 50.0, height: 50.0),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CommonWidgets().textWidget(
              StringConstants.noItemsAdded,
              StyleConstants.customTextStyle12MontserratSemiBold(
                  color: AppColors.textColor2)),
        ),
      ],
    );
  }

  Widget _selectedItemList() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _selectedMenuItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5, child: _selectedItemDetailsComponent(index)),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CommonWidgets()
                          .quantityIncrementDecrementContainer(
                              quantity: _selectedMenuItems[index]
                                  .selectedItemQuantity,
                              onTapPlus: () {
                                _onTapIncrementCountButton(index);
                              },
                              onTapMinus: () {
                                _onTapDecrementCountButton(index);
                              }),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _selectedItemDetailsComponent(index) {
    Item menuObjet = _selectedMenuItems[index];
    return GestureDetector(
      onTap: () {
        if (menuObjet.isItemHasExtras()) {
          _onTapAddFoodExtras(index);
        }
      },
      child: _buildColumn2(menuObjet),
    );
  }

  Column _buildColumn2(Item menuObjet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: CommonWidgets().textWidget(
              menuObjet.name,
              StyleConstants.customTextStyle12MonsterMedium(
                  color: AppColors.textColor4)),
        ),
        _buildRow(menuObjet),
        _buildAddExtraFoodItemsVisibility(menuObjet),
        CommonWidgets().textWidget(
            '${StringConstants.symbolDollar}${menuObjet.getTotalPrice().toStringAsFixed(2)}',
            StyleConstants.customTextStyle16MontserratBold(
                color: AppColors.textColor1)),
      ],
    );
  }

  Visibility _buildAddExtraFoodItemsVisibility(Item menuObjet) {
    return Visibility(
      visible: menuObjet.isItemHasExtras(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: CommonWidgets().textWidget(
            StringConstants.addFoodItemsExtras,
            StyleConstants.customTextStyle09MonsterMedium(
                color: AppColors.primaryColor1)),
      ),
    );
  }

  Row _buildRow(Item menuObjet) {
    return Row(
      children: [
        Visibility(
          visible: (menuObjet.selectedExtras).isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
            child: CommonWidgets().textWidget(
                menuObjet.getExtraItemsName(),
                StyleConstants.customTextStyle09MonsterMedium(
                    color: AppColors.textColor2)),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  Widget _couponContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Divider(
              height: 1.0,
              color: AppColors.textColor1.withOpacity(0.2),
            ),
          ),
          Visibility(
              visible: false,
              child: _commonTextFieldContainer(
                  hintText: StringConstants.applyCoupon,
                  imageName: AssetsConstants.couponIcon,
                  controller: _applyCouponTextFieldController)),
          _commonTextFieldContainer(
              hintText: StringConstants.addTip,
              imageName: AssetsConstants.dollarIcon,
              controller: _addTipTextFieldController),
          _orderBillDetailContainer(),
        ],
      ),
    );
  }

  Widget _orderBillDetailContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _commonOrderBillComponents(
              text: StringConstants.foodCost,
              price: totalAmountOfSelectedItems),
          _commonOrderBillComponents(
              text: StringConstants.salesTax, price: _getSalesTax()),
          _commonOrderBillComponents(
              text: StringConstants.subTotal, price: _getSubTotal()),
          _commonOrderBillComponents(text: StringConstants.tip, price: _tip),
          Visibility(
            visible: false,
            child: _commonOrderBillComponents(
                text: StringConstants.discount, price: _discount),
          ),
        ],
      ),
    );
  }

  Widget _commonOrderBillComponents(
      {required String text, required double price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textWidget(
              text,
              StyleConstants.customTextStyle12MonsterMedium(
                  color: AppColors.textColor1)),
          CommonWidgets().textWidget(
              StringConstants.symbolDollar + price.toStringAsFixed(2),
              StyleConstants.customTextStyle12MonsterRegular(
                  color: AppColors.textColor2)),
        ],
      ),
    );
  }

  Widget _commonTextFieldContainer(
      {required String hintText,
      required String imageName,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 3.34 * SizeConfig.heightSizeMultiplier,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.whiteBorderColor)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CommonWidgets().image(
                    image: imageName,
                    width: 1.75 * SizeConfig.heightSizeMultiplier,
                    height: 1.75 * SizeConfig.heightSizeMultiplier)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TextField(
                  controller: controller,
                  maxLength: TextFieldLengthConstant.addTip,
                  keyboardType: TextInputType.number,
                  style: StyleConstants.customTextStyle12MonsterMedium(
                      color: AppColors.textColor1),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: hintText,
                    hintStyle: StyleConstants.customTextStyle12MonsterMedium(
                        color: AppColors.textColor2),
                  ),
                  onEditingComplete: () {
                    _onCompleteTextFieldEditing();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _categoriesNameButton(int index) {
    return InkWell(
      onTap: () {
        _onTapCategoriesButton(index: index);
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: index == _selectedCategoryIndex
                ? AppColors.primaryColor2
                : AppColors.whiteColor,
            border: Border.all(width: 1.0, color: AppColors.whiteBorderColor),
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: CommonWidgets().textWidget(
              _itemCategoriesList[index].categoryName,
              index == _selectedCategoryIndex
                  ? StyleConstants.customTextStyle12MontserratBold(
                      color: AppColors.textColor1)
                  : StyleConstants.customTextStyle12MonsterMedium(
                      color: AppColors.textColor4)),
        ),
      ),
    );
  }

  Widget _addCategoriesButton() {
    return InkWell(
      onTap: _onTapAddCategoryButton,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
          border: Border.all(width: 1.0, color: AppColors.whiteBorderColor),
        ),
        child: Center(
          child: _plusSymbolText(),
        ),
      ),
    );
  }

  Widget _clearButton() {
    return GestureDetector(
      onTap: () {
        if (_selectedMenuItems.isNotEmpty) {
          _onTapClearButton();
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(
            StringConstants.clear,
            StyleConstants.customTextStyle09MontserratBold(
                color: AppColors.textColor5)),
      ),
    );
  }

  Widget _chargeButton() {
    return GestureDetector(
      onTap: () {
        if (_selectedMenuItems.isNotEmpty) {
          _onTapChargeButton();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 15.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: _selectedMenuItems.isEmpty
                  ? AppColors.denotiveColor5
                  : AppColors.primaryColor2,
              borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
                  child: CommonWidgets().textWidget(
                      StringConstants.charge,
                      StyleConstants.customTextStyle(
                          fontSize: 16.0,
                          color: _selectedMenuItems.isEmpty
                              ? AppColors.textColor4
                              : AppColors.textColor1,
                          fontFamily: FontConstants.montserratBold),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                  child: CommonWidgets().textWidget(
                      '${StringConstants.symbolDollar}${totalAmount.toStringAsFixed(2)}',
                      StyleConstants.customTextStyle(
                          fontSize: 23.3,
                          color: _selectedMenuItems.isEmpty
                              ? AppColors.textColor4
                              : AppColors.textColor1,
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

  Widget _saveAndNewOrderButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0, right: 9.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (_selectedMenuItems.isNotEmpty) {
                _onTapSaveButton();
              }
            },
            child: CommonWidgets().textWidget(
                StringConstants.saveOrder,
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: _selectedMenuItems.isEmpty
                        ? AppColors.denotiveColor4
                        : AppColors.textColor6)),
          ),
          InkWell(
            onTap: () {
              if (_selectedMenuItems.isNotEmpty) {
                _onTapNewOrderButton();
              }
            },
            child: CommonWidgets().textWidget(
                StringConstants.newOrder,
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: _selectedMenuItems.isEmpty
                        ? AppColors.denotiveColor4
                        : AppColors.textColor7)),
          )
        ],
      ),
    );
  }

  //FoodExtra popup
  _showAddFoodExtrasPopUp(int index, bool selectedFromMenu) async {
    await showDialog(
        barrierDismissible: false,
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return FoodExtraPopup(
              item: selectedFromMenu
                  ? _itemList[index]
                  : _selectedMenuItems[index]);
        });
    setState(() {});
  }

  //Custom Menu popup
  _showCustomMenuPopup() {
    showDialog(
        barrierDismissible: false,
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return const CustomMenuPopup();
        }).then((value) {
      _onTapCategoriesButton(index: 1);
    });
  }

  //Other functions
  getUserName() async {
    _userName = await FunctionalUtils.getUserName();
    setState(() {});
  }

  double _getSalesTax() {
    _salesTax =
        (widget.events.salesTax.toDouble() / 100) * totalAmountOfSelectedItems;
    return _salesTax;
  }

  double _getSubTotal() {
    return totalAmountOfSelectedItems + _getSalesTax();
  }

  _updateCustomerName() {
    if (_customerName == StringConstants.addCustomer &&
        _selectedMenuItems.isNotEmpty) {
      _customerName = StringConstants.guestCustomer;
    } else if (_customerName == StringConstants.guestCustomer &&
        _selectedMenuItems.isEmpty) {
      _customerName = StringConstants.addCustomer;
    }
  }

  bool _invalidCustomerName() {
    return (_customerName == StringConstants.addCustomer ||
        _customerName == StringConstants.guestCustomer);
  }

  _calculateTotal() {
    setState(() {
      if (_selectedMenuItems.isNotEmpty) {
        totalAmount =
            totalAmountOfSelectedItems + _tip + _getSalesTax() - _discount;
      } else {
        totalAmount = 0.0;
      }
    });
  }

  _clearCart() {
    setState(() {
      _selectedMenuItems.clear();
      _itemList.clear();
      _tip = 0.0;
      _discount = 0.0;
      _addTipTextFieldController.clear();
      _addDiscountTextFieldController.clear();
      _customerName = StringConstants.addCustomer;
      _orderID = '';
      _customer = null;
      _getAllItems(widget.events.id);
    });
  }

  //Action Event
  _onTapAddCategoryButton() {}

  _onTapCategoriesButton({required int index}) {
    if (index != _selectedCategoryIndex) {
      setState(() {
        _selectedCategoryIndex = index;
        if (index == 0) {
          _showCustomMenuPopup();
        } else if (index == 1) {
          _itemList.clear();
          _itemList.addAll(_dbItemList);
        } else {
          _itemList.clear();
          var list = _dbItemList
              .where((element) =>
                  element.itemCategoryId == _itemCategoriesList[index].id)
              .toList();
          _itemList.addAll(list);
        }
      });
    }
  }

  _onTapClearButton() {
    DialogHelper.confirmationDialog(context, _onConfirmTapYes, _onConfirmTapNo,
        StringConstants.confirmMessage);
  }

  _onConfirmTapYes() {
    if (_orderID == "") {
      _clearCart();
    } else {
      _deleteOrder();
    }
    _onConfirmTapNo();
  }

  _onConfirmTapNo() {
    Navigator.of(context).pop();
  }

  _onTapChargeButton() {
    _isPaymentScreen = true;
    _moveCustomerToPaymentScreen();
    _showPaymentScreen();
  }

  _onTapSaveButton() {
    if (_orderID.isEmpty) {
      _callPlaceOrderAPI();
    } else {
      _saveOrderIntoLocalDB(_orderID, _orderCode);
    }
  }

  _onTapNewOrderButton() {
    DialogHelper.newOrderConfirmationDialog(
        context, _onTapDialogSave, _onTapDialogCancel);
  }

  _onTapDialogSave() {
    Navigator.of(context).pop();
    _callPlaceOrderAPI();
  }

  _onTapDialogCancel() {
    Navigator.of(context).pop();
    _clearCart();
  }

  _onTapIncrementCountButton(index) {
    setState(() {
      _selectedMenuItems[index].selectedItemQuantity += 1;
    });
  }

  _onTapDecrementCountButton(index) {
    setState(() {
      _selectedMenuItems[index].selectedItemQuantity -= 1;
      if (_selectedMenuItems[index].selectedItemQuantity == 0) {
        _selectedMenuItems[index].isItemSelected = false;
        _selectedMenuItems.removeAt(index);
      }
    });
  }

  _onTapAddCustomer() {
    setState(() {
      _isSearchCustomer = true;
    });
  }

  _onTapGridItem(int index) {
    setState(() {
      if (_itemList[index].isItemSelected) {
        _itemList[index].selectedItemQuantity = 0;
        _selectedMenuItems.remove(_itemList[index]);
        _itemList[index].removeAllExtraItems();
      } else {
        _itemList[index].selectedItemQuantity = 1;
        _selectedMenuItems.add(_itemList[index]);
        _itemList[index].selectedExtras = [];
      }

      _itemList[index].isItemSelected = !_itemList[index].isItemSelected;
    });
    // }
  }

  _onTapFoodExtras(int index) {
    _showAddFoodExtrasPopUp(index, true);
  }

  _onTapAddFoodExtras(int index) {
    _showAddFoodExtrasPopUp(index, false);
  }

  _onTapCustomerName(CustomerDetails? customerObj) {
    setState(() {
      if (customerObj != null) {
        _customerName = customerObj.getFullName();
      }
      _customer = customerObj;
      _isSearchCustomer = false;
    });
  }

  _onCompleteTextFieldEditing() {
    String tipText = _addTipTextFieldController.text;
    _updateTipToCustomer(tipText.toString());
    String discountText = _addDiscountTextFieldController.text;
    setState(() {
      _tip = double.parse(tipText.isEmpty ? '0.0' : tipText);
      _discount = double.parse(discountText.isEmpty ? '0.0' : discountText);
    });
    FocusScope.of(context).unfocus();
  }

  _onDrawerTap() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  _onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  _onBackFromAllOrder(
      {required SavedOrders savedOrder,
      required List<SavedOrdersItem> savedOrderItemList,
      required List<SavedOrdersExtraItems> savedOrderExtraItemList}) async {
    await _clearCart();
    setState(() {
      _isProduct = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _tip = savedOrder.tip.toDouble();
        _addTipTextFieldController.text = savedOrder.tip.toString();
        _discount = savedOrder.discount.toDouble();
        _addDiscountTextFieldController.text = savedOrder.discount.toString();
        _customerName = savedOrder.customerName;
        _orderID = savedOrder.orderId;
        //  salesTax = setSalesTax();
        if (savedOrder.customerName != StringConstants.guestCustomer) {
          _customer = CustomerDetails();
          List<String> names = _customerName.split(' ');
          if (names.length > 1) {
            _customer!.firstName = names[0];
            _customer!.lastName = names[1];
          }
          _customer!.email = savedOrder.email;
          _customer!.phoneNum = savedOrder.phoneNumber;
          _customer!.numCountryCode = savedOrder.phoneCountryCode;
        }
        for (var itemSaveOrder in savedOrderItemList) {
          for (var item in _itemList) {
            if (item.id == itemSaveOrder.itemId) {
              item.selectedItemQuantity = itemSaveOrder.quantity;
              item.isItemSelected = true;
              for (var extraSaveOrder in savedOrderExtraItemList) {
                if (item.foodExtraItemList.isEmpty) {
                  break;
                }
                for (var extraItem in item.foodExtraItemList) {
                  if (extraItem.id == extraSaveOrder.extraFoodItemId &&
                      item.id == extraSaveOrder.itemId) {
                    extraItem.selectedItemQuantity = extraSaveOrder.quantity;
                    extraItem.isItemSelected = true;
                    item.selectedExtras.add(extraItem);
                  }
                }
              }
              _selectedMenuItems.add(item);
              break;
            }
          }
        }
      });
    });
  }

  //data for p2pConnection
  _showOrderScreenToCustomer() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.eventSelected);
  }

  _updateOrderDataToCustomer() {
    P2POrderDetailsModel dataModel = P2POrderDetailsModel();
    dataModel.orderRequestModel = _getOrderRequestModel();
    dataModel.orderRequestModel!.addressLongitude = 0.0;
    dataModel.orderRequestModel!.addressLatitude = 0.0;
    dataModel.discount = _discount;
    dataModel.tip = _tip;
    dataModel.totalAmount = totalAmount;
    dataModel.foodCost = totalAmountOfSelectedItems;
    dataModel.salesTax = _getSalesTax();
    P2PConnectionManager.shared.updateDataWithObject(
        action: StaffActionConst.orderModelUpdated, dataObject: dataModel);
  }

  _moveCustomerToPaymentScreen() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.chargeOrderBill);
  }

  //data required for next screen
  PlaceOrderRequestModel _getOrderRequestModel() {
    PlaceOrderRequestModel orderRequestModel = PlaceOrderRequestModel();
    orderRequestModel.eventId = widget.events.id;
    orderRequestModel.cardId = "9db195092bc44d9db117f03a5a541025";
    orderRequestModel.campaignId = "";

    if (_orderID.isNotEmpty) {
      orderRequestModel.id = _orderID;
    }

    //addCustomer Details
    if (_customer != null) {
      orderRequestModel.firstName = _customer!.firstName;
      orderRequestModel.lastName = _customer!.lastName;
      orderRequestModel.email = _customer!.email;
      orderRequestModel.phoneNumCountryCode = _customer!.numCountryCode;
      orderRequestModel.phoneNumber = _customer!.phoneNum;
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
    orderRequestModel.orderItemsList = _getOrderItemList();

    return orderRequestModel;
  }

  List<OrderItemsList> _getOrderItemList() {
    List<OrderItemsList> orderList = [];
    for (var item in _selectedMenuItems) {
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
      orderItem.foodExtraItemMappingList = item.selectedExtras.isNotEmpty
          ? _getExtraItemsList(item.selectedExtras)
          : [];
      orderList.add(orderItem);
    }
    return orderList;
  }

  List<FoodExtraItemMappingList> _getExtraItemsList(
      List<FoodExtraItems> selectedExtras) {
    List<FoodExtraItemMappingList> extrasList = [];
    FoodExtraItemMappingList mappingObj = FoodExtraItemMappingList();
    List<OrderFoodExtraItemDetailDto> orderFoodExtraList = [];
    mappingObj.foodExtraCategoryId = selectedExtras[0].foodExtraItemCategoryId;
    for (var extraItem in selectedExtras) {
      OrderFoodExtraItemDetailDto orderExtraItem =
          OrderFoodExtraItemDetailDto();
      orderExtraItem.id = extraItem.id;
      orderExtraItem.quantity = extraItem.selectedItemQuantity;
      orderExtraItem.unitPrice = extraItem.sellingPrice.toDouble();
      orderExtraItem.totalAmount = extraItem.getTotalPrice();
      orderExtraItem.specialInstructions = "";
      orderExtraItem.name = extraItem.itemName;

      orderFoodExtraList.add(orderExtraItem);
    }
    mappingObj.orderFoodExtraItemDetailDto = orderFoodExtraList;
    extrasList.add(mappingObj);
    return extrasList;
  }

  //Navigation
  _showPaymentScreen() {
    PlaceOrderRequestModel requestModel = _getOrderRequestModel();
    Map billDetails = {
      'tip': _tip,
      "discount": _discount,
      'totalAmount': totalAmount,
      'foodCost': totalAmountOfSelectedItems,
      'salesTax': _getSalesTax()
    };
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  events: widget.events,
                  placeOrderRequestModel: requestModel,
                  selectedMenuItems: _selectedMenuItems,
                  billDetails: billDetails,
                  userName: _userName,
                )))
        .then((value) => {
              P2PConnectionManager.shared.getP2PContractor(this),
              if (value != null)
                {
                  if (value["isOrderComplete"] == "True")
                    {_clearCart()}
                  else if (value["orderID"] != "NA")
                    {_orderID = value["orderID"]}
                }
            });
  }

  //API Call
  _callPlaceOrderAPI({bool isPreviousRequestFail = false}) async {
    PlaceOrderRequestModel requestModel = _getOrderRequestModel();
    _orderPresenter.placeOrder(requestModel);
    setState(() {
      _isApiProcess = true;
    });
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
    GeneralSuccessModel responseModel = response;
    setState(() {
      _isApiProcess = false;
    });
    CommonWidgets().showSuccessSnackBar(
        message: responseModel.general![0].message ??
            StringConstants.eventCreatedSuccessfully,
        context: context);
    _clearCart();
  }

  @override
  void showErrorForPlaceOrder(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccessForPlaceOrder(response) {
    // TODO: implement showSuccessForPay
    _placeOrderResponseModel = response;
    if (_placeOrderResponseModel.id != null) {
      setState(() {
        _isApiProcess = false;
        _orderID = _placeOrderResponseModel.id!;
        _orderCode = _placeOrderResponseModel.orderCode!;
        _saveOrderIntoLocalDB(_orderID, _orderCode);
      });
    }
  }

  _saveOrderIntoLocalDB(String orderId, String orderCode) async {
    var result = await SavedOrdersDAO().getOrder(orderId);
    if (result != null) {
      await SavedOrdersDAO().clearEventDataByOrderID(_orderID);
      _insertSavedOrderData(orderId, orderCode);
    } else {
      _insertSavedOrderData(orderId, orderCode);
    }
  }

  _insertSavedOrderData(String orderId, String orderCode) async {
    PlaceOrderRequestModel orderRequestModel = _getOrderRequestModel();
    String customerName = orderRequestModel.firstName != null
        ? "${orderRequestModel.firstName} " + orderRequestModel.lastName!
        : StringConstants.guestCustomer;

    // Insert Order into DB
    await SavedOrdersDAO().insert(SavedOrders(
        eventId: orderRequestModel.eventId!,
        cardId: orderRequestModel.cardId!,
        orderCode: orderCode,
        orderId: orderId,
        customerName: customerName,
        email: orderRequestModel.email.toString(),
        phoneNumber: orderRequestModel.phoneNumber.toString(),
        phoneCountryCode: orderRequestModel.phoneNumCountryCode.toString(),
        address1: orderRequestModel.addressLine1.toString(),
        address2: orderRequestModel.addressLine2.toString(),
        country: orderRequestModel.country.toString(),
        state: orderRequestModel.state.toString(),
        city: orderRequestModel.city.toString(),
        zipCode: orderRequestModel.zipCode.toString(),
        orderDate: orderRequestModel.orderDate!,
        tip: _tip,
        discount: _discount,
        foodCost: totalAmountOfSelectedItems,
        totalAmount: totalAmount,
        payment: "NA",
        orderStatus: "saved",
        deleted: false,
        paymentTerm: "NA",
        refundAmount: "0.00",
        posPaymentMethod: "NA"));

    // Insert Items into DB
    List<OrderItemsList> orderItem = _getOrderItemList();
    for (var items in orderItem) {
      await SavedOrdersItemsDAO().insert(SavedOrdersItem(
          orderId: orderId,
          itemId: items.itemId.toString(),
          itemName: items.name.toString(),
          quantity: items.quantity!,
          unitPrice: items.unitPrice!,
          totalPrice: items.totalAmount!,
          itemCategoryId: items.itemCategoryId.toString(),
          deleted: false));
    }

    // Insert extra item into DB
    for (var items in _selectedMenuItems) {
      if (items.selectedExtras.isNotEmpty) {
        for (var extra in items.selectedExtras) {
          await SavedOrdersExtraItemsDAO().insert(SavedOrdersExtraItems(
              orderId: orderId,
              itemId: items.id,
              extraFoodItemId: extra.id,
              extraFoodItemName: extra.itemName,
              extraFoodItemCategoryId: extra.foodExtraItemCategoryId,
              quantity: extra.selectedItemQuantity,
              unitPrice: extra.sellingPrice,
              totalPrice: extra.getTotalPrice(),
              deleted: false));
        }
      }
    }
    _clearCart();
    CommonWidgets().showSuccessSnackBar(
        message: StringConstants.savedOrderSuccess, context: context);
  }

  //P2P Implemented Method
  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == CustomerActionConst.orderConfirmed) {
      _showPaymentScreen();
    } else if (response.action == CustomerActionConst.tip) {
      setState(() {
        _tip = double.parse(response.data);
      });
      _addTipTextFieldController.text = response.data;
    }
  }

  _updateTipToCustomer(String tip) {
    P2PConnectionManager.shared
        .notifyChangeToStaff(action: StaffActionConst.tip, data: tip);
  }

  // Delete Order function start from here
  _deleteOrder() async {
    setState(() {
      _isApiProcess = true;
    });
    await SavedOrdersDAO().clearEventDataByOrderID(_orderID).then((value) {
      _eventPresenter.deleteOrder(orderId: _orderID);
    });
  }
}

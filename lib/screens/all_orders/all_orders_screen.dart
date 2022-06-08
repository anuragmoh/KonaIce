import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_items.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/network_model/all_order/all_order_model.dart';
import 'package:kona_ice_pos/models/network_model/all_order/refund_payment_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/general_success_model.dart';
import 'package:kona_ice_pos/network/repository/all_orders/all_order_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/payment/refund_popup.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

import '../../models/network_model/order_model/order_response_model.dart';

class AllOrdersScreen extends StatefulWidget {
  final Function(
          SavedOrders, List<SavedOrdersItem>, List<SavedOrdersExtraItems>)
      onBackTap;
  final Events events;

  const AllOrdersScreen(
      {Key? key, required this.onBackTap, required this.events})
      : super(key: key);

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AllOrdersScreenState extends State<AllOrdersScreen>
    implements ResponseContractor {
  bool _isItemClick = true;
  List<SavedOrders> _savedOrdersList = [];
  List<SavedOrdersItem> _savedOrderItemList = [];
  List<SavedOrdersExtraItems> _savedOrderExtraItemList = [];
  late AllOrderPresenter _allOrderPresenter;
  int _selectedRow = -1;
  bool _isApiProcess = false;
  int _countOffSet = 0;
  bool _refundBool = false;

  _AllOrdersScreenState() {
    _allOrderPresenter = AllOrderPresenter(this);
  }

  getSyncOrders(
      {required int lastSync,
      required String orderStatus,
      required String eventId,
      required int offset}) {
    setState(() {
      _isApiProcess = true;
    });
    _allOrderPresenter.getSyncOrder(
        orderStatus: orderStatus,
        eventId: eventId,
        offset: offset,
        lastSync: lastSync);
  }

  Future<int> getLastSync() async {
    var result = await SessionDAO().getValueForKey(DatabaseKeys.allOrders);
    if (result != null) {
      return int.parse(result.value);
    } else {
      return 0;
    }
  }

  _getData() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        getLastSync().then((value) {
          getSyncOrders(
              lastSync: value,
              orderStatus: "",
              eventId: widget.events.id,
              offset: _countOffSet);
        });
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
        _getAllSavedOrders(widget.events.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textColor3.withOpacity(0.2),
        child: _savedOrdersList.isNotEmpty
            ? Column(
                children: [
                  // topWidget(),
                  Expanded(child: _bodyWidget()),
                  // bottomWidget(),
                ],
              )
            : Align(
                alignment: Alignment.center,
                child: CommonWidgets().textWidget(
                    StringConstants.noOrdersToDisplay,
                    StyleConstants.customTextStyle(
                        fontSize: 20.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratSemiBold))),
      ),
    );
  }

  Widget topWidget() => Container(
        height: 100.0,
        decoration: BoxDecoration(
            color: AppColors.primaryColor1,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0))),
      );

  Widget _bodyWidget() => Container(
        color: AppColors.textColor3.withOpacity(0.1),
        child: _bodyWidgetComponent(),
      );

  Widget _bodyWidgetComponent() => Row(children: [
        _leftSideWidget(),
        Visibility(visible: _selectedRow != -1, child: _rightSideWidget()),
      ]);

  Widget _leftSideWidget() => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _topComponent(),
        Expanded(child: _tableHeadRow()),
      ]));

  Widget _topComponent() => Padding(
        padding: const EdgeInsets.only(
            left: 18.8, top: 20.9, right: 17.0, bottom: 21.1),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const SizedBox(width: 21.0),
            CommonWidgets().textView(
                StringConstants.foodOrders,
                StyleConstants.customTextStyle(
                    fontSize: 22.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratBold)),
          ]),
          Visibility(
            visible: false,
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, bottom: 10.0, top: 9.0, left: 9.0),
                  child: Row(children: [
                    CommonWidgets().image(
                        image: AssetsConstants.filter,
                        width: 3.38 * SizeConfig.imageSizeMultiplier,
                        height: 3.25 * SizeConfig.imageSizeMultiplier),
                    const SizedBox(width: 6.0),
                    CommonWidgets().textView(
                        StringConstants.filterOrders,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.primaryColor1,
                            fontFamily: FontConstants.montserratMedium)),
                  ]),
                )),
          ),
        ]),
      );

  Widget _tableHeadRow() => Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          // controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: DataTable(
                    sortAscending: false,
                    showCheckboxColumn: false,
                    columnSpacing: 35,
                    dataRowHeight: 5.51 * SizeConfig.heightSizeMultiplier,
                    columns: [
                      _nameDataColumn(),
                      _dateDataColumn(),
                      _paymentDataColumn(),
                      _priceDataColumn(),
                      _statusDataColumn(),
                    ],
                    rows: List.generate(_savedOrdersList.length,
                        (index) => _getDataRow(_savedOrdersList[index], index)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  DataColumn _statusDataColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.status,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _priceDataColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.price,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _paymentDataColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.payment,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _dateDataColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.date,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _nameDataColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.customerName,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataRow _getDataRow(SavedOrders savedOrders, int index) {
    return DataRow(
        onSelectChanged: (value) {
          setState(() {
            _selectedRow = index;
          });
          _getItemByOrderId(savedOrders.orderId);
        },
        color: _selectedRow == index
            ? MaterialStateProperty.all(Colors.white)
            : null,
        cells: <DataCell>[
          _buildDataCell(savedOrders),
          _buildDataCell2(savedOrders),
          _buildDataCell3(savedOrders),
          _buildDataCell4(savedOrders),
          DataCell(
              _getOrderStatusView(savedOrders.orderStatus, savedOrders.payment))
        ]);
  }

  DataCell _buildDataCell4(SavedOrders savedOrders) {
    return DataCell(
      CommonWidgets().textView(
          '\$ ${savedOrders.totalAmount}',
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratMedium)),
    );
  }

  DataCell _buildDataCell3(SavedOrders savedOrders) {
    return DataCell(
      CommonWidgets().textView(
          savedOrders.payment,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1,
              fontFamily: FontConstants.montserratMedium)),
    );
  }

  DataCell _buildDataCell2(SavedOrders savedOrders) {
    return DataCell(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonWidgets().textView(
            savedOrders.getOrderDate(),
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: AppColors.textColor1,
                fontFamily: FontConstants.montserratMedium)),
        CommonWidgets().textView(
            savedOrders.getOrderDateTime(),
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: AppColors.textColor1,
                fontFamily: FontConstants.montserratMedium))
      ],
    ));
  }

  DataCell _buildDataCell(SavedOrders savedOrders) {
    return DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _circularImage(AssetsConstants.defaultProfileImage),
          const SizedBox(width: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().textView(
                  savedOrders.customerName,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor4,
                      fontFamily: FontConstants.montserratBold)),
              CommonWidgets().textView(
                  savedOrders.orderCode,
                  StyleConstants.customTextStyle(
                      fontSize: 10.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratMedium))
            ],
          ),
        ]));
  }

  Widget _circularImage(String imageUrl) => Container(
        width: 4.55 * SizeConfig.imageSizeMultiplier,
        height: 4.55 * SizeConfig.imageSizeMultiplier,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(imageUrl))),
      );

  Widget _rightSideWidget() => Padding(
        padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.307,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 19.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderDetailsVisibility(),
                  Visibility(
                      visible: _selectedRow != -1 ? true : false,
                      child: _customerNameWidget(
                          customerName: _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].customerName
                              : 'NA')),
                  const SizedBox(height: 7.0),
                  _visibilityOrderDateTime(),
                  const SizedBox(height: 8.0),
                  _visibilityEventName(),
                  const SizedBox(height: 35.0),
                  Visibility(
                    visible: _selectedRow != -1,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isItemClick = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: CommonWidgets().textView(
                                          StringConstants.items,
                                          StyleConstants.customTextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.textColor1,
                                              fontFamily: FontConstants
                                                  .montserratBold)),
                                    )),
                                const SizedBox(
                                  height: 11.0,
                                ),
                                Container(
                                  color: _isItemClick
                                      ? AppColors.primaryColor2
                                      : AppColors.whiteColor,
                                  width: 45.0,
                                  height: 3.0,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 53.0,
                            ),
                            Visibility(
                              visible: false,
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isItemClick = false;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: CommonWidgets().textView(
                                            StringConstants.inProcess,
                                            StyleConstants.customTextStyle(
                                                fontSize: 12.0,
                                                color: AppColors.textColor1,
                                                fontFamily: FontConstants
                                                    .montserratBold)),
                                      )),
                                  const SizedBox(
                                    height: 11.0,
                                  ),
                                  Container(
                                    color: _isItemClick
                                        ? AppColors.whiteColor
                                        : AppColors.primaryColor2,
                                    width: 90.0,
                                    height: 3.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35.5,
                        ),
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Divider(
                              thickness: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  _visibilityStatus(),
                  _visibilitySelectedRow(),
                ]),
          ),
        ),
      );

  Visibility _visibilitySelectedRow() {
    return Visibility(
      visible: _selectedRow != -1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 29.0, top: 10.0),
        child: _getRightOrderStatusView(
            _selectedRow != -1
                ? _savedOrdersList[_selectedRow].orderStatus
                : "NA",
            _selectedRow != -1 ? _savedOrdersList[_selectedRow].payment : "NA",
            _selectedRow != -1
                ? _savedOrdersList[_selectedRow].refundAmount
                : "NA",
            _selectedRow != -1
                ? _savedOrdersList[_selectedRow].paymentTerm
                : "NA"),
      ),
    );
  }

  Visibility _visibilityStatus() {
    return Visibility(
      visible: _selectedRow != -1,
      child: Expanded(
          child: SingleChildScrollView(
        child: Container(
          color: AppColors.whiteColor,
          child: _isItemClick ? _itemView() : _inProgressView(),
        ),
      )),
    );
  }

  Visibility _visibilityEventName() {
    return Visibility(
      visible: _selectedRow != -1,
      child: _customerDetailsComponent(
          eventName: widget.events.getEventName(),
          email: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].email
              : StringExtension.empty(),
          storeAddress: widget.events.getEventAddress(),
          phone: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].phoneCountryCode +
                  _savedOrdersList[_selectedRow].phoneNumber
              : StringExtension.empty()),
    );
  }

  Visibility _visibilityOrderDateTime() {
    return Visibility(
      visible: _selectedRow != -1 ? true : false,
      child: _orderDetailsWidget(
          orderId: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].orderId
              : 'NA',
          orderDate: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].getOrderDateTime()
              : "NA"),
    );
  }

  Visibility _buildOrderDetailsVisibility() {
    return Visibility(
      visible: _selectedRow != -1 ? true : false,
      child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 11.0),
          child: CommonWidgets().textView(
              StringConstants.orderDetails,
              StyleConstants.customTextStyle(
                  fontSize: 22.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratBold))),
    );
  }

  // customer Name
  Widget _customerNameWidget({required String customerName}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CommonWidgets().textView(
            '${StringConstants.customerName} - ',
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: AppColors.textColor1,
                fontFamily: FontConstants.montserratRegular)),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratBold))),
      ]);

  // customer Details
  Widget _customerDetailsComponent(
          {required String eventName,
          required String email,
          required String storeAddress,
          required String phone}) =>
      Column(
        children: [
          Visibility(
            visible: email.isNotEmpty && !email.contains('null'),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.email}: ',
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2,
                            fontFamily: FontConstants.montserratMedium))),
              ]),
            ),
          ),
          Visibility(
            visible: phone.isNotEmpty && !phone.contains('null'),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.phone}: ',
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        phone,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2,
                            fontFamily: FontConstants.montserratMedium))),
              ]),
            ),
          ),
          Visibility(
            visible: eventName.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.eventName}: ',
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        eventName,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2,
                            fontFamily: FontConstants.montserratMedium))),
              ]),
            ),
          ),
          Visibility(
            visible: eventName.isNotEmpty,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CommonWidgets().textView(
                  '${StringConstants.eventAddress}: ',
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratRegular)),
              Expanded(
                  child: CommonWidgets().textView(
                      storeAddress,
                      StyleConstants.customTextStyle(
                          fontSize: 9.0,
                          color: AppColors.textColor2,
                          fontFamily: FontConstants.montserratMedium))),
            ]),
          ),
        ],
      );

  // Widget orderDetails
  Widget _orderDetailsWidget(
          {required String orderId, required String orderDate}) =>
      Column(children: [
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderId,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor2,
                  fontFamily: FontConstants.montserratMedium)),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor2,
                  fontFamily: FontConstants.montserratMedium)),
        ]),
      ]);

  Widget _itemView() => Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: _savedOrderItemList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _itemViewListItem(
                  _savedOrderItemList[index].itemName,
                  _savedOrderItemList[index].quantity,
                  _savedOrderItemList[index].totalPrice.toDouble());
            }),
      ]);

  Widget _itemViewListItem(String itemName, int quantity, double price) =>
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 6,
              child: CommonWidgets().textView(
                  itemName,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "${StringConstants.qty} - $quantity",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${price.toStringAsFixed(2)}",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratRegular)),
            )
          ]),
          const SizedBox(height: 20.0),
        ],
      );

  Widget _inProgressView() => Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _itemViewListItem('Kiddie', 7, 20);
              }),
        ],
      );

  Widget _completedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor2.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 16.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets().textView(
                  StringConstants.completed,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor2,
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget _completedAndRefundView(dynamic refundAmout) => Column(
        children: [
          _completedView(),
          const SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: _refundBool ? true : false,
            child: GestureDetector(
              onTap: _onTapRefundButton,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                    color: _refundBool
                        ? AppColors.denotiveColor2.withOpacity(0.2)
                        : AppColors.denotiveColor4.withOpacity(0.2)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 7.0, bottom: 7.0, right: 16.0, left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      refundAmout > 0
                          ? CommonWidgets().textView(
                              StringConstants.refund,
                              StyleConstants.customTextStyle(
                                  fontSize: 9.0,
                                  color: AppColors.denotiveColor2,
                                  fontFamily: FontConstants.montserratMedium))
                          : CommonWidgets().textView(
                              StringConstants.refunded,
                              StyleConstants.customTextStyle(
                                  fontSize: 9.0,
                                  color: AppColors.textColor1,
                                  fontFamily: FontConstants.montserratMedium)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _preparingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor3.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor3,
                      fontFamily: FontConstants.montserratMedium)),
              const SizedBox(
                width: 10.0,
              ),
              CommonWidgets().image(
                  image: AssetsConstants.yellowTriangle,
                  width: 6.0,
                  height: 6.0)
            ],
          ),
        ),
      );

  Widget _savedView() => Container(
        height: 25.0,
        width: 80.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.primaryColor1.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 15.0,
            ),
            CommonWidgets().textView(
                StringConstants.saved,
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: AppColors.primaryColor1,
                    fontFamily: FontConstants.montserratMedium)),
            const SizedBox(
              width: 15.0,
            ),
          ],
        ),
      );

  Widget _rightCompletedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor2.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 11.0, bottom: 11.0, right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets().textView(
                  StringConstants.completed,
                  StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: AppColors.denotiveColor2,
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget _rightPendingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor1.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 20.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.pending,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor1,
                      fontFamily: FontConstants.montserratMedium)),
              const SizedBox(
                width: 10.0,
              ),
              CommonWidgets().image(
                  image: AssetsConstants.redTriangle, width: 6.0, height: 6.0)
            ],
          ),
        ),
      );

  Widget _rightPreparingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor3.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor3,
                      fontFamily: FontConstants.montserratMedium)),
              const SizedBox(
                width: 10.0,
              ),
              CommonWidgets().image(
                  image: AssetsConstants.yellowTriangle,
                  width: 6.0,
                  height: 6.0)
            ],
          ),
        ),
      );

  Widget _rightSavedView() => GestureDetector(
        onTap: _onTapResumeButton,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.5)),
              color: AppColors.primaryColor1.withOpacity(0.1)),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 11.0, bottom: 11.0, right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets().textView(
                    StringConstants.resume,
                    StyleConstants.customTextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor1,
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
          ),
        ),
      );

  //Action Events
  _onTapResumeButton() {
    widget.onBackTap(_savedOrdersList[_selectedRow], _savedOrderItemList,
        _savedOrderExtraItemList);
  }

  _onTapRefundButton() {
    showDialog(
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return RefundPopup(
              amount: _savedOrdersList[_selectedRow].totalAmount);
        }).then((value) {
      String amount = value['totalAmount'];
      double totalAmount = double.parse(amount);
      _refundPaymentApiCall(totalAmount);
    });
  }

  //Refund Payment Api call
  _refundPaymentApiCall(double totalAmount) {
    RefundPaymentModel refundPaymentModel = RefundPaymentModel();
    refundPaymentModel.refundAmount = totalAmount;
    setState(() {
      _isApiProcess = true;
    });
    _allOrderPresenter.refundPayment(
        _savedOrdersList[_selectedRow].orderId, refundPaymentModel);
  }

  // Get data from local db function start from here
  _getAllSavedOrders(String eventId) async {
    setState(() {
      _savedOrdersList.clear();
    });
    var result = await SavedOrdersDAO().getOrdersList(eventId);
    if (result != null) {
      setState(() {
        _savedOrdersList.addAll(result);
      });
    } else {
      _savedOrdersList.clear();
    }
  }

  Widget _getOrderStatusView(String status, String paymentStatus) {
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return _savedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return _preparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return _completedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return _completedView();
      } else {
        return _inProgressView();
      }
    } else {
      return _savedView();
    }
  }

  Widget _getRightOrderStatusView(String status, String paymentStatus,
      dynamic refundAmout, String paymentTerm) {
    refundAmout ??= 0;
    if (paymentTerm == "menu") {
      _refundBool = true;
    }
    debugPrint('<><><><><><>$refundAmout');
    debugPrint(status);
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return _rightSavedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return _rightPreparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return _rightCompletedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return _completedAndRefundView(refundAmout);
      } else {
        debugPrint('>>>>>>>>>>>>>');
        return _rightPendingView();
      }
    } else {
      return _rightSavedView();
    }
  }

  _getItemByOrderId(String orderId) async {
    setState(() {
      _savedOrderItemList.clear();
    });
    var result = await SavedOrdersItemsDAO().getItemList(orderId: orderId);
    if (result != null) {
      setState(() {
        _savedOrderItemList.addAll(result);
      });
      _getAllFoodExtras();
    } else {
      setState(() {
        _savedOrderItemList.clear();
      });
    }
  }

  _getAllFoodExtras() async {
    if (_savedOrderItemList.isNotEmpty) {
      _savedOrderExtraItemList.clear();
      for (var item in _savedOrderItemList) {
        await _getExtraFoodItems(item.itemId, item.orderId);
      }
    }
  }

  _getExtraFoodItems(String itemId, String orderId) async {
    var result = await SavedOrdersExtraItemsDAO()
        .getExtraItemList(itemId: itemId, orderId: orderId);
    if (result != null) {
      setState(() {
        _savedOrderExtraItemList.addAll(result);
      });
    }
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    setState(() {
      _isApiProcess = false;
    });

    if (response is GeneralSuccessModel) {
      GeneralSuccessModel responseModel = response;
      CommonWidgets().showSuccessSnackBar(
          message: responseModel.general![0].message ??
              StringConstants.eventCreatedSuccessfully,
          context: context);
    } else {
      _ordersInsertIntoDb(response);
    }
  }

  _updateLastSync() async {
    SessionDAO().insert(Session(
        key: DatabaseKeys.allOrders,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  _ordersInsertIntoDb(AllOrderResponse response) async {
    List<AllOrderResponse> _allOrdersList = [];
    setState(() {
      _allOrdersList.add(response);
    });

    for (var event in _allOrdersList[0].data!) {
      String customerName = event.firstName != null
          ? "${event.firstName} " + event.lastName!
          : StringConstants.guestCustomer;

      // Insert Order into DB
      await _insertOrders(event, customerName);
      await _orderItemsList(event);
    }
    _updateLastSync();
    _getAllSavedOrders(widget.events.id);
  }

  Future<void> _insertOrders(
      PlaceOrderResponseModel event, String customerName) async {
    await SavedOrdersDAO().insert(SavedOrders(
        eventId: event.eventId!,
        cardId: event.id!,
        orderCode: event.orderCode!,
        orderId: event.id!,
        customerName: customerName,
        email: event.email.toString(),
        phoneNumber: event.phoneNumber.toString(),
        phoneCountryCode: event.phoneNumCountryCode.toString(),
        address1: event.addressLine1.toString(),
        address2: event.addressLine2.toString(),
        country: event.country.toString(),
        state: event.state.toString(),
        city: event.city.toString(),
        zipCode: event.zipCode.toString(),
        orderDate: event.orderDate!,
        tip: 0.0,
        discount: 0.0,
        foodCost: event.orderInvoice!.foodTotal!,
        totalAmount: event.orderInvoice!.total!,
        payment: event.paymentStatus!,
        orderStatus: event.orderStatus!,
        deleted: false,
        paymentTerm: event.paymentTerm.toString(),
        refundAmount: event.refundAmount == "null" ? 0 : event.refundAmount));
  }

  Future<void> _orderItemsList(PlaceOrderResponseModel event) async {
    for (var item in event.orderItemsList!) {
      await SavedOrdersItemsDAO().insert(SavedOrdersItem(
          orderId: event.id!,
          itemId: item.itemId.toString(),
          itemName: item.name.toString(),
          quantity: item.quantity!,
          unitPrice: item.unitPrice!,
          totalPrice: item.totalAmount!,
          itemCategoryId: item.itemCategoryId.toString(),
          deleted: false));
      if (item.foodExtraItemMappingList != null) {
        await _foodExtraItemMapList(item, event);
      }
    }
  }

  Future<void> _foodExtraItemMapList(
      OrderItemsDetailList item, PlaceOrderResponseModel event) async {
    for (var extraItemMappingList in item.foodExtraItemMappingList!) {
      if (extraItemMappingList.orderFoodExtraItemDetailDto != null) {
        for (var extraItem
            in extraItemMappingList.orderFoodExtraItemDetailDto!) {
          await SavedOrdersExtraItemsDAO().insert(SavedOrdersExtraItems(
              orderId: event.id!,
              itemId: item.itemId.toString(),
              extraFoodItemId: extraItem.id!,
              extraFoodItemName: extraItem.foodExtraItemName!,
              extraFoodItemCategoryId:
                  extraItemMappingList.foodExtraCategoryId!,
              quantity: extraItem.quantity!,
              unitPrice: extraItem.unitPrice!,
              totalPrice: extraItem.totalAmount!,
              deleted: false));
        }
      }
    }
  }
}

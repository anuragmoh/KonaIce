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
import 'package:kona_ice_pos/models/network_model/all_order/refund_payment_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/general_success_model.dart';
import 'package:kona_ice_pos/network/repository/all_orders/all_order_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/models/network_model/all_order/all_order_model.dart';
import 'package:kona_ice_pos/screens/payment/refund_popup.dart';
import 'package:kona_ice_pos/screens/search_widget.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/color_extension.dart';
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
  bool _isNoRecord = false;
  bool _isNoRecordFound = false;
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

  _getData() async {
    if (await CheckConnection.connectionState() == true) {
      getLastSync().then((value) {
        getSyncOrders(
            lastSync: value,
            orderStatus: "",
            eventId: widget.events.id,
            offset: _countOffSet);
      });
    } else {
      CommonWidgets().showErrorSnackBar(
          errorMessage: StringConstants.noInternetConnection, context: context);
      _getAllSavedOrders(widget.events.id);
    }
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
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.textColor3.toMaterialColor().withOpacity(0.2),
        child: _savedOrdersList.isNotEmpty
            ? Column(
                children: [
                  // topWidget(),
                  Expanded(child: bodyWidget()),
                  // bottomWidget(),
                ],
              )
            : Visibility(
                visible: _isNoRecord,
                child: Align(
                    alignment: Alignment.center,
                    child: CommonWidgets().textWidget(
                        StringConstants.noOrdersToDisplay,
                        StyleConstants.customTextStyle(
                            fontSize: 20.0,
                            color: AppColors.textColor1,
                            fontFamily: FontConstants.montserratSemiBold))),
              ),
      ),
    );
  }

  Widget bodyWidget() => Container(
        color: AppColors.textColor3.toMaterialColor().withOpacity(0.1),
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
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratBold)),
            _buildSearch("text"),
          ]),
          Visibility(
            visible: false,
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.toMaterialColor(),
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
                            color: AppColors.primaryColor1.toMaterialColor(),
                            fontFamily: FontConstants.montserratMedium)),
                  ]),
                )),
          ),
        ]),
      );

  //String query = "SELECT * FROM sentences WHERE title LIKE '%${text}%' OR  body LIKE '%${text}%'";
  SearchWidget _buildSearch(String text) {
    return SearchWidget(
        text: "",
        onChanged: _searchBy,
        hintText: "Search by Order Id, Order Code or Customer Name");
  }

  _searchBy(text) async {
    var result = await SavedOrdersDAO().getFilteredOrdersList(text);
    if (result != null) {
      setState(() {
        if (text.toString().isEmpty) {
          _isNoRecordFound = false;
        }
        _savedOrdersList.clear();
        _savedOrdersList.addAll(result);
      });
    } else {
      var result = await SavedOrdersDAO().getOrdersList(widget.events.id);
      if (result != null) {
        setState(() {
          _savedOrdersList.clear();
          if (text.toString().isNotEmpty) {
            _isNoRecordFound = true;
          }
          _savedOrdersList.addAll(result);
        });
      }
    }
  }

  Widget _tableHeadRow() => _isNoRecordFound
      ? Align(
          alignment: Alignment.center,
          child: CommonWidgets().textWidget(
              StringConstants.noRecordsFound,
              StyleConstants.customTextStyle(
                  fontSize: 20.0,
                  color: AppColors.textColor1,
                  fontFamily: FontConstants.montserratSemiBold)))
      : Padding(
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
                        _buildNameColumn(),
                        _buildDateColumn(),
                        _buildPaymentColumn(),
                        _buildPriceColumn(),
                        _buildTaxColumn(),
                        _buildTipColumn(),
                        _buildStatusColumn(),
                      ],
                      rows: List.generate(
                          _savedOrdersList.length,
                          (index) =>
                              _getDataRow(_savedOrdersList[index], index)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

  DataColumn _buildStatusColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.status,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildTipColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.all_order_tip,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildTaxColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.all_order_taxAmount,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildPriceColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.price,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildPaymentColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.payment,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildDateColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.date,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataColumn _buildNameColumn() {
    return DataColumn(
      label: CommonWidgets().textView(
          StringConstants.customerName,
          StyleConstants.customTextStyle(
              fontSize: 12.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratBold)),
    );
  }

  DataRow _getDataRow(SavedOrders savedOrders, int index) {
    return DataRow(
        onSelectChanged: (value) {
          setState(() {
            _selectedRow = index;
          });
          getItemByOrderId(savedOrders.orderId);
        },
        color: _selectedRow == index
            ? MaterialStateProperty.all(Colors.white)
            : null,
        cells: <DataCell>[
          DataCell(Row(
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
                            color: AppColors.textColor4.toMaterialColor(),
                            fontFamily: FontConstants.montserratBold)),
                    CommonWidgets().textView(
                        savedOrders.orderCode,
                        StyleConstants.customTextStyle(
                            fontSize: 10.0,
                            color: AppColors.textColor1.toMaterialColor(),
                            fontFamily: FontConstants.montserratMedium))
                  ],
                ),
              ])),
          _buildOrderDateDataCell(savedOrders),
          DataCell(
            CommonWidgets().textView(
                savedOrders.payment,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          DataCell(
            CommonWidgets().textView(
                '\$ ${savedOrders.grandTotalAmount}',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratMedium)),
          ),

          DataCell(
            CommonWidgets().textView(
                '\$ ${savedOrders.tax_amount}',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          DataCell(
            CommonWidgets().textView(
                '\$ ${savedOrders.tip}',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          DataCell(_getOrderStatusView(
              savedOrders.orderStatus, savedOrders.payment)),
        ]);
  }

  DataCell _buildOrderDateDataCell(SavedOrders savedOrders) {
    return DataCell(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonWidgets().textView(
            savedOrders.getOrderDate(),
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: AppColors.textColor1.toMaterialColor(),
                fontFamily: FontConstants.montserratMedium)),
        CommonWidgets().textView(
            savedOrders.getOrderDateTime(),
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: AppColors.textColor1.toMaterialColor(),
                fontFamily: FontConstants.montserratMedium))
      ],
    ));
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
              color: AppColors.whiteColor.toMaterialColor(),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 19.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _orderDetailsVisi(),
                  Visibility(
                      visible: _selectedRow != -1 ? true : false,
                      child: _customerNameWidget(
                          customerName: _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].customerName
                              : 'NA')),
                  const SizedBox(height: 7.0),
                  Visibility(
                    visible: _selectedRow != -1 ? true : false,
                    child: _orderDetailsWidget(
                        orderId: _selectedRow != -1
                            ? _savedOrdersList[_selectedRow].orderId
                            : 'NA',
                        orderDate: _selectedRow != -1
                            ? _savedOrdersList[_selectedRow].getOrderDateTime()
                            : "NA"),
                  ),
                  const SizedBox(height: 8.0),
                  _selectedRowVisi(),
                  const SizedBox(height: 35.0),
                  _buildVisi(),
                  const SizedBox(height: 10.0),
                  Visibility(
                    visible: _selectedRow != -1,
                    child: Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        color: AppColors.whiteColor.toMaterialColor(),
                        child: _isItemClick ? itemView() : inProgressView(),
                      ),
                    )),
                  ),
                  Visibility(
                    visible: _selectedRow != -1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 29.0, top: 10.0),
                      child: _getRightOrderStatusView(
                          _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].orderStatus
                              : "NA",
                          _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].payment
                              : "NA",
                          _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].refundAmount
                              : "0.00",
                          _selectedRow != -1
                              ? _savedOrdersList[_selectedRow].posPaymentMethod
                              : "NA"),
                    ),
                  ),
                ]),
          ),
        ),
      );

  Visibility _buildVisi() {
    return Visibility(
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
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: CommonWidgets().textView(
                            StringConstants.items,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: AppColors.textColor1.toMaterialColor(),
                                fontFamily: FontConstants.montserratBold)),
                      )),
                  const SizedBox(
                    height: 11.0,
                  ),
                  Container(
                    color: _isItemClick
                        ? AppColors.primaryColor2.toMaterialColor()
                        : AppColors.whiteColor.toMaterialColor(),
                    width: 45.0,
                    height: 3.0,
                  ),
                ],
              ),
              const SizedBox(
                width: 53.0,
              ),
              _buildProcessVisi(),
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
    );
  }

  Visibility _buildProcessVisi() {
    return Visibility(
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
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: CommonWidgets().textView(
                    StringConstants.inProcess,
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratBold)),
              )),
          const SizedBox(
            height: 11.0,
          ),
          Container(
            color: _isItemClick
                ? AppColors.whiteColor.toMaterialColor()
                : AppColors.primaryColor2.toMaterialColor(),
            width: 90.0,
            height: 3.0,
          ),
        ],
      ),
    );
  }

  Visibility _selectedRowVisi() {
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
              : StringExtension.empty(),
          posPaymentMethod: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].posPaymentMethod
              : StringExtension.empty(),
          tip: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].tip.toString()
              : StringExtension.empty(),
          taxAmount: _selectedRow != -1
              ? _savedOrdersList[_selectedRow].tax_amount.toString()
              : StringExtension.empty()),
    );
  }

  Visibility _orderDetailsVisi() {
    return Visibility(
      visible: _selectedRow != -1 ? true : false,
      child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 11.0),
          child: CommonWidgets().textView(
              StringConstants.orderDetails,
              StyleConstants.customTextStyle(
                  fontSize: 22.0,
                  color: AppColors.textColor1.toMaterialColor(),
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
                color: AppColors.textColor1.toMaterialColor(),
                fontFamily: FontConstants.montserratRegular)),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratBold))),
      ]);

  // customer Details
  Widget _customerDetailsComponent(
          {required String eventName,
          required String email,
          required String storeAddress,
          required String phone,
          required String posPaymentMethod,
          required String tip,
          required String taxAmount}) =>
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
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2.toMaterialColor(),
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
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        phone,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2.toMaterialColor(),
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
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        eventName,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2.toMaterialColor(),
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
                    '${StringConstants.eventAddress}: ',
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        storeAddress,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2.toMaterialColor(),
                            fontFamily: FontConstants.montserratMedium))),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildPaymentRow(posPaymentMethod),
          ),
          Visibility(
            visible: eventName.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.tip} ',
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: AppColors.textColor1.toMaterialColor(),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        "\$$tip",
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: AppColors.textColor2.toMaterialColor(),
                            fontFamily: FontConstants.montserratMedium))),
              ]),
            ),
          ),
          Visibility(
            visible: eventName.isNotEmpty,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CommonWidgets().textView(
                  '${StringConstants.salesTax} ',
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.textColor1.toMaterialColor(),
                      fontFamily: FontConstants.montserratRegular)),
              Expanded(
                  child: CommonWidgets().textView(
                      "\$$taxAmount",
                      StyleConstants.customTextStyle(
                          fontSize: 9.0,
                          color: AppColors.textColor2.toMaterialColor(),
                          fontFamily: FontConstants.montserratMedium))),
            ]),
          ),
        ],
      );

  Row _buildPaymentRow(String posPaymentMethod) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CommonWidgets().textView(
          '${StringConstants.paymentMode}: ',
          StyleConstants.customTextStyle(
              fontSize: 9.0,
              color: AppColors.textColor1.toMaterialColor(),
              fontFamily: FontConstants.montserratRegular)),
      Expanded(
          child: posPaymentMethod == "null"
              ? CommonWidgets().textView(
                  StringConstants.na,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.textColor2.toMaterialColor(),
                      fontFamily: FontConstants.montserratMedium))
              : posPaymentMethod == "CASH"
                  ? CommonWidgets().textView(
                      StringConstants.paymentModeCash,
                      StyleConstants.customTextStyle(
                          fontSize: 9.0,
                          color: AppColors.textColor2.toMaterialColor(),
                          fontFamily: FontConstants.montserratMedium))
                  : CommonWidgets().textView(
                      StringConstants.paymentModeCard,
                      StyleConstants.customTextStyle(
                          fontSize: 9.0,
                          color: AppColors.textColor2.toMaterialColor(),
                          fontFamily: FontConstants.montserratMedium))),
    ]);
  }

  // Widget orderDetails
  Widget _orderDetailsWidget(
          {required String orderId, required String orderDate}) =>
      Column(children: [
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderId,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor1.toMaterialColor(),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor2.toMaterialColor(),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor1.toMaterialColor(),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: AppColors.textColor2.toMaterialColor(),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
      ]);

  Widget itemView() => Column(children: [
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
                      color: AppColors.textColor1.toMaterialColor(),
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "${StringConstants.qty} - $quantity",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1.toMaterialColor(),
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${price.toStringAsFixed(2)}",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1.toMaterialColor(),
                      fontFamily: FontConstants.montserratRegular)),
            )
          ]),
          const SizedBox(height: 20.0),
        ],
      );

  Widget inProgressView() => Column(
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

  Widget completedView() => Container(
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
                      color: AppColors.denotiveColor2.toMaterialColor(),
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget completedAndRefundView(double refundAmout) => Column(
        children: [
          completedView(),
          const SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: _refundBool ? true : false,
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                  color: _refundBool
                      ? AppColors.denotiveColor4
                          .toMaterialColor()
                          .withOpacity(0.2)
                      : AppColors.denotiveColor2
                          .toMaterialColor()
                          .withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 7.0, bottom: 7.0, right: 16.0, left: 16.0),
                child: InkWell(
                  onTap: refundAmout > 0.00
                      ? onTapRefundedButton
                      : onTapRefundButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      refundAmout > 0.00
                          ? CommonWidgets().textView(
                              StringConstants.refunded,
                              StyleConstants.customTextStyle(
                                  fontSize: 9.0,
                                  color: AppColors.textColor1.toMaterialColor(),
                                  fontFamily: FontConstants.montserratMedium))
                          : CommonWidgets().textView(
                              StringConstants.refund,
                              StyleConstants.customTextStyle(
                                  fontSize: 9.0,
                                  color: AppColors.denotiveColor2
                                      .toMaterialColor(),
                                  fontFamily: FontConstants.montserratMedium))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  onTapRefundedButton() {}

  onTapRefundButton() {
    showDialog(
        barrierColor: AppColors.textColor1.toMaterialColor().withOpacity(0.7),
        context: context,
        builder: (context) {
          return RefundPopup(
              amount: _savedOrdersList[_selectedRow].grandTotalAmount);
        }).then((value) {
      String amount = value['totalAmount'];
      double totalAmount = double.parse(amount);
      _refundPaymentApiCall(totalAmount);
    });
  }

  Widget _pendingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor1.toMaterialColor().withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 20.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.pending,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor1.toMaterialColor(),
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

  Widget _preparingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor3.toMaterialColor().withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor3.toMaterialColor(),
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
            color: AppColors.primaryColor1.toMaterialColor().withOpacity(0.1)),
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
                    color: AppColors.primaryColor1.toMaterialColor(),
                    fontFamily: FontConstants.montserratMedium)),
            const SizedBox(
              width: 15.0,
            ),
          ],
        ),
      );

  Widget rightCompletedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor2.toMaterialColor().withOpacity(0.2)),
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
                      color: AppColors.denotiveColor2.toMaterialColor(),
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget rightPendingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: AppColors.denotiveColor1.toMaterialColor().withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 20.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.pending,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor1.toMaterialColor(),
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
            color: AppColors.denotiveColor3.toMaterialColor().withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: AppColors.denotiveColor3.toMaterialColor(),
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
              color:
                  AppColors.primaryColor1.toMaterialColor().withOpacity(0.1)),
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
                        color: AppColors.primaryColor1.toMaterialColor(),
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
    try {
      setState(() {
        _savedOrdersList.clear();
      });
      var result = await SavedOrdersDAO().getOrdersList(eventId);
      if (result != null) {
        setState(() {
          _savedOrdersList.addAll(result);
        });
        setState(() {
          _isApiProcess = false;
        });
      } else {
        _savedOrdersList.clear();
        _isNoRecord = true;
        setState(() {
          _isApiProcess = false;
        });
      }
    } catch (error) {
      debugPrint('adsasdasdasdas');
    }
  }

  Widget _getOrderStatusView(String status, String paymentStatus) {
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return _savedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return _preparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return completedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return completedView();
      } else if (status == StringConstants.orderStatusCancelled) {
        return completedView();
      } else {
        return _pendingView();
      }
    } else {
      return _savedView();
    }
  }

  Widget _getRightOrderStatusView(String status, String paymentStatus,
      dynamic refundAmout, String posPaymentMethod) {
    double toRefund = double.parse(refundAmout);
    if (posPaymentMethod != "CASH") {
      setState(() {
        _refundBool = true;
      });
    } else {
      setState(() {
        _refundBool = false;
      });
    }
    debugPrint('<><><><><><posRefund>${refundAmout}');
    debugPrint(status);
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return _rightSavedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return _rightPreparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return rightCompletedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return completedAndRefundView(toRefund);
      } else if (status == StringConstants.orderStatusCancelled) {
        return completedAndRefundView(toRefund);
      } else {
        debugPrint('>>>>>>>>>>>>>');
        return rightPendingView();
      }
    } else {
      return _rightSavedView();
    }
  }

  getItemByOrderId(String orderId) async {
    setState(() {
      _savedOrderItemList.clear();
    });
    var result = await SavedOrdersItemsDAO().getItemList(orderId: orderId);
    if (result != null) {
      setState(() {
        _savedOrderItemList.addAll(result);
      });
      getAllFoodExtras();
    } else {
      setState(() {
        _savedOrderItemList.clear();
      });
    }
  }

  getAllFoodExtras() async {
    if (_savedOrderItemList.isNotEmpty) {
      _savedOrderExtraItemList.clear();
      for (var item in _savedOrderItemList) {
        await getExtraFoodItems(item.itemId, item.orderId);
      }
    }
  }

  getExtraFoodItems(String itemId, String orderId) async {
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
    // setState(() {
    //   _isApiProcess = false;
    // });

    if (response is GeneralSuccessModel) {
      GeneralSuccessModel responseModel = response;
      CommonWidgets().showSuccessSnackBar(
          message: responseModel.general![0].message ??
              StringConstants.eventCreatedSuccessfully,
          context: context);
      //Refresh the list after refund success
      _getData();
    } else {
      _ordersInsertIntoDb(response);
    }
  }

  updateLastSync() async {
    SessionDAO().insert(Session(
        key: DatabaseKeys.allOrders,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  _ordersInsertIntoDb(AllOrderResponse response) async {
    List<AllOrderResponse> allOrdersList = [];
    setState(() {
      allOrdersList.add(response);
    });

    await _buildOrderListLoop(allOrdersList);
    updateLastSync();
    _getAllSavedOrders(widget.events.id);
  }

  Future<void> _buildOrderListLoop(List<AllOrderResponse> allOrdersList) async {
    for (var event in allOrdersList[0].data!) {
      String customerName = event.firstName != null
          ? "${event.firstName} " + event.lastName!
          : StringConstants.guestCustomer;

      // Insert Order into DB
      await SavedOrdersDAO().insert(SavedOrders(
          eventId: event.eventId!,
          cardId: event.id!,
          orderCode: event.orderCode!,
          orderId: event.id!,
          customerName: customerName,
          phoneNumber: event.phoneNumber.toString(),
          phoneCountryCode: event.phoneNumCountryCode.toString(),
          address1: event.addressLine1.toString(),
          address2: event.addressLine2.toString(),
          country: event.country.toString(),
          state: event.state.toString(),
          city: event.city.toString(),
          zipCode: event.zipCode.toString(),
          orderDate: event.orderDate!,
          tip: event.orderInvoice!.gratuity! /*0.0*/,
          tax_amount: event.orderInvoice!.taxAmount!,
          discount: 0.0,
          foodCost: event.orderInvoice!.foodTotal!,
          totalAmount: event.orderInvoice!.total!,
          grandTotalAmount: event.orderInvoice!.grandTotal!,
          payment: event.paymentStatus!,
          orderStatus: event.orderStatus!,
          deleted: false,
          paymentTerm: event.paymentTerm.toString(),
          refundAmount: _getRefundAmount(event.refundAmount),
          posPaymentMethod: event.posPaymentMethod.toString()));
      await _buildOrderItemListLoop(event);
    }
  }

  Future<void> _buildOrderItemListLoop(PlaceOrderResponseModel event) async {
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
        for (var extraItemMappingList in item.foodExtraItemMappingList!) {
          if (extraItemMappingList.orderFoodExtraItemDetailDto != null) {
            for (var extraItem
                in extraItemMappingList.orderFoodExtraItemDetailDto!) {
              await SavedOrdersExtraItemsDAO().insert(SavedOrdersExtraItems(
                  orderId: event.id!,
                  itemId: item.itemId.toString(),
                  extraFoodItemId: extraItem.id!,
                  extraFoodItemName: extraItem.name!,
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
  }

  _getRefundAmount(dynamic refundAmount) {
    if (refundAmount != null) {
      return refundAmount.toString();
    } else {
      return "0.00";
    }
  }
}

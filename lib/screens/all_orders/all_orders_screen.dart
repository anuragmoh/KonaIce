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
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

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
  bool isItemClick = true;
  List<SavedOrders> savedOrdersList = [];
  List<SavedOrdersItem> savedOrderItemList = [];
  List<SavedOrdersExtraItems> savedOrderExtraItemList = [];
  late AllOrderPresenter allOrderPresenter;
  List<AllOrderResponse> allOrdersList = [];
  int selectedRow = -1;
  bool isApiProcess = false;
  int countOffSet = 0;
  bool refundBool = false;

  _AllOrdersScreenState() {
    allOrderPresenter = AllOrderPresenter(this);
  }

  getSyncOrders(
      {required int lastSync,
      required String orderStatus,
      required String eventId,
      required int offset}) {
    setState(() {
      isApiProcess = true;
    });
    allOrderPresenter.getSyncOrder(
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

  getData() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        getLastSync().then((value) {
          getSyncOrders(
              lastSync: value,
              orderStatus: "",
              eventId: widget.events.id,
              offset: countOffSet);
        });
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
        getAllSavedOrders(widget.events.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: savedOrdersList.isNotEmpty
            ? Column(
                children: [
                  // topWidget(),
                  Expanded(child: bodyWidget()),
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
            color: getMaterialColor(AppColors.primaryColor1),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0))),
      );

  Widget bodyWidget() => Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: bodyWidgetComponent(),
      );

  Widget bodyWidgetComponent() => Row(children: [
        leftSideWidget(),
        Visibility(visible: selectedRow != -1, child: rightSideWidget()),
      ]);

  Widget bottomWidget() => Container(
        height: 43.0,
        decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor1),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        child: Align(
            alignment: Alignment.topRight, child: componentBottomWidget()),
      );

  Widget componentBottomWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 35.0),
        child: Image.asset(AssetsConstants.switchAccount,
            width: 30.0, height: 30.0),
      );

  Widget leftSideWidget() => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        topComponent(),
        Expanded(child: tableHeadRow()),
      ]));

  Widget topComponent() => Padding(
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
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold)),
          ]),
          Visibility(
            visible: false,
            child: Container(
                decoration: BoxDecoration(
                  color: getMaterialColor(AppColors.whiteColor),
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
                            color: getMaterialColor(AppColors.primaryColor1),
                            fontFamily: FontConstants.montserratMedium)),
                  ]),
                )),
          ),
        ]),
      );

  Widget tableHeadRow() => Padding(
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
                      DataColumn(
                        label: CommonWidgets().textView(
                            StringConstants.customerName,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold)),
                      ),
                      DataColumn(
                        label: CommonWidgets().textView(
                            StringConstants.date,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold)),
                      ),
                      DataColumn(
                        label: CommonWidgets().textView(
                            StringConstants.payment,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold)),
                      ),
                      DataColumn(
                        label: CommonWidgets().textView(
                            StringConstants.price,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold)),
                      ),
                      DataColumn(
                        label: CommonWidgets().textView(
                            StringConstants.status,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold)),
                      ),
                    ],
                    rows: List.generate(savedOrdersList.length,
                        (index) => _getDataRow(savedOrdersList[index], index)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  DataRow _getDataRow(SavedOrders savedOrders, int index) {
    return DataRow(
        onSelectChanged: (value) {
          setState(() {
            selectedRow = index;
          });
          getItemByOrderId(savedOrders.orderId);
        },
        color: selectedRow == index
            ? MaterialStateProperty.all(Colors.white)
            : null,
        cells: <DataCell>[
          DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circularImage(AssetsConstants.defaultProfileImage),
                const SizedBox(width: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().textView(
                        savedOrders.customerName,
                        StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor4),
                            fontFamily: FontConstants.montserratBold)),
                    CommonWidgets().textView(
                        savedOrders.orderCode,
                        StyleConstants.customTextStyle(
                            fontSize: 10.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratMedium))
                  ],
                ),
              ])),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonWidgets().textView(
                  savedOrders.getOrderDate(),
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratMedium)),
              CommonWidgets().textView(
                  savedOrders.getOrderDateTime(),
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratMedium))
            ],
          )),
          DataCell(
            CommonWidgets().textView(
                savedOrders.payment,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          DataCell(
            CommonWidgets().textView(
                '\$ ${savedOrders.totalAmount}',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratMedium)),
          ),
          DataCell(
              getOrderStatusView(savedOrders.orderStatus, savedOrders.payment))
        ]);
  }

  Widget circularImage(String imageUrl) => Container(
        width: 4.55 * SizeConfig.imageSizeMultiplier,
        height: 4.55 * SizeConfig.imageSizeMultiplier,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(imageUrl))),
      );

  Widget rightSideWidget() => Padding(
        padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.307,
          decoration: BoxDecoration(
              color: getMaterialColor(AppColors.whiteColor),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 19.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: selectedRow != -1 ? true : false,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 11.0),
                        child: CommonWidgets().textView(
                            StringConstants.orderDetails,
                            StyleConstants.customTextStyle(
                                fontSize: 22.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold))),
                  ),
                  Visibility(
                      visible: selectedRow != -1 ? true : false,
                      child: customerNameWidget(
                          customerName: selectedRow != -1
                              ? savedOrdersList[selectedRow].customerName
                              : 'NA')),
                  const SizedBox(height: 7.0),
                  Visibility(
                    visible: selectedRow != -1 ? true : false,
                    child: orderDetailsWidget(
                        orderId: selectedRow != -1
                            ? savedOrdersList[selectedRow].orderId
                            : 'NA',
                        orderDate: selectedRow != -1
                            ? savedOrdersList[selectedRow].getOrderDateTime()
                            : "NA"),
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: selectedRow != -1,
                    child: customerDetailsComponent(
                        eventName: widget.events.getEventName(),
                        email: selectedRow != -1
                            ? savedOrdersList[selectedRow].email
                            : StringExtension.empty(),
                        storeAddress: widget.events.getEventAddress(),
                        phone: selectedRow != -1
                            ? savedOrdersList[selectedRow].phoneCountryCode +
                                savedOrdersList[selectedRow].phoneNumber
                            : StringExtension.empty()),
                  ),
                  const SizedBox(height: 35.0),
                  Visibility(
                    visible: selectedRow != -1,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        isItemClick = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: CommonWidgets().textView(
                                          StringConstants.items,
                                          StyleConstants.customTextStyle(
                                              fontSize: 12.0,
                                              color: getMaterialColor(
                                                  AppColors.textColor1),
                                              fontFamily: FontConstants
                                                  .montserratBold)),
                                    )),
                                const SizedBox(
                                  height: 11.0,
                                ),
                                Container(
                                  color: getMaterialColor(isItemClick
                                      ? AppColors.primaryColor2
                                      : AppColors.whiteColor),
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
                                          isItemClick = false;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: CommonWidgets().textView(
                                            StringConstants.inProcess,
                                            StyleConstants.customTextStyle(
                                                fontSize: 12.0,
                                                color: getMaterialColor(
                                                    AppColors.textColor1),
                                                fontFamily: FontConstants
                                                    .montserratBold)),
                                      )),
                                  const SizedBox(
                                    height: 11.0,
                                  ),
                                  Container(
                                    color: getMaterialColor(isItemClick
                                        ? AppColors.whiteColor
                                        : AppColors.primaryColor2),
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
                  Visibility(
                    visible: selectedRow != -1,
                    child: Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        color: getMaterialColor(AppColors.whiteColor),
                        child: isItemClick ? itemView() : inProgressView(),
                      ),
                    )),
                  ),
                  Visibility(
                    visible: selectedRow != -1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 29.0, top: 10.0),
                      child: getRightOrderStatusView(
                          selectedRow != -1
                              ? savedOrdersList[selectedRow].orderStatus
                              : "NA",
                          selectedRow != -1
                              ? savedOrdersList[selectedRow].payment
                              : "NA",
                          selectedRow != -1
                              ? savedOrdersList[selectedRow].refundAmount
                              : "NA",
                          selectedRow != -1
                              ? savedOrdersList[selectedRow].paymentTerm
                              : "NA"),
                    ),
                  ),
                ]),
          ),
        ),
      );

  // customer Name
  Widget customerNameWidget({required String customerName}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CommonWidgets().textView(
            '${StringConstants.customerName} - ',
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratRegular)),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold))),
      ]);

  // customer Details
  Widget customerDetailsComponent(
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
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: getMaterialColor(AppColors.textColor2),
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
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        phone,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: getMaterialColor(AppColors.textColor2),
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
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratRegular)),
                Expanded(
                    child: CommonWidgets().textView(
                        eventName,
                        StyleConstants.customTextStyle(
                            fontSize: 9.0,
                            color: getMaterialColor(AppColors.textColor2),
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
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
              Expanded(
                  child: CommonWidgets().textView(
                      storeAddress,
                      StyleConstants.customTextStyle(
                          fontSize: 9.0,
                          color: getMaterialColor(AppColors.textColor2),
                          fontFamily: FontConstants.montserratMedium))),
            ]),
          ),
        ],
      );

  // Widget orderDetails
  Widget orderDetailsWidget(
          {required String orderId, required String orderDate}) =>
      Column(children: [
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderId,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular)),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium)),
        ]),
      ]);

  Widget itemView() => Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: savedOrderItemList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemViewListItem(
                  savedOrderItemList[index].itemName,
                  savedOrderItemList[index].quantity,
                  savedOrderItemList[index].totalPrice.toDouble());
            }),
      ]);

  Widget itemViewListItem(String itemName, int quantity, double price) =>
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 6,
              child: CommonWidgets().textView(
                  itemName,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "${StringConstants.qty} - $quantity",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${price.toStringAsFixed(2)}",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
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
                return itemViewListItem('Kiddie', 7, 20);
              }),
        ],
      );

  Widget completedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor2).withOpacity(0.2)),
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
                      color: getMaterialColor(AppColors.denotiveColor2),
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget completedAndRefundView(dynamic refundAmout) => Column(
        children: [
          completedView(),
          const SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: refundBool ? true : false,
            child: GestureDetector(
              onTap: onTapRefundButton,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                    color: refundBool
                        ? getMaterialColor(AppColors.denotiveColor2)
                            .withOpacity(0.2)
                        : getMaterialColor(AppColors.denotiveColor4)
                            .withOpacity(0.2)),
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
                                  color: getMaterialColor(
                                      AppColors.denotiveColor2),
                                  fontFamily: FontConstants.montserratMedium))
                          : CommonWidgets().textView(
                              StringConstants.refunded,
                              StyleConstants.customTextStyle(
                                  fontSize: 9.0,
                                  color: getMaterialColor(AppColors.textColor1),
                                  fontFamily: FontConstants.montserratMedium)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget pendingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor1).withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 20.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.pending,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor1),
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

  Widget preparingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor3).withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor3),
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

  Widget savedView() => Container(
        height: 25.0,
        width: 80.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.primaryColor1).withOpacity(0.1)),
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
                    color: getMaterialColor(AppColors.primaryColor1),
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
            color: getMaterialColor(AppColors.denotiveColor2).withOpacity(0.2)),
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
                      color: getMaterialColor(AppColors.denotiveColor2),
                      fontFamily: FontConstants.montserratMedium)),
            ],
          ),
        ),
      );

  Widget rightPendingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor1).withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 20.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.pending,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor1),
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

  Widget rightPreparingView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor3).withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.preparing,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor3),
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

  Widget rightSavedView() => GestureDetector(
        onTap: onTapResumeButton,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.5)),
              color:
                  getMaterialColor(AppColors.primaryColor1).withOpacity(0.1)),
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
                        color: getMaterialColor(AppColors.primaryColor1),
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
          ),
        ),
      );

  //Action Events
  onTapResumeButton() {
    widget.onBackTap(savedOrdersList[selectedRow], savedOrderItemList,
        savedOrderExtraItemList);
  }

  onTapRefundButton() {
    showDialog(
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return RefundPopup(amount: savedOrdersList[selectedRow].totalAmount);
        }).then((value) {
      String amount = value['totalAmount'];
      double totalAmount = double.parse(amount);
      refundPaymentApiCall(totalAmount);
    });
  }

  //Refund Payment Api call
  refundPaymentApiCall(double totalAmount) {
    RefundPaymentModel refundPaymentModel = RefundPaymentModel();
    refundPaymentModel.refundAmount = totalAmount;
    setState(() {
      isApiProcess = true;
    });
    allOrderPresenter.refundPayment(
        savedOrdersList[selectedRow].orderId, refundPaymentModel);
  }

  // Get data from local db function start from here
  getAllSavedOrders(String eventId) async {
    setState(() {
      savedOrdersList.clear();
    });
    var result = await SavedOrdersDAO().getOrdersList(eventId);
    if (result != null) {
      setState(() {
        savedOrdersList.addAll(result);
      });
    } else {
      savedOrdersList.clear();
    }
  }

  Widget getOrderStatusView(String status, String paymentStatus) {
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return savedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return preparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return completedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return completedView();
      } else {
        return inProgressView();
      }
    } else {
      return savedView();
    }
  }

  Widget getRightOrderStatusView(String status, String paymentStatus,
      dynamic refundAmout, String paymentTerm) {
    refundAmout ??= 0;
    if (paymentTerm == "menu") {
      refundBool = true;
    }
    debugPrint('<><><><><><>$refundAmout');
    debugPrint(status);
    if (paymentStatus == StringConstants.paymentStatusSuccess) {
      if (status == StringConstants.orderStatusSaved) {
        return rightSavedView();
      } else if (status == StringConstants.orderStatusPreparing) {
        return rightPreparingView();
      } else if (status == StringConstants.orderStatusNew) {
        return rightCompletedView();
      } else if (status == StringConstants.orderStatusCompleted) {
        return completedAndRefundView(refundAmout);
      } else {
        debugPrint('>>>>>>>>>>>>>');
        return rightPendingView();
      }
    } else {
      return rightSavedView();
    }
  }

  getItemByOrderId(String orderId) async {
    setState(() {
      savedOrderItemList.clear();
    });
    var result = await SavedOrdersItemsDAO().getItemList(orderId: orderId);
    if (result != null) {
      setState(() {
        savedOrderItemList.addAll(result);
      });
      getAllFoodExtras();
    } else {
      setState(() {
        savedOrderItemList.clear();
      });
    }
  }

  getAllFoodExtras() async {
    if (savedOrderItemList.isNotEmpty) {
      savedOrderExtraItemList.clear();
      for (var item in savedOrderItemList) {
        await getExtraFoodItems(item.itemId, item.orderId);
      }
    }
  }

  getExtraFoodItems(String itemId, String orderId) async {
    var result = await SavedOrdersExtraItemsDAO()
        .getExtraItemList(itemId: itemId, orderId: orderId);
    if (result != null) {
      setState(() {
        savedOrderExtraItemList.addAll(result);
      });
    }
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess = false;
    });

    if (response is GeneralSuccessModel) {
      GeneralSuccessModel responseModel = response;
      CommonWidgets().showSuccessSnackBar(
          message: responseModel.general![0].message ??
              StringConstants.eventCreatedSuccessfully,
          context: context);
    } else {
      ordersInsertIntoDb(response);
    }
  }

  updateLastSync() async {
    SessionDAO().insert(Session(
        key: DatabaseKeys.allOrders,
        value: DateTime.now().millisecondsSinceEpoch.toString()));
  }

  ordersInsertIntoDb(AllOrderResponse response) async {
    List<AllOrderResponse> allOrdersList = [];
    setState(() {
      allOrdersList.add(response);
    });

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
    }
    updateLastSync();
    getAllSavedOrders(widget.events.id);
  }
}

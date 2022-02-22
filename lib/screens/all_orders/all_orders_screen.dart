import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_items.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

 class AllOrdersScreen extends StatefulWidget {
   final Function(SavedOrders, List<SavedOrdersItem>, List<SavedOrdersExtraItems>) onBackTap;
  final Events events;
   const AllOrdersScreen({Key? key, required this.onBackTap, required this.events}) : super(key: key);

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  bool isItemClick = true;
  List<SavedOrders> savedOrdersList= [];
  List<SavedOrdersItem> savedOrderItemList = [];
  List<SavedOrdersExtraItems> savedOrderExtraItemList = [];

  int selectedRow = -1;


  @override
  void initState() {
    super.initState();
    getAllSavedOrders(widget.events.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: savedOrdersList.isNotEmpty ? Column(
          children: [
            // topWidget(),
            Expanded(child: bodyWidget()),
            // bottomWidget(),
          ],
        ) :
        const Align(
          alignment: Alignment.center,
            child: Text(StringConstants.noOrdersToDisplay)),
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
        Visibility(
          visible: selectedRow != -1,
            child: rightSideWidget()),
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
          child: Column(children: [
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
          Container(
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
        ]),
      );

  Widget tableHeadRow() => Padding(
        padding: const EdgeInsets.only(left: 21.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
                  child: DataTable(
                    sortAscending: false,
                    showCheckboxColumn: false,
                    dataRowHeight: 7.51 * SizeConfig.heightSizeMultiplier,
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
                            StringConstants.orderId,
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
                    rows: List.generate(savedOrdersList.length, (index) => _getDataRow(savedOrdersList[index],index)),
                    // [
                    //   DataRow(
                    //       selected: true,
                    //       color: MaterialStateProperty.all(Colors.white),
                    //       cells: [
                    //         DataCell(Row(children: [
                    //           circularImage(
                    //               'https://picsum.photos/id/237/200/300'),
                    //           const SizedBox(width: 8.0),
                    //           CommonWidgets().textView(
                    //               'Nicholas Gibson',
                    //               StyleConstants.customTextStyle(
                    //                   fontSize: 12.0,
                    //                   color: getMaterialColor(
                    //                       AppColors.textColor1),
                    //                   fontFamily:
                    //                       FontConstants.montserratMedium)),
                    //         ])),
                    //         DataCell(
                    //           CommonWidgets().textView(
                    //               '25636564',
                    //               StyleConstants.customTextStyle(
                    //                   fontSize: 12.0,
                    //                   color: getMaterialColor(
                    //                       AppColors.textColor1),
                    //                   fontFamily:
                    //                       FontConstants.montserratMedium)),
                    //         ),
                    //         DataCell(CommonWidgets().textView(
                    //             '25 Nov 2021',
                    //             StyleConstants.customTextStyle(
                    //                 fontSize: 12.0,
                    //                 color:
                    //                     getMaterialColor(AppColors.textColor1),
                    //                 fontFamily:
                    //                     FontConstants.montserratMedium))),
                    //         DataCell(
                    //           CommonWidgets().textView(
                    //               'QR Code',
                    //               StyleConstants.customTextStyle(
                    //                   fontSize: 12.0,
                    //                   color: getMaterialColor(
                    //                       AppColors.textColor1),
                    //                   fontFamily:
                    //                       FontConstants.montserratMedium)),
                    //         ),
                    //         DataCell(
                    //           CommonWidgets().textView(
                    //               '\$35.0',
                    //               StyleConstants.customTextStyle(
                    //                   fontSize: 12.0,
                    //                   color: getMaterialColor(
                    //                       AppColors.textColor1),
                    //                   fontFamily:
                    //                       FontConstants.montserratMedium)),
                    //         ),
                    //         DataCell(completedView())
                    //       ]),
                    //
                    // ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget circularImage(String imageUrl) => Container(
        width: 4.55 * SizeConfig.imageSizeMultiplier,
        height: 4.55 * SizeConfig.imageSizeMultiplier,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(imageUrl))),
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
                    visible: selectedRow !=-1 ? true : false,
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
                      visible: selectedRow !=-1 ? true : false,
                      child: customerNameWidget(customerName: selectedRow !=-1 ? savedOrdersList[selectedRow].customerName : 'NA')),
                  const SizedBox(height: 7.0),
                  Visibility(
                    visible: selectedRow !=-1 ? true : false,
                    child: orderDetailsWidget(
                        orderId: selectedRow !=-1 ? savedOrdersList[selectedRow].orderId : 'NA', orderDate: selectedRow !=-1 ? savedOrdersList[selectedRow].getOrderDateTime() : "NA"),
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: selectedRow !=-1,
                    child: customerDetailsComponent(
                        eventName: widget.events.getEventName(),
                        email: selectedRow !=-1 ? savedOrdersList[selectedRow].email : StringExtension.empty(),
                        storeAddress: widget.events.getEventAddress(),
                        phone: selectedRow !=-1 ? savedOrdersList[selectedRow].phoneCountryCode + savedOrdersList[selectedRow].phoneNumber : StringExtension.empty()),
                  ),
                  const SizedBox(height: 35.0),
                  Visibility(
                    visible: selectedRow !=-1,
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
                                              fontFamily:
                                                  FontConstants.montserratBold)),
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
                            Column(
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
                                              fontFamily:
                                                  FontConstants.montserratBold)),
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
                    visible: selectedRow !=-1,
                    child: Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        color: getMaterialColor(AppColors.whiteColor),
                        child: isItemClick ? itemView() : inProgressView(),
                      ),
                    )),
                  ),
                  Visibility(
                    visible: selectedRow !=-1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 29.0, top: 10.0),
                      child: getRightOrderStatusView(selectedRow !=-1 ? savedOrdersList[selectedRow].orderStatus :"NA"),
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
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              return itemViewListItem(savedOrderItemList[index].itemName, savedOrderItemList[index].quantity);
            }),
      ]);

  Widget itemViewListItem(String itemName, int quantity) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonWidgets().textView(
                itemName,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            CommonWidgets().textView(
                "${StringConstants.qty} - $quantity",
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular))
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
                return itemViewListItem('Kiddie', 7);
              }),
        ],
      );

  Widget completedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor2).withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 7.0, bottom: 7.0, right: 12.0, left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.completed,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor2),
                      fontFamily: FontConstants.montserratMedium)),
              const SizedBox(
                width: 10.0,
              ),
              CommonWidgets().image(
                  image: AssetsConstants.greenTriangle, width: 6.0, height: 6.0)
            ],
          ),
        ),
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
              width: 10.0,
            ),
            CommonWidgets().image(
                image: AssetsConstants.blueTriangle, width: 6.0, height: 6.0),
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
              top: 11.0, bottom: 11.0, right: 19.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonWidgets().textView(
                  StringConstants.completed,
                  StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(AppColors.denotiveColor2),
                      fontFamily: FontConstants.montserratMedium)),
              CommonWidgets().image(
                  image: AssetsConstants.greenTriangle,
                  width: 12.0,
                  height: 9.0)
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

  // Widget rightSavedView() => Container(
  //       height: 25.0,
  //       width: 80.0,
  //       decoration: BoxDecoration(
  //           borderRadius: const BorderRadius.all(Radius.circular(12.5)),
  //           color: getMaterialColor(AppColors.primaryColor1).withOpacity(0.1)),
  //       child: Row(
  //         children: [
  //           const SizedBox(
  //             width: 15.0,
  //           ),
  //           CommonWidgets().textView(
  //               StringConstants.saved,
  //               StyleConstants.customTextStyle(
  //                   fontSize: 9.0,
  //                   color: getMaterialColor(AppColors.primaryColor1),
  //                   fontFamily: FontConstants.montserratMedium)),
  //           const SizedBox(
  //             width: 10.0,
  //           ),
  //           CommonWidgets().image(
  //               image: AssetsConstants.blueTriangle, width: 6.0, height: 6.0),
  //           const SizedBox(
  //             width: 15.0,
  //           ),
  //         ],
  //       ),
  //     );

  Widget rightSavedView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.primaryColor1).withOpacity(0.1)),
    child: GestureDetector(
      onTap: onTapResumeButton,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 11.0, bottom: 11.0, right: 19.0, left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgets().textView(
                StringConstants.resume,
                StyleConstants.customTextStyle(
                    fontSize: 16.0,
                    color: getMaterialColor(AppColors.primaryColor1),
                    fontFamily: FontConstants.montserratBold)),
            // CommonWidgets().image(
            //     image: AssetsConstants.greenTriangle,
            //     width: 12.0,
            //     height: 9.0)
          ],
        ),
      ),
    ),
  );


  //Action Events
  onTapResumeButton() {
    widget.onBackTap(savedOrdersList[selectedRow], savedOrderItemList, savedOrderExtraItemList);
  }

  // Get data from local db function start from here
  getAllSavedOrders(String eventId)async{
    debugPrint('EventID------>$eventId');
    var result = await SavedOrdersDAO().getOrdersList(eventId);
    if(result !=null){
      setState(() {
        savedOrdersList.addAll(result);
      });
    }else{
      savedOrdersList.clear();
    }

  }

  DataRow _getDataRow(SavedOrders savedOrders,int index){
    return DataRow(
      onSelectChanged: (value){
        setState(() {
          selectedRow = index;
        });
      //  if (selectedRow != index) {
          getItemByOrderId(savedOrders.orderId);
     //   }
      },
        color: selectedRow==index ? MaterialStateProperty.all(Colors.white): null,
      cells: <DataCell>[
        DataCell(Row(children: [
          circularImage(
              'https://picsum.photos/id/237/200/300'),
          const SizedBox(width: 8.0),
          CommonWidgets().textView(
              savedOrders.customerName,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(
                      AppColors.textColor1),
                  fontFamily:
                  FontConstants.montserratMedium)),
        ])),
        DataCell(
          CommonWidgets().textView(
              savedOrders.orderId,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(
                      AppColors.textColor1),
                  fontFamily:
                  FontConstants.montserratMedium)),
        ),
        DataCell(CommonWidgets().textView(
            savedOrders.getOrderDate(),
            StyleConstants.customTextStyle(
                fontSize: 12.0,
                color:
                getMaterialColor(AppColors.textColor1),
                fontFamily:
                FontConstants.montserratMedium))),
        DataCell(
          CommonWidgets().textView(
              savedOrders.payment,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(
                      AppColors.textColor1),
                  fontFamily:
                  FontConstants.montserratMedium)),
        ),
        DataCell(
          CommonWidgets().textView(
              '\$ ${savedOrders.totalAmount}',
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(
                      AppColors.textColor1),
                  fontFamily:
                  FontConstants.montserratMedium)),
        ),
        DataCell(getOrderStatusView(savedOrders.orderStatus))
      ]
    );
  }
  Widget getOrderStatusView(String status){
    if(status == "saved"){
      return savedView();
    }else if(status == "preparing"){
      return preparingView();
    }else if(status=="completed"){
      return completedView();
    }else{
      return inProgressView() ;
    }
  }
  Widget getRightOrderStatusView(String status){
    if(status == "saved"){
      return rightSavedView();
    }else if(status == "preparing"){
      return rightPreparingView();
    }else if(status=="completed"){
      return rightCompletedView();
    }else{
      return rightPendingView() ;
    }
  }

  getItemByOrderId(String orderId) async{
    setState(() {
      savedOrderItemList.clear();
    });
    var result = await SavedOrdersItemsDAO().getItemList(orderId: orderId);
    if(result !=null){
      setState(() {
        savedOrderItemList.addAll(result);
      });
    }else{
      setState(() {
        savedOrderItemList.clear();
      });
    }
  }

  getExtraFoodItems(String itemId,String orderId)async{
    var result = await SavedOrdersExtraItemsDAO().getExtraItemList(itemId: itemId, orderId: orderId);
    if(result !=null){
      setState(() {
        savedOrderExtraItemList.addAll(result);
      });
    }else{
      setState(() {
        savedOrderExtraItemList.clear();
      });
    }
  }
}

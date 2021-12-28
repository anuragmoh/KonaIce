import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {

  bool isItemClick = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          children: [
            // topWidget(),
            Expanded(child: bodyWidget()),
            // bottomWidget(),
          ],
        ),
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
        rightSideWidget(),
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

  Widget topComponent() =>
      Padding(
        padding: const EdgeInsets.only(left: 18.8,top: 20.9,right: 17.0,bottom: 21.1),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            CommonWidgets().image(
                image: AssetsConstants.backArrow, width: 25.0, height: 25.0),
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
                      image: AssetsConstants.filter, width: 24.0, height: 25.0),
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

  Widget tableHeadRow()=> Padding(
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
                dataRowHeight: 77.0,
                columns: [
                  DataColumn(label:CommonWidgets().textView(StringConstants.customerName, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                  DataColumn(label: CommonWidgets().textView(StringConstants.orderId, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                  DataColumn(label: CommonWidgets().textView(StringConstants.date, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                  DataColumn(label: CommonWidgets().textView(StringConstants.payment, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                  DataColumn(label: CommonWidgets().textView(StringConstants.price, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                  DataColumn(label: CommonWidgets().textView(StringConstants.status, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),),
                ],
                rows: [
                  DataRow(
                      selected: true,
                      color: MaterialStateProperty.all(Colors.white),
                      cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(completedView())
                  ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(pendingView()) ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(preparingView())                  ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(savedView())                  ]),
                  DataRow(
                      selected: true,
                      color: MaterialStateProperty.all(Colors.white),
                      cells: [
                        DataCell(Row(children: [
                          circularImage('https://picsum.photos/id/237/200/300'),
                          const SizedBox(width: 8.0),
                          CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                        ])),
                        DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                        DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                        DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                        DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                        DataCell(completedView())
                      ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(pendingView()) ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(preparingView())                  ]),
                  DataRow(cells: [
                    DataCell(Row(children: [
                      circularImage('https://picsum.photos/id/237/200/300'),
                      const SizedBox(width: 8.0),
                      CommonWidgets().textView('Nicholas Gibson', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
                    ])),
                    DataCell(CommonWidgets().textView('25636564', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('25 Nov 2021', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium))),
                    DataCell(CommonWidgets().textView('QR Code', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(CommonWidgets().textView('\$35.0', StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),),
                    DataCell(savedView())                  ]),


                ],

              ),
            ),


          ],
        ),
      ),
    ),
  );

  Widget circularImage(String imageUrl)=> Container(
    width: 35.0,
    height: 35.0,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl)
        )
    ),
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
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 11.0),
                      child: CommonWidgets().textView(
                          StringConstants.orderDetails,
                          StyleConstants.customTextStyle(
                              fontSize: 22.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratBold))),
                  customerNameWidget(customerName: 'Nicholas Gibson'),
                  const SizedBox(height: 7.0),
                  orderDetailsWidget(
                      orderId: 'F001587', orderDate: '03/09/2021 at 06:45 PM'),
                  const SizedBox(height: 8.0),
                  customerDetailsComponent(
                      street: '34 View City: Dublin, NH Zip: 43766',
                      email: 'nic.gibson@mail.com',
                      storeAddress: '7 Gullet City, San Dimas, NY 54356-1822',
                      phone: '+1 528 6568 220'),
                  const SizedBox(height: 35.0),
                 Stack(children: [

                   Row(children: [
                     Column(children: [
                       InkWell(
                           onTap: (){
                             setState(() {
                               isItemClick = true;
                             });
                           },
                           child: CommonWidgets().textView(StringConstants.items, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold))),
                       const SizedBox(height: 11.0,),
                       Container(
                         color: getMaterialColor(isItemClick ? AppColors.primaryColor2 : AppColors.whiteColor),
                         width: 45.0,
                         height: 3.0,
                       ),
                     ],),
                     const SizedBox(width: 53.0,),
                     Column(
                       children: [
                         InkWell(
                             onTap: (){
                               setState(() {
                                 isItemClick = false;
                               });
                             },
                             child: CommonWidgets().textView(StringConstants.inProcess, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold))),
                         const SizedBox(height: 11.0,),
                         Container(
                           color: getMaterialColor(isItemClick ? AppColors.whiteColor : AppColors.primaryColor2),
                           width: 90.0,
                           height: 3.0,
                         ),
                       ],
                     ),
                   ],),
                     const SizedBox(height: 35.5,),
                     const Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child:  Divider(thickness: 1.0,),
                      ),
                    ),

                 ],),

                  const SizedBox(height: 10.0),
                  Expanded(child: SingleChildScrollView(
                    child: Container(
                      color: getMaterialColor(AppColors.whiteColor),
                      child: isItemClick ? itemView() : inProgressView(),),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 29.0,top: 10.0),
                    child: rightCompletedView(),
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
          {required String street,
          required String email,
          required String storeAddress,
          required String phone}) =>
      Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.street}: ',
                StyleConstants.customTextStyle(
                    fontSize: 9.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratRegular)),
            Expanded(
                child: CommonWidgets().textView(
                    street,
                    StyleConstants.customTextStyle(
                        fontSize: 9.0,
                        color: getMaterialColor(AppColors.textColor2),
                        fontFamily: FontConstants.montserratMedium))),
          ]),
          const SizedBox(height: 8.0),
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
          const SizedBox(height: 8.0),
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
          const SizedBox(height: 8.0),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.storeAddress}: ',
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

  Widget itemView()=>Column(children: [
    ListView.builder(
       shrinkWrap: true,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
      return itemViewListItem('Kiddie',7);
    }),
  ]);
  Widget itemViewListItem(String itemName,int quantity)=> Column(
    children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        CommonWidgets().textView(itemName, StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratRegular)),
        CommonWidgets().textView("${StringConstants.qty} - $quantity", StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratRegular))
      ]),
      const SizedBox(height: 20.0),
    ],
  );
  Widget inProgressView()=> Column(children: [
    ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return itemViewListItem('Kiddie',7);
        }),
  ],);

  Widget completedView() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.5)),
            color: getMaterialColor(AppColors.denotiveColor2).withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.0,bottom: 7.0,right: 12.0,left: 16.0),
          child: Row(
            children: [
              CommonWidgets().textView(
                  StringConstants.completed,
                  StyleConstants.customTextStyle(
                      fontSize: 9.0,
                      color: getMaterialColor(AppColors.denotiveColor2),
                      fontFamily: FontConstants.montserratMedium)),
              const SizedBox(width: 10.0,),
              CommonWidgets().image(image: AssetsConstants.greenTriangle, width: 6.0, height: 6.0)
            ],
          ),
        ),
      );
  Widget pendingView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.denotiveColor1).withOpacity(0.1)),
    child: Padding(
      padding: const EdgeInsets.only(top: 7.0,bottom: 7.0,right: 12.0,left: 20.0),
      child: Row(
        children: [
          CommonWidgets().textView(
              StringConstants.pending,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.denotiveColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(width: 10.0,),
          CommonWidgets().image(image: AssetsConstants.redTriangle, width: 6.0, height: 6.0)
        ],
      ),
    ),
  );
  Widget preparingView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.denotiveColor3).withOpacity(0.1)),
    child: Padding(
      padding: const EdgeInsets.only(top: 7.0,bottom: 7.0,right: 12.0,left: 16.0),
      child: Row(
        children: [
          CommonWidgets().textView(
              StringConstants.preparing,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.denotiveColor3),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(width: 10.0,),
          CommonWidgets().image(image: AssetsConstants.yellowTriangle, width: 6.0, height: 6.0)
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
        const SizedBox(width: 15.0,),
        CommonWidgets().textView(
            StringConstants.saved,
            StyleConstants.customTextStyle(
                fontSize: 9.0,
                color: getMaterialColor(AppColors.primaryColor1),
                fontFamily: FontConstants.montserratMedium)),
        const SizedBox(width: 10.0,),
        CommonWidgets().image(image: AssetsConstants.blueTriangle, width: 6.0, height: 6.0),
        const SizedBox(width: 15.0,),
      ],
    ),
  );


  Widget rightCompletedView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.denotiveColor2).withOpacity(0.2)),
    child: Padding(
      padding: const EdgeInsets.only(top: 11.0,bottom: 11.0,right: 19.0,left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().textView(
              StringConstants.completed,
              StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.denotiveColor2),
                  fontFamily: FontConstants.montserratMedium)),
          CommonWidgets().image(image: AssetsConstants.greenTriangle, width: 12.0, height: 9.0)
        ],
      ),
    ),
  );
  Widget rightPendingView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.denotiveColor1).withOpacity(0.1)),
    child: Padding(
      padding: const EdgeInsets.only(top: 7.0,bottom: 7.0,right: 12.0,left: 20.0),
      child: Row(
        children: [
          CommonWidgets().textView(
              StringConstants.pending,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.denotiveColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(width: 10.0,),
          CommonWidgets().image(image: AssetsConstants.redTriangle, width: 6.0, height: 6.0)
        ],
      ),
    ),
  );
  Widget rightPreparingView() => Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.denotiveColor3).withOpacity(0.1)),
    child: Padding(
      padding: const EdgeInsets.only(top: 7.0,bottom: 7.0,right: 12.0,left: 16.0),
      child: Row(
        children: [
          CommonWidgets().textView(
              StringConstants.preparing,
              StyleConstants.customTextStyle(
                  fontSize: 9.0,
                  color: getMaterialColor(AppColors.denotiveColor3),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(width: 10.0,),
          CommonWidgets().image(image: AssetsConstants.yellowTriangle, width: 6.0, height: 6.0)
        ],
      ),
    ),
  );
  Widget rightSavedView() => Container(
    height: 25.0,
    width: 80.0,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
        color: getMaterialColor(AppColors.primaryColor1).withOpacity(0.1)),
    child: Row(
      children: [
        const SizedBox(width: 15.0,),
        CommonWidgets().textView(
            StringConstants.saved,
            StyleConstants.customTextStyle(
                fontSize: 9.0,
                color: getMaterialColor(AppColors.primaryColor1),
                fontFamily: FontConstants.montserratMedium)),
        const SizedBox(width: 10.0,),
        CommonWidgets().image(image: AssetsConstants.blueTriangle, width: 6.0, height: 6.0),
        const SizedBox(width: 15.0,),
      ],
    ),
  );

}

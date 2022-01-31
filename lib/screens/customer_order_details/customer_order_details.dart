import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class CustomerOrderDetails extends StatefulWidget {
  const CustomerOrderDetails({Key? key}) : super(key: key);

  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3),
        child: Column(
          children: [
            CommonWidgets().topEmptyBar(),
            Expanded(child: bodyWidget()),
            CommonWidgets().bottomEmptyBar(),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() => Container(
    color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
    child: bodyWidgetComponent(),
  );
  Widget bodyWidgetComponent() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 237.0, vertical: 20.0),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.whiteColor)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            componentHead('01 Dec 2021'),
            componentCustomerDetails('Nicholas Gibson', '+1 546 546 356',
                'nic.gibson@gmail.com'),
            const Padding(
              padding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 19.0),
              child: Divider(
                height: 1.0,
                thickness: 1.0,
              ),
            ),
            componentOrderItem(),
          ],
        ),
      ),
    ),
  );

  Widget componentHead(String orderDate) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonWidgets().textView(
            StringConstants.orderDetails,
            StyleConstants.customTextStyle(
                fontSize: 22.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
        CommonWidgets().textView(
            orderDate,
            StyleConstants.customTextStyle(
                fontSize: 14.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratMedium)),
      ],
    ),
  );

  Widget componentOrderItem() => Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().textView(
            StringConstants.orderItem,
            StyleConstants.customTextStyle(
                fontSize: 16.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return orderItemView(
                  'Kollectible', 2, 23.0, index.isEven ? true : false);
            }),
        DottedLine(
            height: 2.0, color: getMaterialColor(AppColors.textColor1)),
        componentBill(),
      ],
    ),
  );


  Widget orderItemView(
      String itemTitle, int itemCount, double itemAmount, bool isSubItem) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CommonWidgets().textView(
                    itemTitle,
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
                const SizedBox(width: 5.0),
                CommonWidgets().textView(
                    'x',
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
                const SizedBox(width: 5.0),
                CommonWidgets().textView(
                    '$itemCount',
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
              ],
            ),
            Row(
              children: [
                CommonWidgets().textView(
                    "\$",
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
                CommonWidgets().textView(
                    '$itemAmount',
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
          ]),
          Visibility(
            visible: isSubItem,
            child: SizedBox(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, innerIndex) {
                        return Row(
                          children: [
                            subOrderItemView('Ice-Cream'),
                            const Text(','),
                            const SizedBox(
                              width: 3.0,
                            )
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 21.0),
        ],
      );

  Widget componentCustomerDetails(
      String customerName, String phoneNumber, String email) =>
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(children: [
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().textView(
                    "${StringConstants.customerName}:",
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
                const SizedBox(height: 13.0),
                CommonWidgets().textView(
                    StringConstants.phone,
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
                const SizedBox(height: 13.0),
                CommonWidgets().textView(
                    StringConstants.email,
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().textView(
                        customerName,
                        StyleConstants.customTextStyle(
                            fontSize: 14.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratMedium)),
                    const SizedBox(height: 13.0),
                    CommonWidgets().textView(
                        phoneNumber,
                        StyleConstants.customTextStyle(
                            fontSize: 14.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratMedium)),
                    const SizedBox(height: 13.0),
                    CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle(
                            fontSize: 14.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratMedium)),
                  ],
                ))
          ]),
        ]),
      );

  Widget subOrderItemView(String subItem) => Text(subItem);

  Widget componentBill() => Column(
    children: [
      const SizedBox(height: 14.0),
      billTextView(StringConstants.foodCost, 38.0),
      billTextView(StringConstants.salesTax, 2.0),
      billTextView(StringConstants.subTotal, 40),
      billTextView(StringConstants.discount, 5.0),
      billTextView(StringConstants.tip, 0.0),
      Divider(
        thickness: 1,
        color: getMaterialColor(AppColors.textColor1),
      ),
      const SizedBox(height: 18.0),
      totalBillView(35.0),
      const SizedBox(height: 22.0),
    ],
  );
  Widget billTextView(String billTitle, double itemAmount) => Column(
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CommonWidgets().textView(
            billTitle,
            StyleConstants.customTextStyle(
                fontSize: 14.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratMedium)),
        Row(
          children: [
            CommonWidgets().textView(
                "\$",
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold)),
            CommonWidgets().textView(
                '$itemAmount',
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold)),
          ],
        ),
      ]),
      const SizedBox(height: 21.0),
    ],
  );

  Widget totalBillView(double totalAmount) =>
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        CommonWidgets().textView(
            StringConstants.total,
            StyleConstants.customTextStyle(
                fontSize: 20.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
        const SizedBox(width: 38.0),
        CommonWidgets().textView(
            "\$",
            StyleConstants.customTextStyle(
                fontSize: 24.0,
                color: getMaterialColor(AppColors.denotiveColor2),
                fontFamily: FontConstants.montserratBold)),
        CommonWidgets().textView(
            '$totalAmount',
            StyleConstants.customTextStyle(
                fontSize: 24.0,
                color: getMaterialColor(AppColors.denotiveColor2),
                fontFamily: FontConstants.montserratBold)),
      ]);
}

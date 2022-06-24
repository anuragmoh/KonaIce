import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';

class CustomerViewScreen extends StatefulWidget {
  const CustomerViewScreen({Key? key}) : super(key: key);

  @override
  _CustomerViewScreenState createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> {
  _onTapCallBack(bool contactValue) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textColor3,
        child: Column(
          children: [
            TopBar(
                userName: "Justin",
                eventName: "Waugh",
                eventAddress: "Wachington",
                showCenterWidget: false,
                onTapCallBack: _onTapCallBack,
                //  onDrawerTap: onDrawerTap,
                onProfileTap: _onProfileChange),
            Expanded(child: _bodyWidget()),
            _bottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() => Container(
        color: AppColors.textColor3.withOpacity(0.1),
        child: _bodyWidgetComponent(),
      );

  Widget _bottomWidget() => Container(
        height: 43.0,
        decoration: BoxDecoration(
            color: AppColors.primaryColor1,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        child: Align(
            alignment: Alignment.topRight, child: _componentBottomWidget()),
      );

  Widget _bodyWidgetComponent() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 237.0, vertical: 20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: AppColors.whiteColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _componentHead('01 Dec 2021'),
                _componentCustomerDetails('Nicholas Gibson', '+1 546 546 356',
                    'nic.gibson@gmail.com'),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 19.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 1.0,
                  ),
                ),
                _componentOrderItem(),
              ],
            ),
          ),
        ),
      );

  _onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  Widget _componentHead(String orderDate) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonWidgets().textView(
                StringConstants.orderDetails,
                StyleConstants.customTextStyle22MontserratBold(
                    color: AppColors.textColor1)),
            CommonWidgets().textView(
                orderDate,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
          ],
        ),
      );

  Widget _componentCustomerDetails(
          String customerName, String phoneNumber, String email) =>
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(children: [
          _buildRow(customerName, phoneNumber, email),
        ]),
      );

  Row _buildRow(String customerName, String phoneNumber, String email) {
    return Row(children: [
      _buildColumn(),
      const SizedBox(
        width: 20.0,
      ),
      _buildExpanded(customerName, phoneNumber, email),
    ]);
  }

  Expanded _buildExpanded(
      String customerName, String phoneNumber, String email) {
    return Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
            const SizedBox(height: 13.0),
            CommonWidgets().textView(
                phoneNumber,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
            const SizedBox(height: 13.0),
            CommonWidgets().textView(
                email,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
          ],
        ));
  }

  Column _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().textView(
            "${StringConstants.customerName}:",
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
        const SizedBox(height: 13.0),
        CommonWidgets().textView(
            StringConstants.phone,
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
        const SizedBox(height: 13.0),
        CommonWidgets().textView(
            StringConstants.email,
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
      ],
    );
  }

  Widget _componentOrderItem() => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().textView(
                StringConstants.orderItem,
                StyleConstants.customTextStyle16MontserratBold(
                    color: AppColors.textColor1)),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _orderItemView(
                      'Kollectible', 2, 23.0, index.isEven ? true : false);
                }),
            DottedLine(height: 2.0, color: AppColors.textColor1),
            _componentBill(),
          ],
        ),
      );

  Widget _orderItemView(
          String itemTitle, int itemCount, double itemAmount, bool isSubItem) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CommonWidgets().textView(
                    itemTitle,
                    StyleConstants.customTextStyle14MonsterMedium(
                        color: AppColors.textColor1)),
                const SizedBox(width: 5.0),
                CommonWidgets().textView(
                    'x',
                    StyleConstants.customTextStyle14MonsterMedium(
                        color: AppColors.textColor1)),
                const SizedBox(width: 5.0),
                CommonWidgets().textView(
                    '$itemCount',
                    StyleConstants.customTextStyle14MonsterMedium(
                        color: AppColors.textColor1)),
              ],
            ),
            Row(
              children: [
                CommonWidgets().textView(
                    "\$",
                    StyleConstants.customTextStyle14MontserratBold(
                        color: AppColors.textColor1)),
                CommonWidgets().textView(
                    '$itemAmount',
                    StyleConstants.customTextStyle14MontserratBold(
                        color: AppColors.textColor1)),
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
                            _subOrderItemView('Ice-Cream'),
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

  Widget _subOrderItemView(String subItem) => Text(subItem);

  Widget _componentBill() => Column(
        children: [
          const SizedBox(height: 14.0),
          _billTextView(StringConstants.foodCost, 38.0),
          _billTextView(StringConstants.salesTax, 2.0),
          _billTextView(StringConstants.subTotal, 40),
          _billTextView(StringConstants.discount, 5.0),
          _billTextView(StringConstants.tip, 0.0),
          Divider(
            thickness: 1,
            color: AppColors.textColor1,
          ),
          const SizedBox(height: 18.0),
          _totalBillView(35.0),
          const SizedBox(height: 22.0),
        ],
      );

  Widget _billTextView(String billTitle, double itemAmount) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonWidgets().textView(
                billTitle,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
            Row(
              children: [
                CommonWidgets().textView(
                    "\$",
                    StyleConstants.customTextStyle14MontserratBold(
                        color: AppColors.textColor1)),
                CommonWidgets().textView(
                    '$itemAmount',
                    StyleConstants.customTextStyle14MontserratBold(
                        color: AppColors.textColor1)),
              ],
            ),
          ]),
          const SizedBox(height: 21.0),
        ],
      );

  Widget _totalBillView(double totalAmount) =>
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        CommonWidgets().textView(
            StringConstants.total,
            StyleConstants.customTextStyle20MontserratBold(
                color: AppColors.textColor1)),
        const SizedBox(width: 38.0),
        CommonWidgets().textView(
            "\$",
            StyleConstants.customTextStyle24MontserratBold(
                color: AppColors.denotiveColor2)),
        CommonWidgets().textView(
            '$totalAmount',
            StyleConstants.customTextStyle24MontserratBold(
                color: AppColors.denotiveColor2)),
      ]);

  Widget _componentBottomWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 35.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(AssetsConstants.switchAccount,
                width: 30.0, height: 30.0)),
      );
}

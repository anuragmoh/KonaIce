import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/event_menu/order_model/order_request_model.dart';
import 'package:kona_ice_pos/screens/payment_option/payment_option.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_order_details_model.dart';
import 'package:kona_ice_pos/utils/utils.dart';

// ignore: must_be_immutable
class CustomerOrderDetails extends StatefulWidget {
  P2POrderDetailsModel orderDetailsModel;
   CustomerOrderDetails({required this.orderDetailsModel,Key? key}) : super(key: key);

  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> implements P2PContractor {

  P2POrderDetailsModel? orderDetailsModel;
  String currentDate =
  Date.getTodaysDate(formatValue: DateFormatsConstant.ddMMMYYYYDayhhmmaa);

  _CustomerOrderDetailsState() {
    P2PConnectionManager.shared.getP2PContractor(this);
  }

  @override
  initState() {
    super.initState();
    orderDetailsModel = widget.orderDetailsModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3),
        child: Visibility(
         // visible: orderDetailsModel != null,
          visible: true,
          child: Column(
            children: [
              CommonWidgets().topEmptyBar(),
              Expanded(child: bodyWidget()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CommonWidgets().buttonWidget(StringConstants.confirm, () {
                  onTapConfirmButton();
                }),
              ),
       //     CommonWidgets().bottomEmptyBar(),
            ],
          ),
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
      child: Column(
        children: [
          componentHead(currentDate),
          componentCustomerDetails(orderDetailsModel!.orderRequestModel!.getCustomerName(),  orderDetailsModel!.orderRequestModel!.getPhoneNumber(),
              orderDetailsModel!.orderRequestModel?.email ??
                  StringExtension.empty()),
          const Padding(
            padding:
            EdgeInsets.symmetric(vertical: 15.0, horizontal: 19.0),
            child: Divider(
              height: 1.0,
              thickness: 1.0,
            ),
          ),
          Expanded(child: SingleChildScrollView(child: componentOrderItem())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                DottedLine(
                    height: 2.0, color: getMaterialColor(AppColors.textColor1)),
                componentBill(),
              ],
            ),
          )
        ],
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderDetailsModel!.orderRequestModel?.orderItemsList?.length ?? 0,
            itemBuilder: (context, index) {
              return orderItemView(orderItem:  orderDetailsModel!.orderRequestModel!.orderItemsList![index]);
            }),
        // DottedLine(
        //     height: 2.0, color: getMaterialColor(AppColors.textColor1)),
        // componentBill(),
      ],
    ),
  );


  Widget orderItemView({required OrderItemsList orderItem}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CommonWidgets().textView(
                    orderItem.name!,
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
                    '${orderItem.quantity}',
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
                    orderItem.getTotalPrice().toStringAsFixed(2),
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
          ]),
          Visibility(
            visible: (orderItem.foodExtraItemMappingList ?? []).isNotEmpty,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (orderItem.foodExtraItemMappingList ?? []).isNotEmpty ? (orderItem.foodExtraItemMappingList![0].orderFoodExtraItemDetailDto?.length ?? 0) : 0,
                itemBuilder: (context, innerIndex) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: subOrderItemView(orderItem.foodExtraItemMappingList![0].orderFoodExtraItemDetailDto![innerIndex].name ?? ''),
                      ),
                      const Text(','),
                      const SizedBox(
                        width: 3.0,
                      )
                    ],
                  );
                }),
          ),
          const SizedBox(height: 15.0),
        ],
      );

  Widget componentCustomerDetails(
      String customerName, String phoneNumber, String email) =>
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CommonWidgets().textView(
                    "${StringConstants.customerName}:",
                    StyleConstants.customTextStyle(
                        fontSize: 14.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratMedium)),
                ),
                Expanded(
                  flex: 5,
                  child: CommonWidgets().textView(
                      customerName,
                      StyleConstants.customTextStyle(
                          fontSize: 14.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratMedium)),
                )],
            ),
          ),
          Visibility(
            visible: phoneNumber.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CommonWidgets().textView(
                      '${StringConstants.phone}:',
                      StyleConstants.customTextStyle(
                          fontSize: 14.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratMedium)),
                  ),
                  Expanded(
                    flex: 5,
                    child: CommonWidgets().textView(
                        phoneNumber,
                        StyleConstants.customTextStyle(
                            fontSize: 14.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratMedium)),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: email.isNotEmpty,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CommonWidgets().textView(
                      '${StringConstants.email}:',
                      StyleConstants.customTextStyle(
                          fontSize: 14.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratMedium)),
                ),
                Expanded(
                  flex: 5,
                  child: CommonWidgets().textView(
                      email,
                      StyleConstants.customTextStyle(
                          fontSize: 14.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratMedium)),
                ),
              ],
            ),
          ),
        ]),
      );

  Widget subOrderItemView(String subItem) => Text(subItem);

  Widget componentBill() => Column(
    children: [
      const SizedBox(height: 14.0),
      billTextView(StringConstants.foodCost, orderDetailsModel!.foodCost ?? 0.0),
      billTextView(StringConstants.salesTax, orderDetailsModel!.salesTax ?? 0.0),
      billTextView(StringConstants.subTotal, getSubTotal()),
    //  billTextView(StringConstants.discount, orderDetailsModel!.discount ?? 0.0),
      billTextView(StringConstants.tip, orderDetailsModel!.tip ?? 0.0),
      Divider(
        thickness: 1,
        color: getMaterialColor(AppColors.textColor1),
      ),
      const SizedBox(height: 18.0),
      totalBillView(orderDetailsModel?.totalAmount ?? 0.0),
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
                itemAmount.toStringAsFixed(2),
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
            totalAmount.toStringAsFixed(2),
            StyleConstants.customTextStyle(
                fontSize: 24.0,
                color: getMaterialColor(AppColors.denotiveColor2),
                fontFamily: FontConstants.montserratBold)),
      ]);

  //Action Event
   onTapConfirmButton() {
     updateConfirmOrderToStaff();
    showPaymentScreen();
   }

   double getSubTotal() {
     return (orderDetailsModel!.foodCost ?? 0.0) + (orderDetailsModel!.salesTax ?? 0.0);
   }

   //Navigation
  showPaymentScreen() {
    Navigator.of(context).push( MaterialPageRoute(builder: (context) => const PaymentOption())).then((value) =>
    {
    P2PConnectionManager.shared.getP2PContractor(this)
    });
  }

  showSplashScreen() {
     Navigator.of(context).pop();
  }

  //data for p2pConnection
  updateConfirmOrderToStaff() {
     P2PConnectionManager.shared.updateData(action: CustomerActionConst.orderConfirmed);
  }


  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == StaffActionConst.orderModelUpdated) {
      orderDetailsModel = P2POrderDetailsModel();
      P2POrderDetailsModel modelObjc = p2POrderDetailsModelFromJson(
          response.data);
      if (modelObjc.orderRequestModel!.orderItemsList!.isNotEmpty) {
      setState(() {
        orderDetailsModel = modelObjc;
      });
      } else {
        showSplashScreen();
      }
    }
    else if (response.action == StaffActionConst.chargeOrderBill) {
      showPaymentScreen();
    }
    else if (response.action == StaffActionConst.showSplashAtCustomerForHomeAndSettings) {
      showSplashScreen();
    }
  }
}

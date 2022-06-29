import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/models/network_model/order_model/order_request_model.dart';
import 'package:kona_ice_pos/screens/payment_option/payment_option.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_order_details_model.dart';

import 'custom_add_tip_dialog.dart';

// ignore: must_be_immutable
class CustomerOrderDetails extends StatefulWidget {
  P2POrderDetailsModel orderDetailsModel;
  CustomerOrderDetails({required this.orderDetailsModel, Key? key})
      : super(key: key);

  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails>
    implements P2PContractor {
  P2POrderDetailsModel? _orderDetailsModel;
  String _currentDate =
      Date.getTodaysDate(formatValue: DateFormatsConstant.ddMMMYYYYDayhhmmaa);

  double _tipAmount = 0.0;

  _CustomerOrderDetailsState() {
    P2PConnectionManager.shared.getP2PContractor(this);
  }

  @override
  initState() {
    super.initState();
    _orderDetailsModel = widget.orderDetailsModel;
    _updateTip(_orderDetailsModel!.tip!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.textColor3,
          child: Visibility(
            // visible: orderDetailsModel != null,
            visible: true,
            child: Column(
              children: [
                CommonWidgets().topEmptyBar(),
                Expanded(child: _bodyWidget()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Visibility(
                          visible: false,
                          child: CommonWidgets().buttonWidgetUnFilled(
                            StringConstants.addTip,
                            _onAddTipButtonTap,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 230.0, bottom: 20.0),
                      child: CommonWidgets()
                          .buttonWidget(StringConstants.confirm, () {
                        _onTapConfirmButton();
                      }),
                    ),
                  ],
                ),
                //     CommonWidgets().bottomEmptyBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() => Container(
        color: AppColors.textColor3.withOpacity(0.1),
        child: _bodyWidgetComponent(),
      );

  Widget _splashIcon() {
    return CommonWidgets()
        .image(image: AssetsConstants.konaIcon, width: 100.0, height: 60.0);
  }

  Widget _bodyWidgetComponent() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 237.0, vertical: 20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: AppColors.whiteColor),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              _splashIcon(),
              _componentHead(_currentDate),
              _componentCustomerDetails(
                  _orderDetailsModel!.orderRequestModel!.getCustomerName(),
                  _orderDetailsModel!.orderRequestModel!.getPhoneNumber(),
                  _orderDetailsModel!.orderRequestModel?.email ??
                      StringExtension.empty()),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 19.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(child: _componentOrderItem())),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    DottedLine(height: 2.0, color: AppColors.textColor1),
                    _componentBill(),
                  ],
                ),
              )
            ],
          ),
        ),
      );

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

  Widget _componentOrderItem() => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().textView(
                StringConstants.orderItem,
                StyleConstants.customTextStyle16MontserratBold(
                    color: AppColors.textColor1)),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _orderDetailsModel!
                        .orderRequestModel?.orderItemsList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return _orderItemView(
                      orderItem: _orderDetailsModel!
                          .orderRequestModel!.orderItemsList![index]);
                }),
          ],
        ),
      );

  Widget _orderItemView({required OrderItemsList orderItem}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildSubRow1(orderItem),
            _buildSubRow2(orderItem),
          ]),
          Visibility(
            visible: (orderItem.foodExtraItemMappingList ?? []).isNotEmpty,
            child: _listViewBuilder(orderItem),
          ),
          const SizedBox(height: 15.0),
        ],
      );

  ListView _listViewBuilder(OrderItemsList orderItem) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (orderItem.foodExtraItemMappingList ?? []).isNotEmpty
            ? (orderItem.foodExtraItemMappingList![0]
                    .orderFoodExtraItemDetailDto?.length ??
                0)
            : 0,
        itemBuilder: (context, innerIndex) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _subOrderItemView(orderItem.foodExtraItemMappingList![0]
                        .orderFoodExtraItemDetailDto![innerIndex].name ??
                    ''),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: CommonWidgets().textWidget(
                    "X " +
                        orderItem.foodExtraItemMappingList![0]
                            .orderFoodExtraItemDetailDto![innerIndex].quantity
                            .toString(),
                    StyleConstants.customTextStyle10MonsterMedium(
                        color: AppColors.textColor2)),
              ),
              const SizedBox(
                width: 3.0,
              )
            ],
          );
        });
  }

  Row _buildSubRow2(OrderItemsList orderItem) {
    return Row(
      children: [
        CommonWidgets().textView(
            "\$",
            StyleConstants.customTextStyle14MontserratBold(
                color: AppColors.textColor1)),
        CommonWidgets().textView(
            orderItem.getTotalPrice().toStringAsFixed(2),
            StyleConstants.customTextStyle14MontserratBold(
                color: AppColors.textColor1)),
      ],
    );
  }

  Row _buildSubRow1(OrderItemsList orderItem) {
    return Row(
      children: [
        CommonWidgets().textView(
            orderItem.name!,
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
        const SizedBox(width: 5.0),
        CommonWidgets().textView(
            'x',
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
        const SizedBox(width: 5.0),
        CommonWidgets().textView(
            '${orderItem.quantity}',
            StyleConstants.customTextStyle14MonsterMedium(
                color: AppColors.textColor1)),
      ],
    );
  }

  Widget _componentCustomerDetails(
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
                      StyleConstants.customTextStyle14MonsterMedium(
                          color: AppColors.textColor1)),
                ),
                Expanded(
                  flex: 5,
                  child: CommonWidgets().textView(
                      customerName,
                      StyleConstants.customTextStyle14MonsterMedium(
                          color: AppColors.textColor1)),
                )
              ],
            ),
          ),
          _phoneNumVisibility(phoneNumber),
          _emailVisibility(email),
        ]),
      );

  Visibility _emailVisibility(String email) {
    return Visibility(
      visible: email.isNotEmpty && email != "null",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CommonWidgets().textView(
                '${StringConstants.email}:',
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
          ),
          Expanded(
            flex: 5,
            child: CommonWidgets().textView(
                email,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: AppColors.textColor1)),
          ),
        ],
      ),
    );
  }

  Visibility _phoneNumVisibility(String phoneNumber) {
    return Visibility(
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
                  StyleConstants.customTextStyle14MonsterMedium(
                      color: AppColors.textColor1)),
            ),
            Expanded(
              flex: 5,
              child: CommonWidgets().textView(
                  phoneNumber,
                  StyleConstants.customTextStyle14MonsterMedium(
                      color: AppColors.textColor1)),
            )
          ],
        ),
      ),
    );
  }

  Widget _subOrderItemView(String subItem) => Text(subItem);

  Widget _componentBill() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 14.0),
            _billTextView(
                StringConstants.foodCost, _orderDetailsModel!.foodCost ?? 0.0),
            _billTextView(
                StringConstants.salesTax, _orderDetailsModel!.salesTax ?? 0.0),
            _billTextView(StringConstants.subTotal, _getSubTotal()),
            //  billTextView(StringConstants.discount, orderDetailsModel!.discount ?? 0.0),
            _billTextView(StringConstants.tip, _tipAmount),
            Divider(
              thickness: 1,
              color: AppColors.textColor1,
            ),
            const SizedBox(height: 18.0),
            _totalBillView(_orderDetailsModel?.totalAmount ?? 0.0),
            const SizedBox(height: 22.0),
          ],
        ),
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
                    itemAmount.toStringAsFixed(2),
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
            totalAmount.toStringAsFixed(2),
            StyleConstants.customTextStyle24MontserratBold(
                color: AppColors.denotiveColor2)),
      ]);

  //Action Event
  _onTapConfirmButton() {
    _updateConfirmOrderToStaff();
    _showPaymentScreen();
  }

  double _getSubTotal() {
    return (_orderDetailsModel!.foodCost ?? 0.0) +
        (_orderDetailsModel!.salesTax ?? 0.0);
  }

  //Navigation
  _showPaymentScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PaymentOption()))
        .then((value) => {P2PConnectionManager.shared.getP2PContractor(this)});
  }

  _showSplashScreen() {
    Navigator.of(context).pop();
  }

  //data for p2pConnection
  _updateConfirmOrderToStaff() {
    P2PConnectionManager.shared
        .updateData(action: CustomerActionConst.orderConfirmed);
  }

  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == StaffActionConst.orderModelUpdated) {
      _orderDetailsModel = P2POrderDetailsModel();
      P2POrderDetailsModel modelObjc =
          p2POrderDetailsModelFromJson(response.data);
      if (modelObjc.orderRequestModel!.orderItemsList!.isNotEmpty) {
        setState(() {
          _orderDetailsModel = modelObjc;
        });
      } else {
        _showSplashScreen();
      }
    } else if (response.action == StaffActionConst.chargeOrderBill) {
      _showPaymentScreen();
    } else if (response.action ==
        StaffActionConst.showSplashAtCustomerForHomeAndSettings) {
      _showSplashScreen();
    } else if (response.action == StaffActionConst.tip) {
      _updateTip(double.parse(response.data));
    }
  }

  _onAddTipButtonTap() {
    showDialog(
        barrierDismissible: false,
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return CustomerAddTipDialog(callBack: _getTip);
        });
  }

  _getTip(double tip) {
    _orderDetailsModel?.setTip(tip);
    double? receivedTip = _orderDetailsModel?.getTip();
    _updateTip(receivedTip!);
    P2PConnectionManager.shared.notifyChangeToStaff(
        action: CustomerActionConst.tip, data: receivedTip.toString());
  }

  _updateTip(double tip) {
    setState(() {
      _tipAmount = tip;
    });
  }
}

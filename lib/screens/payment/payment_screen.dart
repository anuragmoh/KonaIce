import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/orders/order_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/event_menu/order_model/order_request_model.dart';
import 'package:kona_ice_pos/screens/event_menu/order_model/order_response_model.dart';
import 'package:kona_ice_pos/screens/home/party_events.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/payment/pay_order_model/pay_order_request_model.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class PaymentScreen extends StatefulWidget {
  final Events events;
  final List<Item> selectedMenuItems;
  final PlaceOrderRequestModel placeOrderRequestModel;
  final Map billDetails;
  final String userName;

  const PaymentScreen({Key? key, required this.events, required this.selectedMenuItems, required this.placeOrderRequestModel, required this.billDetails, required this.userName}) : super(key: key);


  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> implements
    OrderResponseContractor, P2PContractor{
  int paymentModeType = -1;
  double returnAmount = 0.0;
  double receivedAmount = 0.0;
  double totalAmount = 0.0;
  double tip = 0.0;
  double salesTax = 0.0;
  double discount = 0.0;
  double foodCost = 0.0;
  bool isPaymentDone = false;
  int receiptMode = 1;
  String orderID = 'NA';

  TextEditingController amountReceivedController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int currentIndex = 0;

  late OrderPresenter orderPresenter;
  bool isApiProcess = false;
  PlaceOrderResponseModel placeOrderResponseModel = PlaceOrderResponseModel();

  _PaymentScreenState() {
    orderPresenter = OrderPresenter(this);
    P2PConnectionManager.shared.getP2PContractor(this);
  }

  @override
  void initState() {
    super.initState();
    totalAmount = widget.billDetails['totalAmount'];
    tip = widget.billDetails['tip'];
    discount = widget.billDetails['discount'];
    foodCost = widget.billDetails['foodCost'];
    salesTax = widget.billDetails['salesTax'];
    if (widget.placeOrderRequestModel.id != null && widget.placeOrderRequestModel.id!.isNotEmpty) {
      orderID = widget.placeOrderRequestModel.id!;
    }
    callPlaceOrderAPI();
  }


  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          children: [
            TopBar(userName: widget.userName,
              eventName: widget.events.getEventName(),
              eventAddress: widget.events.getEventAddress(),
              showCenterWidget: false,
              onTapCallBack: onTapCallBack,
              //    onDrawerTap: onDrawerTap,
              onProfileTap: onProfileChange,),

            Expanded(child: bodyWidget()),
            BottomBarWidget(
              onTapCallBack: onTapBottomListItem,
              accountImageVisibility: false,
              isFromDashboard: false,
            )
            // CommonWidgets().bottomBar(false),
          ],
        ),
      ),
    );
  }

  onDrawerTap() {
    //Scaffold.of(context).openDrawer();
  }
  onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }
  Widget bodyWidget() =>
      Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: bodyWidgetComponent(),
      );

  Widget bodyWidgetComponent() =>
      Row(children: [
        leftSideWidget(),
        rightSideWidget(),
      ]);

  Widget leftSideWidget() =>
      Expanded(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 14.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 5.0),
              child: leftSideTopComponent(totalAmount),
            ),
            // leftSideTopComponent(totalAmount),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: getMaterialColor(AppColors.gradientColor1).withOpacity(
                    0.2),
                thickness: 1,
              ),
            ),
            Expanded(child: leftBodyComponent()),
          ]));

  Widget leftSideTopComponent(double totalAmount) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SizedBox(
          height: 80.0,
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    InkWell(
                      onTap: () {
                        onTapBackButton();
                      },
                      child: CommonWidgets().image(
                          image: AssetsConstants.backArrow,
                          width: 25.0,
                          height: 25.0),
                    ),
                    const SizedBox(
                      width: 22.0,
                    ),
                    Column(
                      children: [
                        CommonWidgets().textWidget(
                            StringConstants.totalAmount,
                            StyleConstants.customTextStyle(
                                fontSize: 12.0,
                                color: getMaterialColor(AppColors.textColor2),
                                fontFamily: FontConstants.montserratMedium)),
                        const SizedBox(
                          height: 2.0,
                        ),
                        CommonWidgets().textWidget(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            StyleConstants.customTextStyle(
                                fontSize: 34.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratBold))
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 51.0,
                ),
                // Amount to return field
                Visibility(
                  visible: isPaymentDone == false && paymentModeType == 0
                      ? true
                      : false,
                  child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets().textWidget(
                              StringConstants.amountReceived,
                              StyleConstants.customTextStyle(
                                  fontSize: 12.0,
                                  color: getMaterialColor(AppColors.textColor2),
                                  fontFamily: FontConstants.montserratMedium)),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CommonWidgets().textWidget(
                                  '\$',
                                  StyleConstants.customTextStyle(
                                      fontSize: 22.0,
                                      color: getMaterialColor(
                                          AppColors.textColor1),
                                      fontFamily:
                                      FontConstants.montserratMedium)),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      color: getMaterialColor(
                                          AppColors.whiteColor),
                                      border: Border.all(
                                          color: getMaterialColor(
                                              AppColors.primaryColor2))),
                                  width: 70.0,
                                  height: 42.0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 2.0),
                                      child: TextField(
                                        controller: amountReceivedController,
                                        style: StyleConstants.customTextStyle(
                                            fontSize: 22.0,
                                            color: getMaterialColor(
                                                AppColors.textColor1),
                                            fontFamily:
                                            FontConstants.montserratMedium),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            onAmountEnter(double.parse(value));
                                          }
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        ]),
                  ),
                ),
                // Return Amount
                const SizedBox(
                  width: 15.0,
                ),
                Visibility(
                  visible: isPaymentDone == false && paymentModeType == 0
                      ? true
                      : false,
                  child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets().textWidget(
                              StringConstants.amountToReturn,
                              StyleConstants.customTextStyle(
                                  fontSize: 12.0,
                                  color: getMaterialColor(AppColors.textColor2),
                                  fontFamily: FontConstants.montserratMedium)),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CommonWidgets().textWidget(
                                  '\$',
                                  StyleConstants.customTextStyle(
                                      fontSize: 22.0,
                                      color: getMaterialColor(
                                          AppColors.textColor1),
                                      fontFamily:
                                      FontConstants.montserratMedium)),
                              CommonWidgets().textWidget(
                                  returnAmount.toStringAsFixed(2),
                                  StyleConstants.customTextStyle(
                                      fontSize: 22.0,
                                      color: getMaterialColor(
                                          AppColors.textColor1),
                                      fontFamily:
                                      FontConstants.montserratMedium)),
                            ],
                          )
                        ]),
                  ),
                ),
                // Button
                buttonWidget(
                    isPaymentDone == true
                        ? StringConstants.newOrder
                        : StringConstants.proceed,
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
              ]),
        ),
      );

  Widget buttonWidget(String buttonText, TextStyle textStyle) {
    bool showDisabledButton = !isPaymentDone && receivedAmount < totalAmount && paymentModeType <= 0;
    return GestureDetector(
      onTap: isPaymentDone == false ? () {
        onTapProceed(showDisabledButton) ;
      } : onTapNewOrder,

      child: Container(
        decoration: BoxDecoration(
          color: getMaterialColor(showDisabledButton ? AppColors.denotiveColor4 : AppColors.primaryColor2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 28.0),
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }

  Widget leftBodyComponent() =>
      SingleChildScrollView(
        child: Column(children: [
          Visibility(
              visible: !isPaymentDone,
              child: Column(
                children: [
                  paymentModeWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color:
                      getMaterialColor(AppColors.gradientColor1).withOpacity(
                          0.2),
                      thickness: 1,
                    ),
                  ),
                ],
              )),
          SingleChildScrollView(
              child: isPaymentDone ? paymentSuccess('35891456') : const Text(
                  '')),
        ]),
      );

  Widget paymentModeWidget() =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            paymentModeView(
                StringConstants.creditCard, PaymentModeConstants.creditCard, AssetsConstants.creditCard),
            paymentModeView(StringConstants.cash, PaymentModeConstants.cash, AssetsConstants.cash),
            paymentModeView(StringConstants.qrCode, PaymentModeConstants.qrCode, AssetsConstants.qrCode),
          ],
        ),
      );

  Widget paymentModeView(String title, int index, String icon) =>
      GestureDetector(
        onTap: () {
         onTapPaymentMode(index);
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: paymentModeType == index
                      ? getMaterialColor(AppColors.primaryColor2)
                      : null,
                  border: Border.all(
                      color: getMaterialColor(AppColors.primaryColor2)),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
                child: CommonWidgets().image(
                    image: icon,
                    width: 4.25 * SizeConfig.imageSizeMultiplier,
                    height: 4.25 * SizeConfig.imageSizeMultiplier),
              ),
            ),
            const SizedBox(width: 10.0),
            CommonWidgets().textWidget(
                title,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratMedium)),
          ],
        ),
      );

  Widget paymentSuccess(String transactionId) =>
      Column(
        children: [

          const SizedBox(height: 68.0),
          CommonWidgets().image(
              image: AssetsConstants.success,
              width: 9.3 * SizeConfig.imageSizeMultiplier,
              height: 9.3 * SizeConfig.imageSizeMultiplier),
          const SizedBox(height: 21.0),
          CommonWidgets().textWidget(
              StringConstants.paymentSuccessful,
              StyleConstants.customTextStyle(
                  fontSize: 22.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonWidgets().textWidget(
                '${StringConstants.transactionId}:',
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
            CommonWidgets().textWidget(
                transactionId,
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
          ]),
          const SizedBox(height: 38.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 135.0),
            child: Divider(
              color:
              getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
              thickness: 1,
            ),
          ),
          const SizedBox(height: 28.0),
          CommonWidgets().textWidget(
              StringConstants.howWouldYouLikeToReceiveTheReceipt,
              StyleConstants.customTextStyle(
                  fontSize: 16.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratMedium)),
          const SizedBox(height: 12.0),
          Container(
            width: 203.0,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                    color: getMaterialColor(AppColors.primaryColor2))),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      receiptMode = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8.0)),
                      color: receiptMode == 1
                          ? getMaterialColor(AppColors.primaryColor2)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38.0, vertical: 9.0),
                      child: CommonWidgets().textWidget(
                          StringConstants.email,
                          StyleConstants.customTextStyle(
                              fontSize: 9.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratRegular)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      receiptMode = 2;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8.0)),
                        color: receiptMode == 2
                            ? getMaterialColor(AppColors.primaryColor2)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19.0, vertical: 9.0),
                        child: CommonWidgets().textWidget(
                            StringConstants.textMessage,
                            StyleConstants.customTextStyle(
                                fontSize: 9.0,
                                color: getMaterialColor(AppColors.textColor1),
                                fontFamily: FontConstants.montserratRegular)),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19.0),
          receiptMode == 1 ? emailReceiptWidget() : textMessageReceiptWidget(),
          const SizedBox(height: 20.0),
        ],
      );

  Widget emailReceiptWidget() =>
      Container(
        width: 253.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: getMaterialColor(AppColors.whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0, left: 4.0),
                      child: TextField(
                        controller: emailController,
                        style: StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratSemiBold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
              child: CommonWidgets().image(
                  image: AssetsConstants.send, width: 25.0, height: 25.0),
            )
          ],
        ),
      );

  Widget textMessageReceiptWidget() =>
      Container(
        width: 253.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: getMaterialColor(AppColors.whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 50.0, child: countryPicker()),
                  Container(
                    width: 1.0,
                    height: 20.0,
                    color: getMaterialColor(AppColors.primaryColor1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0, left: 4.0),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: StyleConstants.customTextStyle(
                            fontSize: 12.0,
                            color: getMaterialColor(AppColors.textColor1),
                            fontFamily: FontConstants.montserratSemiBold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
              child: CommonWidgets().image(
                  image: AssetsConstants.send, width: 25.0, height: 25.0),
            )
          ],
        ),
      );

  Widget countryPicker() =>
      CountryCodePicker(
        onChanged: (value) {},
        padding: EdgeInsets.zero,
        textStyle: StyleConstants.customTextStyle(
            fontSize: 12.0,
            color: getMaterialColor(AppColors.textColor1),
            fontFamily: FontConstants.montserratMedium),
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: '+91',
        showFlag: false,
        // optional. Shows only country name and flag
        showCountryOnly: true,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      );

  onAmountEnter(double value) {
    receivedAmount = value;
    if (value > totalAmount) {
      setState(() {
        returnAmount = value - totalAmount;
      });
    } else {
      setState(() {
        returnAmount = 0.0;
      });
    }
  }

  // Right side panel design

  Widget rightSideWidget() =>
      Padding(
        padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.307,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.78,
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
                    customerNameWidget(
                        customerName: widget.placeOrderRequestModel
                            .getCustomerName()),
                    const SizedBox(height: 7.0),
                    orderDetailsWidget(
                        orderId: orderID,
                        orderDate: widget.placeOrderRequestModel
                            .getOrderDate()),
                    const SizedBox(height: 8.0),
                    customerDetailsComponent(
                        eventName: widget.events.getEventName(),
                        email: widget.placeOrderRequestModel.email ??
                            StringExtension.empty(),
                        storeAddress: widget.events.getEventAddress(),
                        phone: widget.placeOrderRequestModel.getPhoneNumber()),
                    const SizedBox(height: 10.0),
                    // Expanded removed from here.
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                            color: getMaterialColor(AppColors.whiteColor),
                            child: itemView()),
                      ),
                    ),
                    DottedLine(
                        height: 2.0,
                        color: getMaterialColor(AppColors.textColor1)),
                    componentBill(),
                  ]),
            ),
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
  Widget customerDetailsComponent({required String eventName,
    required String email,
    required String storeAddress,
    required String phone}) =>
      Column(
        children: [
          Visibility(
            visible: eventName.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            visible: email.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            visible: phone.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
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

  Widget itemView() =>
      Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.placeOrderRequestModel.orderItemsList!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemViewListItem(orderItem: widget.placeOrderRequestModel.orderItemsList![index]);
            }),
      ]);

  Widget itemViewListItem({required OrderItemsList orderItem}) =>
      Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Expanded(
              flex: 6,
              child: CommonWidgets().textView(
                  orderItem.name!,
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CommonWidgets().textView(
                    "${StringConstants.qty} - ${orderItem.quantity!}",
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratRegular)),
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${orderItem.getTotalPrice().toStringAsFixed(2)}",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratSemiBold)),
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
          const SizedBox(height: 20.0),
        ],
      );
  Widget subOrderItemView(String subItem) => Text(subItem,style: const TextStyle(fontSize: 10.0),);

  Widget componentBill() =>
      Column(
        children: [
          const SizedBox(height: 14.0),
          billTextView(StringConstants.foodCost, foodCost),
          billTextView(StringConstants.salesTax, salesTax),
          billTextView(StringConstants.subTotal, foodCost + salesTax),
         // billTextView(StringConstants.discount, discount),
          billTextView(StringConstants.tip, tip),
          //const SizedBox(height: 23.0),
          totalBillView(totalAmount),
          const SizedBox(height: 22.0),
        ],
      );

  Widget billTextView(String billTitle, double itemAmount) =>
      Column(
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CommonWidgets().textView(
            '${StringConstants.billTotal}:',
            StyleConstants.customTextStyle(
                fontSize: 20.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
        CommonWidgets().textView(
            '\$${totalAmount.toStringAsFixed(2)}',
            StyleConstants.customTextStyle(
                fontSize: 24.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
      ]);

  //Action Event

  onTapPaymentMode(int index) {
    setState(() {
      paymentModeType = index;
      updateSelectedPaymentMode();
    });
  }

  onTapNewOrder() {
    if (isPaymentDone) {
      Navigator.of(context).pop(getOrderInfoToSendBack(true));
    }
  }

  onTapProceed(bool isDisabled) {
    if (!isDisabled) {
      callPayOrderAPI();
    }
  }

  onTapBackButton() {
    if (!isPaymentDone) {
      editAndUpdateOrder();
    }
    showEventMenuScreen();
  }

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  onTapCallBack(bool callBack) {

  }

  //Navigation
  showEventMenuScreen() {
    Navigator.of(context).pop(getOrderInfoToSendBack(isPaymentDone));
  }


  //data for p2pConnection to Customer
  updateSelectedPaymentMode() {
    P2PConnectionManager.shared.updateData(action: StaffActionConst.paymentModeSelected,
        data: paymentModeType.toString());
  }

  editAndUpdateOrder() {
    P2PConnectionManager.shared.updateData(action: StaffActionConst.editOrderDetails);
  }

  updatePaymentSuccess() {
    P2PConnectionManager.shared.updateData(action: StaffActionConst.paymentCompleted);
  }

  //Other functions
  Map getOrderInfoToSendBack(bool isOrderComplete) {
    String orderComplete = isOrderComplete ? "True" : "False";
    Map orderInfo = {"isOrderComplete": orderComplete, "orderID": orderID};
    debugPrint("insideGetMap $orderInfo");
    return orderInfo;
  }
  PayOrderRequestModel getPayOrderRequestModel() {
    PayOrderRequestModel payOrderRequestModel = PayOrderRequestModel();
    payOrderRequestModel.orderId = orderID;
    payOrderRequestModel.paymentMethod = "CASH";
    payOrderRequestModel.cardId = StringExtension.empty();

    return payOrderRequestModel;
  }

  //API call
  callPlaceOrderAPI({bool isPreviousRequestFail = false}) async {

    orderPresenter.placeOrder(widget.placeOrderRequestModel);
  }

  callPayOrderAPI() {
    PayOrderRequestModel payOrderRequestModel = getPayOrderRequestModel();
    setState(() {
      isApiProcess = true;
    });
    orderPresenter.payOrder(payOrderRequestModel);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
      CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);
  }

  @override
  void showSuccess(response) {
    setState(() {
      updatePaymentSuccess();
      isPaymentDone = true;
      isApiProcess = false;
    });
    clearOderData();
  }

  @override
  void showErrorForPlaceOrder(GeneralErrorResponse exception) {
    CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);
  }

  @override
  void showSuccessForPlaceOrder(response) {
    placeOrderResponseModel = response;
    if (placeOrderResponseModel.id != null) {
      setState(() {
        orderID = placeOrderResponseModel.id!;
      });
    }
  }

  //DB Calls
  clearOderData() async {
    await SavedOrdersDAO().clearEventDataByOrderID(orderID);
  }

  //P2P Implemented Method
  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == CustomerActionConst.paymentModeSelected) {
      String modeType = response.data;
      setState(() {
        paymentModeType = int.parse(modeType);
      });
    }
    else if (response.action == CustomerActionConst.editOrderDetails) {
      showEventMenuScreen();
    }
  }

}
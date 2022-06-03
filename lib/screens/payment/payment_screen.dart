// import 'package:blinkcard_flutter/microblink_scanner.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/models/data_models/events.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/models/network_model/order_model/order_request_model.dart';
import 'package:kona_ice_pos/models/network_model/order_model/order_response_model.dart';
import 'package:kona_ice_pos/models/network_model/pay_order_model/finix_sendreceipt_model.dart';
import 'package:kona_ice_pos/models/network_model/pay_order_model/pay_order_request_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/general_success_model.dart';
import 'package:kona_ice_pos/network/repository/orders/order_presenter.dart';
import 'package:kona_ice_pos/network/repository/payment/finix_response_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/network/repository/payment/payreceipt_model.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/payment/payment_fails_popup.dart';
import 'package:kona_ice_pos/screens/payment/validation_popup.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';
import 'package:kona_ice_pos/utils/utils.dart';
import '../../utils/function_utils.dart';
import 'credit_card_details_popup.dart';

class PaymentScreen extends StatefulWidget {
  final Events events;
  final List<Item> selectedMenuItems;
  final PlaceOrderRequestModel placeOrderRequestModel;
  final Map billDetails;
  final String userName;

  const PaymentScreen(
      {Key? key,
      required this.events,
      required this.selectedMenuItems,
      required this.placeOrderRequestModel,
      required this.billDetails,
      required this.userName})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    implements OrderResponseContractor, P2PContractor, ResponseContractor {
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
  String orderID = StringConstants.na;
  String cardNumberValidationMessage = "";
  bool isCardNumberValid = true;
  bool isExpiryValid = true;
  bool isCvcValid = true;
  String finixMerchantId = StringExtension.empty();
  String finixdeviceId = StringExtension.empty();
  String finixSerialNumber = StringExtension.empty();
  String finixUsername = StringExtension.empty();
  String finixPassword = StringExtension.empty();
  String merchantIdNCP = StringExtension.empty();
  String finixNCPaymentToken = StringExtension.empty();
  String paymentFailMessage = StringExtension.empty();
  String stripeTokenId = "", stripePaymentMethodId = "";
  String demoCardNumber = "";
  String userEmail = StringExtension.empty();
  String userMobileNumber = StringExtension.empty();
  String emailValidationMessage = "";
  String smsValidationMessage = "";
  String countryCode = StringConstants.usCountryCode;
  FinixResponseModel finixResponse = FinixResponseModel();

  TextEditingController amountReceivedController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int currentIndex = 0;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController dateExpiryController = TextEditingController();

  late OrderPresenter orderPresenter;
  bool isApiProcess = false;
  PlaceOrderResponseModel placeOrderResponseModel = PlaceOrderResponseModel();
  late PaymentPresenter paymentPresenter;

  static const MethodChannel cardPaymentChannel =
      MethodChannel("com.mobisoft.konaicepos/cardPayment");

  _PaymentScreenState() {
    orderPresenter = OrderPresenter(this);
    P2PConnectionManager.shared.getP2PContractor(this);
    paymentPresenter = PaymentPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    totalAmount = widget.billDetails['totalAmount'];
    tip = widget.billDetails['tip'];
    discount = widget.billDetails['discount'];
    foodCost = widget.billDetails['foodCost'];
    salesTax = widget.billDetails['salesTax'];
    if (widget.placeOrderRequestModel.id != null &&
        widget.placeOrderRequestModel.id!.isNotEmpty) {
      orderID = widget.placeOrderRequestModel.id!;
    }
    getFinixdetailsValues();
    callPlaceOrderAPI();
    cardPaymentChannel.setMethodCallHandler((call) async {
      debugPrint("init state setMethodCallHandler ${call.method}");
      if (call.method == "paymentSuccess") {
        _paymentSuccess(call.arguments.toString());
      } else if (call.method == "paymentFailed") {
        _paymentFailed();
      } else if (call.method == "paymentStatus") {
        _paymentStatus(call.arguments.toString());
      } else if (call.method == "getPaymentToken") {
        _getPaymentToken(call.arguments.toString());
      }
    });
  }

  _paymentSuccess(msg) async {
    debugPrint("Payment Success: $msg");
    setState(() {
      updatePaymentSuccess();
      isPaymentDone = true;
    });
    finixResponse = finixResponseFromJson(msg);
    //Finix recipt Api Call
    PayReceipt payReceipt = getPayReceiptModel(false);
  }

  _paymentFailed() async {
    debugPrint("Payment Failure");
    showDialog(
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return PaymentFailPopup(paymentFailMessage: paymentFailMessage);
        });
  }

  _paymentStatus(status) async {
    debugPrint("Payment Status: $status");
  }

  _getPaymentToken(token) async {
    debugPrint("Payment Token: $token");
    finixNCPaymentToken = token;
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
            TopBar(
              userName: widget.userName,
              eventName: widget.events.getEventName(),
              eventAddress: widget.events.getEventAddress(),
              showCenterWidget: false,
              onTapCallBack: onTapCallBack,
              //    onDrawerTap: onDrawerTap,
              onProfileTap: onProfileChange,
            ),

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

  onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  Widget bodyWidget() => Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: bodyWidgetComponent(),
      );

  Widget bodyWidgetComponent() => Row(children: [
        leftSideWidget(),
        rightSideWidget(),
      ]);

  Widget leftSideWidget() => Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 14.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          child: leftSideTopComponent(totalAmount),
        ),
        // leftSideTopComponent(totalAmount),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Expanded(child: leftBodyComponent()),
      ]));

  Widget leftSideTopComponent(double totalAmount) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SizedBox(
          height: 80.0,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                        StyleConstants.customTextStyle12MonsterMedium(
                          color: getMaterialColor(AppColors.textColor2),
                        )),
                    const SizedBox(
                      height: 2.0,
                    ),
                    CommonWidgets().textWidget(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        StyleConstants.customTextStyle34MontserratBold(
                            color: getMaterialColor(AppColors.textColor1)))
                  ],
                ),
              ],
            ),
            const SizedBox(
              width: 51.0,
            ),
            // Amount to return field
            Visibility(
              visible:
                  isPaymentDone == false && paymentModeType == 0 ? true : false,
              child: Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidgets().textWidget(
                          StringConstants.amountReceived,
                          StyleConstants.customTextStyle12MonsterMedium(
                              color: getMaterialColor(AppColors.textColor2))),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonWidgets().textWidget(
                              '\$',
                              StyleConstants.customTextStyle22MonsterMedium(
                                  color:
                                      getMaterialColor(AppColors.textColor1))),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: getMaterialColor(AppColors.whiteColor),
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
                                    style: StyleConstants
                                        .customTextStyle22MonsterMedium(
                                            color: getMaterialColor(
                                                AppColors.textColor1)),
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
              visible:
                  isPaymentDone == false && paymentModeType == 0 ? true : false,
              child: Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidgets().textWidget(
                          StringConstants.amountToReturn,
                          StyleConstants.customTextStyle12MonsterMedium(
                              color: getMaterialColor(AppColors.textColor2))),
                      const SizedBox(height: 10.0),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonWidgets().textWidget(
                                '\$',
                                StyleConstants.customTextStyle22MonsterMedium(
                                    color: getMaterialColor(
                                        AppColors.textColor1))),
                            CommonWidgets().textWidget(
                                returnAmount.toStringAsFixed(2),
                                StyleConstants.customTextStyle22MonsterMedium(
                                    color:
                                        getMaterialColor(AppColors.textColor1)))
                          ])
                    ]),
              ),
            ),
            // Button
            buttonWidget(
                isPaymentDone == true
                    ? StringConstants.newOrder
                    : StringConstants.proceed,
                StyleConstants.customTextStyle12MontserratBold(
                    color: getMaterialColor(AppColors.textColor1))),
          ]),
        ),
      );

  Widget buttonWidget(String buttonText, TextStyle textStyle) {
    bool showDisabledButton =
        !isPaymentDone && receivedAmount < totalAmount && paymentModeType <= 0;
    return GestureDetector(
      onTap: isPaymentDone == false
          ? () {
              onTapProceed(showDisabledButton);
            }
          : onTapNewOrder,
      child: Container(
        decoration: BoxDecoration(
          color: getMaterialColor(showDisabledButton
              ? AppColors.denotiveColor4
              : AppColors.primaryColor2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 28.0),
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }

  Widget leftBodyComponent() => SingleChildScrollView(
        child: Column(children: [
          Visibility(
              visible: !isPaymentDone,
              child: Column(
                children: [
                  paymentModeWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: getMaterialColor(AppColors.gradientColor1)
                          .withOpacity(0.2),
                      thickness: 1,
                    ),
                  ),
                ],
              )),
          SingleChildScrollView(
              child:
                  isPaymentDone ? paymentSuccess(StringConstants.dummyOrder) : const Text('')),
        ]),
      );

  Widget paymentModeWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            paymentModeView(StringConstants.cash, PaymentModeConstants.cash,
                AssetsConstants.cash),
            paymentModeView(
                StringConstants.creditCard,
                PaymentModeConstants.creditCard,
                AssetsConstants.creditCardScan),
            paymentModeView(
                StringConstants.creditCardManual,
                PaymentModeConstants.creditCardManual,
                AssetsConstants.creditCard),
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
                StyleConstants.customTextStyle12MonsterMedium(
                    color: getMaterialColor(AppColors.textColor1))),
          ],
        ),
      );

  Widget paymentSuccess(String transactionId) => Column(
        children: [
          const SizedBox(height: 68.0),
          CommonWidgets().image(
              image: AssetsConstants.success,
              width: 9.3 * SizeConfig.imageSizeMultiplier,
              height: 9.3 * SizeConfig.imageSizeMultiplier),
          const SizedBox(height: 21.0),
          CommonWidgets().textWidget(
              StringConstants.paymentSuccessful,
              StyleConstants.customTextStyle22MonsterMedium(
                  color: getMaterialColor(AppColors.textColor1))),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonWidgets().textWidget(
                '${StringConstants.transactionId}:',
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: getMaterialColor(AppColors.textColor1))),
            CommonWidgets().textWidget(
                transactionId,
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: getMaterialColor(AppColors.textColor1))),
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
              StyleConstants.customTextStyle16MonsterMedium(
                  color: getMaterialColor(AppColors.textColor1))),
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
                          StyleConstants.customTextStyle09MonsterRegular(
                              color: getMaterialColor(AppColors.textColor1))),
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
                            StyleConstants.customTextStyle09MonsterRegular(
                                color: getMaterialColor(AppColors.textColor1))),
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

  Widget emailReceiptWidget() => Container(
        width: 253.0,
        height: 47.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 45.0,
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
                        maxLength: 100,
                        controller: emailController,
                        style:
                            StyleConstants.customTextStyle12MontserratSemiBold(
                                color: getMaterialColor(AppColors.textColor1)),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                emailValidation();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
                child: CommonWidgets().image(
                    image: AssetsConstants.send, width: 25.0, height: 25.0),
              ),
            )
          ],
        ),
      );

  Widget textMessageReceiptWidget() => Container(
        width: 253.0,
        height: 47.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: getMaterialColor(AppColors.gradientColor1),
          border: Border.all(color: getMaterialColor(AppColors.gradientColor1)),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 45.0,
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
                      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                      child: TextField(
                        maxLength: 15,
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style:
                            StyleConstants.customTextStyle12MontserratSemiBold(
                                color: getMaterialColor(AppColors.textColor1)),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                smsValidation();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8.0),
                child: CommonWidgets().image(
                    image: AssetsConstants.send, width: 25.0, height: 25.0),
              ),
            )
          ],
        ),
      );

  Widget countryPicker() => CountryCodePicker(
        onChanged: (value) {
          countryCode = value.toString();
        },
        padding: EdgeInsets.zero,
        textStyle: StyleConstants.customTextStyle12MonsterMedium(
            color: getMaterialColor(AppColors.textColor1)),
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: StringConstants.usCountryCode,
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
  Widget rightSideWidget() => Padding(
        padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.307,
            height: MediaQuery.of(context).size.height * 0.78,
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
                            StyleConstants.customTextStyle22MontserratBold(
                                color:
                                    getMaterialColor(AppColors.textColor1)))),
                    customerNameWidget(
                        customerName:
                            widget.placeOrderRequestModel.getCustomerName()),
                    const SizedBox(height: 7.0),
                    orderDetailsWidget(
                        orderId: orderID,
                        orderDate:
                            widget.placeOrderRequestModel.getOrderDate()),
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
            StyleConstants.customTextStyle12MonsterRegular(
                color: getMaterialColor(AppColors.textColor1))),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle12MontserratBold(
                    color: getMaterialColor(AppColors.textColor1)))),
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
            visible: eventName.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.eventName}: ',
                    StyleConstants.customTextStyle09MonsterRegular(
                        color: getMaterialColor(AppColors.textColor1))),
                Expanded(
                    child: CommonWidgets().textView(
                        eventName,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: getMaterialColor(AppColors.textColor2)))),
              ]),
            ),
          ),
          Visibility(
            visible: email.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.email}: ',
                    StyleConstants.customTextStyle09MonsterRegular(
                        color: getMaterialColor(AppColors.textColor1))),
                Expanded(
                    child: CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: getMaterialColor(AppColors.textColor2)))),
              ]),
            ),
          ),
          Visibility(
            visible: phone.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonWidgets().textView(
                    '${StringConstants.phone}: ',
                    StyleConstants.customTextStyle09MonsterRegular(
                        color: getMaterialColor(AppColors.textColor1))),
                Expanded(
                    child: CommonWidgets().textView(
                        phone,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: getMaterialColor(AppColors.textColor2)))),
              ]),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.storeAddress}: ',
                StyleConstants.customTextStyle09MonsterRegular(
                    color: getMaterialColor(AppColors.textColor1))),
            Expanded(
                child: CommonWidgets().textView(
                    storeAddress,
                    StyleConstants.customTextStyle09MonsterMedium(
                        color: getMaterialColor(AppColors.textColor2)))),
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
              StyleConstants.customTextStyle09MonsterRegular(
                  color: getMaterialColor(AppColors.textColor1))),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle09MonsterMedium(
                  color: getMaterialColor(AppColors.textColor2))),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle09MonsterRegular(
                  color: getMaterialColor(AppColors.textColor1))),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle09MonsterMedium(
                  color: getMaterialColor(AppColors.textColor2))),
        ]),
      ]);

  Widget itemView() => Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.placeOrderRequestModel.orderItemsList!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemViewListItem(
                  orderItem:
                      widget.placeOrderRequestModel.orderItemsList![index]);
            }),
      ]);

  Widget itemViewListItem({required OrderItemsList orderItem}) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: CommonWidgets().textView(
                  orderItem.name!,
                  StyleConstants.customTextStyle12MonsterRegular(
                      color: getMaterialColor(AppColors.textColor1))),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CommonWidgets().textView(
                    "${StringConstants.qty} - ${orderItem.quantity!}",
                    StyleConstants.customTextStyle12MonsterRegular(
                        color: getMaterialColor(AppColors.textColor1))),
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${orderItem.getTotalPrice().toStringAsFixed(2)}",
                  StyleConstants.customTextStyle12MontserratSemiBold(
                      color: getMaterialColor(AppColors.textColor1))),
            ),
          ]),
          Visibility(
            visible: (orderItem.foodExtraItemMappingList ?? []).isNotEmpty,
            child: ListView.builder(
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
                        child: subOrderItemView(orderItem
                                .foodExtraItemMappingList![0]
                                .orderFoodExtraItemDetailDto![innerIndex]
                                .name ??
                            ''),
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

  Widget subOrderItemView(String subItem) => Text(
        subItem,
        style: const TextStyle(fontSize: 10.0),
      );

  Widget componentBill() => Column(
        children: [
          const SizedBox(height: 14.0),
          billTextView(StringConstants.foodCost, foodCost),
          billTextView(StringConstants.salesTax, salesTax),
          billTextView(StringConstants.subTotal, foodCost + salesTax),
          billTextView(StringConstants.tip, tip),
          totalBillView(totalAmount),
          const SizedBox(height: 22.0),
        ],
      );

  Widget billTextView(String billTitle, double itemAmount) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CommonWidgets().textView(
                billTitle,
                StyleConstants.customTextStyle14MonsterMedium(
                    color: getMaterialColor(AppColors.textColor1))),
            Row(
              children: [
                CommonWidgets().textView(
                    "\$",
                    StyleConstants.customTextStyle14MontserratBold(
                        color: getMaterialColor(AppColors.textColor1))),
                CommonWidgets().textView(
                    itemAmount.toStringAsFixed(2),
                    StyleConstants.customTextStyle14MontserratBold(
                        color: getMaterialColor(AppColors.textColor1))),
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
            StyleConstants.customTextStyle20MontserratBold(
                color: getMaterialColor(AppColors.textColor1))),
        CommonWidgets().textView(
            '\$${totalAmount.toStringAsFixed(2)}',
            StyleConstants.customTextStyle24MontserratBold(
                color: getMaterialColor(AppColors.textColor1))),
      ]);

  //Action Event
  onTapPaymentMode(int index) {
    setState(() {
      paymentModeType = index;
      updateSelectedPaymentMode();
    });
    if (paymentModeType == PaymentModeConstants.creditCardManual) {
      showDialog(
          barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
          context: context,
          builder: (context) {
            return CreditCardDetailsPopup(totalAmount: totalAmount.toString());
          }).then((value) {
        debugPrint('>>>>>>>$value');
        bool valueForApi = value[ConstatKeys.cardValue];
        debugPrint('>>>>>>>$valueForApi');
        if (valueForApi == true) {
          String cardNumber = value[ConstatKeys.cardNumber];
          String cardExpiry = value[ConstatKeys.cardExpiry];
          String cardCvv = value[ConstatKeys.cardCvv];
          int valCardExpiry = int.parse(cardExpiry);
          int valCardCvv = int.parse(cardCvv);
          debugPrint('>>>>>>>>>$cardExpiry');
          onTapConfirmPayment(cardNumber, valCardExpiry,valCardCvv);
        }
      });
    }
    if (paymentModeType == PaymentModeConstants.creditCard) {
      performCardPayment();
    }
    getEmailIdPhoneNumber();
  }

  getEmailIdPhoneNumber() {
    setState(() {
      emailController.text =
          widget.placeOrderRequestModel.email ?? StringExtension.empty();
      phoneNumberController.text =
          widget.placeOrderRequestModel.getPhoneNumber();
    });
  }

  Future<void> getFinixdetailsValues() async {
    finixMerchantId = await FunctionalUtils.getFinixMerchantId();
    finixdeviceId = await FunctionalUtils.getFinixDeviceId();
    finixSerialNumber = await FunctionalUtils.getFinixSerialNumber();
    finixUsername = await FunctionalUtils.getFinixUserName();
    finixPassword = await FunctionalUtils.getFinixPassword();
    merchantIdNCP = await FunctionalUtils.getFinixMerchantIdNCP();
  }

  Future performCardPayment() async {
    const String application = AssetsConstants.test;
    const String version =AssetsConstants.appVersion;
    final tags = {
      finixTagsKey.customerEmail:
          widget.placeOrderRequestModel.email ?? StringExtension.empty(),
      finixTagsKey.customerName: widget.placeOrderRequestModel.getCustomerName(),
      finixTagsKey.eventName: widget.events.getEventName(),
      finixTagsKey.eventCode: widget.events.getEventCode(),
      finixTagsKey.environment: StringConstants.test,
      finixTagsKey.paymentMethod: StringConstants.bbpos
    };
    final values = {
      finixTagsKey.username: finixUsername,
      finixTagsKey.password: finixPassword,
      finixTagsKey.application: application,
      finixTagsKey.version: version,
      finixTagsKey.merchantId: finixMerchantId,
      finixTagsKey.deviceID: finixdeviceId,
      finixTagsKey.amount: totalAmount,
      finixTagsKey.serialNumber: finixSerialNumber,
      finixTagsKey.tags: tags
    };
    await cardPaymentChannel.invokeListMethod('performCardPayment', values);
  }

  onTapCloseButton() {
    Navigator.of(context).pop();
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

  onTapCallBack(bool callBack) {}

  //Navigation
  showEventMenuScreen() {
    Navigator.of(context).pop(getOrderInfoToSendBack(isPaymentDone));
  }

  //data for p2pConnection to Customer
  updateSelectedPaymentMode() {
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.paymentModeSelected,
        data: paymentModeType.toString());
  }

  editAndUpdateOrder() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.editOrderDetails);
  }

  updatePaymentSuccess() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.paymentCompleted);
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
    payOrderRequestModel.paymentMethod = PaymentMethods.cash;
    payOrderRequestModel.cardId = StringExtension.empty();

    return payOrderRequestModel;
  }

  PayOrderCardRequestModel getPayOrderCardMethodRequestModel() {
    PayOrderCardRequestModel payOrderCardRequestModel =
        PayOrderCardRequestModel();
    payOrderCardRequestModel.orderId = orderID;
    payOrderCardRequestModel.paymentMethod = PaymentMethods.card;
    payOrderCardRequestModel.stripeCardId = stripeTokenId;
    payOrderCardRequestModel.stripePaymentMethodId = stripePaymentMethodId;

    return payOrderCardRequestModel;
  }

  //API call
  callPlaceOrderAPI({bool isPreviousRequestFail = false}) async {
    orderPresenter.placeOrder(widget.placeOrderRequestModel);
  }

  //API call for card payment method
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
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
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
      phoneNumberController.clear();
      emailController.clear();
    } else {
      setState(() {
        updatePaymentSuccess();
        isPaymentDone = true;
      });
      clearOderData();
    }
  }

  @override
  void showErrorForPlaceOrder(GeneralErrorResponse exception) {
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
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
      if (paymentModeType == PaymentModeConstants.creditCard) {
        onTapPaymentMode(paymentModeType);
      }
    } else if (response.action == CustomerActionConst.editOrderDetails) {
      showEventMenuScreen();
    }
  }

  //FinixMannual CardDetails
  onTapConfirmPayment(
      String cardNumber, int expirationMonthYear,int cardCvvNumber) async {
    final valuesCardDetails = {
      cardDetails.cardNumber: cardNumber,
      cardDetails.expirationMonthYear: expirationMonthYear,
      cardDetails.cardCvv:cardCvvNumber

    };
    debugPrint(valuesCardDetails.toString());
    await cardPaymentChannel.invokeListMethod(
        'getPaymentToken', valuesCardDetails);
  }


  //ApiCall After getting Manual Card token
  finixManualApiCall() {
    getPayReceiptModel(true);
  }

  PayReceipt getPayReceiptModel(bool paymentMethodCall) {
    PayReceipt payReceiptModel = PayReceipt();
    FinixResponseDto finixResponseDto = FinixResponseDto();
    FinixSaleReciptResponseRequest finixSaleReciptResponseRequest =
        FinixSaleReciptResponseRequest();
    FinixSaleReceiptRequest finixSaleReceiptRequest = FinixSaleReceiptRequest();

    payReceiptModel.orderId = orderID;
    payReceiptModel.paymentMethod = PaymentMethods.bbpos;
    finixSaleReciptResponseRequest.transferId =
        finixResponse.finixSaleResponse?.transferId;
    finixSaleReciptResponseRequest.updated =
        finixResponse.finixSaleResponse?.updated;
    finixSaleReciptResponseRequest.amount =
        finixResponse.finixSaleResponse?.amount;
    finixSaleReciptResponseRequest.cardLogo =
        finixResponse.finixSaleResponse?.cardLogo;
    finixSaleReciptResponseRequest.cardHolderName =
        finixResponse.finixSaleResponse?.cardHolderName;
    finixSaleReciptResponseRequest.expirationMonth =
        finixResponse.finixSaleResponse?.expirationMonth;

    ResourceTagsRequest resourceTagsRequest = ResourceTagsRequest();
    resourceTagsRequest.customerEmail =
        widget.placeOrderRequestModel.email ?? StringExtension.empty();
    resourceTagsRequest.customerName =
        widget.placeOrderRequestModel.getPhoneNumber();
    resourceTagsRequest.eventName = widget.events.getEventName();
    resourceTagsRequest.eventCode = widget.events.getEventCode();
    resourceTagsRequest.environment = ""; //***********
    resourceTagsRequest.paymentMethod = ""; //***********

    finixSaleReciptResponseRequest.entryMode =
        finixResponse.finixSaleResponse?.entryMode;
    finixSaleReciptResponseRequest.maskedAccountNumber =
        finixResponse.finixSaleResponse?.maskedAccountNumber;
    finixSaleReciptResponseRequest.created =
        finixResponse.finixSaleResponse?.created;
    finixSaleReciptResponseRequest.traceId =
        finixResponse.finixSaleResponse?.traceId;
    finixSaleReciptResponseRequest.transferState =
        finixResponse.finixSaleResponse?.transferState;
    finixSaleReciptResponseRequest.expirationYear =
        finixResponse.finixSaleResponse?.expirationYear;

    finixSaleReceiptRequest.cryptogram =
        finixResponse.finixSaleReceipt?.cryptogram;
    finixSaleReceiptRequest.merchantId =
        finixResponse.finixSaleReceipt?.merchantId;
    finixSaleReceiptRequest.accountNumber =
        finixResponse.finixSaleReceipt?.accountNumber;
    finixSaleReceiptRequest.referenceNumber =
        finixResponse.finixSaleReceipt?.referenceNumber;
    finixSaleReceiptRequest.applicationLabel =
        finixResponse.finixSaleReceipt?.applicationLabel;
    finixSaleReceiptRequest.entryMode =
        finixResponse.finixSaleReceipt?.entryMode;
    finixSaleReceiptRequest.approvalCode =
        finixResponse.finixSaleReceipt?.approvalCode;
    finixSaleReceiptRequest.transactionId =
        finixResponse.finixSaleReceipt?.transactionId;
    finixSaleReceiptRequest.cardBrand =
        finixResponse.finixSaleReceipt?.cardBrand;
    finixSaleReceiptRequest.merchantName =
        finixResponse.finixSaleReceipt?.merchantName;
    finixSaleReceiptRequest.merchantAddress =
        finixResponse.finixSaleReceipt?.merchantAddress;
    finixSaleReceiptRequest.responseCode =
        finixResponse.finixSaleReceipt?.responseCode;
    finixSaleReceiptRequest.transactionType =
        finixResponse.finixSaleReceipt?.transactionType;
    finixSaleReceiptRequest.responseMessage =
        finixResponse.finixSaleReceipt?.responseMessage;
    finixSaleReceiptRequest.applicationIdentifier =
        finixResponse.finixSaleReceipt?.applicationIdentifier;
    finixSaleReceiptRequest.date = finixResponse.finixSaleReceipt?.date;

    finixResponseDto.finixSaleResponse = finixSaleReciptResponseRequest;
    finixResponseDto.finixSaleResponse?.resourceTags = resourceTagsRequest;
    finixResponseDto.finixSaleReceipt = finixSaleReceiptRequest;
    payReceiptModel.finixResponseDto = finixResponseDto;

    debugPrint('>>>>>>>>>>>${payReceiptModel.toString()}');

    if (paymentMethodCall == true) {
      payReceiptModel.paymentMethod = PaymentMethods.creditCard;
      payReceiptModel.orderId = orderID;
      payReceiptModel.stripePaymentMethodId = null;
      payReceiptModel.stripeCardId = null;
      payReceiptModel.finixNCPaymentToken = finixNCPaymentToken;
      payReceiptModel.finixNCPMerchantId = merchantIdNCP;
    }

    setState(() {
      isApiProcess = true;
    });
    orderPresenter.finixReceipt(payReceiptModel);
    return payReceiptModel;
  }

  emailValidation() {
    if (emailController.text.isEmpty) {
      setState(() {
        emailValidationMessage = StringConstants.emptyValidEmail;
        validationPopup(emailValidationMessage);
      });
      return false;
    }
    if (!emailController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = StringConstants.enterValidEmail;
        validationPopup(emailValidationMessage);
      });
      return false;
    }
    if (emailController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = "";
        sendReciptMailOrSmsApiCall("", "", emailController.text);
      });
      return true;
    }
  }

  smsValidation() {
    if (phoneNumberController.text.isEmpty) {
      setState(() {
        smsValidationMessage = StringConstants.emptyContactNumber;
        validationPopup(smsValidationMessage);
      });
      return false;
    }
    if (phoneNumberController.text.isNotEmpty) {
      setState(() {
        smsValidationMessage = "";
        sendReciptMailOrSmsApiCall(countryCode, phoneNumberController.text, "");
      });
      return true;
    }
  }

  validationPopup(String validationMessage) {
    showDialog(
        barrierColor: getMaterialColor(AppColors.textColor1).withOpacity(0.7),
        context: context,
        builder: (context) {
          return ValidationPopup(validationMessage: validationMessage);
        });
  }

  void sendReciptMailOrSmsApiCall(
      String countryCode, String phoneNumber, String emailAddress) {
    FinixSendReceiptRequest finixSendReceiptRequest = FinixSendReceiptRequest();
    finixSendReceiptRequest.phoneNumCountryCode = countryCode;
    finixSendReceiptRequest.phoneNumber = phoneNumber;
    finixSendReceiptRequest.email = emailAddress;
    setState(() {
      isApiProcess = true;
    });
    orderPresenter.finixSendReceipt(orderID, finixSendReceiptRequest);
  }
}

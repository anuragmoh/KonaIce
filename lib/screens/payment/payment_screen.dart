import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/app_constant.dart';
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
import 'package:kona_ice_pos/network/repository/payment/finix_auth_response_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_presenter.dart';
import 'package:kona_ice_pos/network/repository/payment/payreceipt_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payrecipt_finix_model.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile.dart';
import 'package:kona_ice_pos/screens/payment/payment_fails_popup.dart';
import 'package:kona_ice_pos/screens/payment/validation_popup.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/color_extension.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/dotted_line.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/top_bar.dart';

import '../../utils/function_utils.dart';
import '../../utils/number_formatter.dart';
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
  int _paymentModeType = -1;
  double _returnAmount = 0.0;
  double _receivedAmount = 0.0;
  double totalAmount = 0.0;
  num _tip = 0.0;
  double _salesTax = 0.0;
  double _discount = 0.0;
  double _foodCost = 0.0;
  bool _isPaymentDone = false;
  int _receiptMode = 1;
  String _orderID = StringConstants.na;
  String _finixMerchantId = StringExtension.empty();
  String _finixdeviceId = StringExtension.empty();
  String _finixSerialNumber = StringExtension.empty();
  String _finixUsername = StringExtension.empty();
  String _finixPassword = StringExtension.empty();
  String _merchantIdNCP = StringExtension.empty();
  String _finixNCPaymentToken = StringExtension.empty();
  String _paymentFailMessage = StringExtension.empty();
  String _stripeTokenId = "", _stripePaymentMethodId = "";
  String _emailValidationMessage = "";
  String _smsValidationMessage = "";
  String _paymentStatusValue = "";
  bool _isAnimation = false;
  String _countryCode = StringConstants.usCountryCode;

  // FinixResponseModel _finixResponse = FinixResponseModel();
  FinixAuthResponseModel _finixResponse = FinixAuthResponseModel();

  TextEditingController _amountReceivedController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  int _currentIndex = 0;
  late OrderPresenter _orderPresenter;
  bool _isApiProcess = false;
  PlaceOrderResponseModel _placeOrderResponseModel = PlaceOrderResponseModel();
  late PaymentPresenter _paymentPresenter;

  static const MethodChannel _cardPaymentChannel =
      MethodChannel("com.mobisoft.konaicepos/cardPayment");

  _PaymentScreenState() {
    _orderPresenter = OrderPresenter(this);
    P2PConnectionManager.shared.getP2PContractor(this);
    _paymentPresenter = PaymentPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    totalAmount = widget.billDetails['totalAmount'];
    _tip = widget.billDetails['tip'];
    debugPrint('>>>>>>>>>>>>$_tip');
    _discount = widget.billDetails['discount'];
    _foodCost = widget.billDetails['foodCost'];
    _salesTax = widget.billDetails['salesTax'];
    if (widget.placeOrderRequestModel.id != null &&
        widget.placeOrderRequestModel.id!.isNotEmpty) {
      _orderID = widget.placeOrderRequestModel.id!;
    }
    _getFinixdetailsValues();
    _callPlaceOrderAPI();
    _cardPaymentChannel.setMethodCallHandler((call) async {
      debugPrint("init state setMethodCallHandler ${call.method}");
      if (call.method == "paymentSuccess") {
        _paymentSuccess(call.arguments.toString());
      } else if (call.method == "paymentFailed") {
        _paymentFailed();
      } else if (call.method == "paymentStatus") {
        _paymentStatus(call.arguments.toString());
      } else if (call.method == "getPaymentToken") {
        _getPaymentToken(call.arguments.first);
      }
    });
  }

  _paymentSuccess(msg) async {
    debugPrint("Payment Success: $msg");
    setState(() {
      _updatePaymentSuccess();
      _isPaymentDone = true;
    });
    _finixResponse = finixAuthResponseModelFromJson(msg);
    // _finixResponse = finixResponseFromJson(msg);
    _paymentStatusValue = 'paymentSuccess';
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.paymentStatus,
        data: _paymentStatusValue.toString());
    //Finix recipt Api Call
    PayReceipt payReceipt = _getPayReceiptModel(false);
  }

  _paymentFailed() async {
    debugPrint("Payment Failure");
    showDialog(
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return PaymentFailPopup(paymentFailMessage: _paymentFailMessage);
        });
  }

  _paymentStatus(status) async {
    debugPrint("Payment Status1: $status");
    _paymentStatusValue = 'paymentStatus';
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.paymentStatus,
        data: status);
  }

  _getPaymentToken(token) async {
    debugPrint("Payment Token: $token");
    _finixNCPaymentToken = token;

    if (token.toString().isNotEmpty) {
      _finixManualApiCall();
    } else {
      CommonWidgets().showErrorSnackBar(
          errorMessage: StringConstants.somethingWentWrong, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textColor3.withOpacity(0.2),
        child: _buildMainColumn(),
      ),
    );
  }

  Column _buildMainColumn() {
    return Column(
      children: [
        TopBar(
          userName: widget.userName,
          eventName: widget.events.getEventName(),
          eventAddress: widget.events.getEventAddress(),
          showCenterWidget: false,
          onTapCallBack: _onTapCallBack,
          //    onDrawerTap: onDrawerTap,
          onProfileTap: _onProfileChange,
        ),

        Expanded(child: _bodyWidget()),
        BottomBarWidget(
          onTapCallBack: _onTapBottomListItem,
          accountImageVisibility: false,
          isFromDashboard: false,
        )
        // CommonWidgets().bottomBar(false),
      ],
    );
  }

  _onProfileChange() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyProfile()));
  }

  Widget _bodyWidget() => Container(
        color: AppColors.textColor3.withOpacity(0.1),
        child: _bodyWidgetComponent(),
      );

  Widget _bodyWidgetComponent() => Row(children: [
        _leftSideWidget(),
        _rightSideWidget(),
      ]);

  Widget _leftSideWidget() => Expanded(
          child: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 14.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: _leftSideTopComponent(totalAmount),
            ),
            // leftSideTopComponent(totalAmount),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: AppColors.gradientColor1.withOpacity(0.2),
                thickness: 1,
              ),
            ),
            Expanded(child: _leftBodyComponent()),
          ]),
          // Center(
          //   child: Visibility(
          //       visible: (_paymentModeType ==
          //           PaymentModeConstants.creditCard) || (_paymentModeType ==
          //           PaymentModeConstants.creditCardManual),
          //       child: Lottie.asset(
          //           _paymentStatusValue == 'insert' ? AssetsConstants
          //               .insertCardAnimationPath : _paymentStatusValue == 'progress'
          //               ? AssetsConstants.progressAnimationPath
          //               : AssetsConstants.removeCardAnimationPath,
          //           height: 150, width: 150)),
          // ),
        ],
      ));

  Widget _leftSideTopComponent(double totalAmount) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SizedBox(
          height: 80.0,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInkWell(),
                const SizedBox(
                  width: 22.0,
                ),
                _buildColumn(totalAmount),
              ],
            ),
            const SizedBox(
              width: 51.0,
            ),
            // Amount to return field
            Visibility(
              visible: _isPaymentDone == false && _paymentModeType == 0
                  ? true
                  : false,
              child: Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidgets().textWidget(
                          StringConstants.amountReceived,
                          StyleConstants.customTextStyle12MonsterMedium(
                              color: AppColors.textColor2)),
                      const SizedBox(
                        height: 5.0,
                      ),
                      _buildRow()
                    ]),
              ),
            ),
            // Return Amount
            const SizedBox(
              width: 15.0,
            ),
            Visibility(
              visible: _isPaymentDone == false && _paymentModeType == 0
                  ? true
                  : false,
              child: Expanded(
                child: _buildColumn2(),
              ),
            ),
            // Button
            _buttonWidget(
                _isPaymentDone == true
                    ? StringConstants.newOrder
                    : StringConstants.proceed,
                StyleConstants.customTextStyle12MontserratBold(
                    color: AppColors.textColor1)),
          ]),
        ),
      );

  Column _buildColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().textWidget(
            StringConstants.amountToReturn,
            StyleConstants.customTextStyle12MonsterMedium(
                color: AppColors.textColor2)),
        const SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonWidgets().textWidget(
                '\$',
                StyleConstants.customTextStyle22MonsterMedium(
                    color: AppColors.textColor1)),
            Expanded(
              child: CommonWidgets().textWidget(
                  _returnAmount.toStringAsFixed(2),
                  StyleConstants.customTextStyle22MonsterMedium(
                      color: AppColors.textColor1.toMaterialColor())),
            )
          ],
        )
      ],
    );
  }

  Row _buildRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonWidgets().textWidget(
            '\$',
            StyleConstants.customTextStyle22MonsterMedium(
                color: AppColors.textColor1)),
        const SizedBox(
          width: 10.0,
        ),
        _buildContainer(),
      ],
    );
  }

  Container _buildContainer() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.primaryColor2)),
        width: 72.0,
        height: 49.0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
            child: TextField(
              controller: _amountReceivedController,
              style: StyleConstants.customTextStyle22MonsterMedium(
                  color: AppColors.textColor1),
              keyboardType: TextInputType.number,
              maxLength: 5,
              inputFormatters: <TextInputFormatter>[
                NumberRemoveExtraDotFormatter(),
              ],
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _onAmountEnter(double.parse(value));
                }
              },
            ),
          ),
        ));
  }

  Column _buildColumn(double totalAmount) {
    return Column(
      children: [
        CommonWidgets().textWidget(
            StringConstants.totalAmount,
            StyleConstants.customTextStyle12MonsterMedium(
              color: AppColors.textColor2,
            )),
        const SizedBox(
          height: 2.0,
        ),
        CommonWidgets().textWidget(
            '\$${totalAmount.toStringAsFixed(2)}',
            StyleConstants.customTextStyle34MontserratBold(
                color: AppColors.textColor1))
      ],
    );
  }

  InkWell _buildInkWell() {
    return InkWell(
      onTap: () {
        _onTapBackButton();
      },
      child: CommonWidgets()
          .image(image: AssetsConstants.backArrow, width: 25.0, height: 25.0),
    );
  }

  Widget _buttonWidget(String buttonText, TextStyle textStyle) {
    bool showDisabledButton = !_isPaymentDone &&
        _receivedAmount < totalAmount &&
        _paymentModeType <= 0;
    return GestureDetector(
      onTap: _isPaymentDone == false
          ? () {
              _onTapProceed(showDisabledButton);
            }
          : _onTapNewOrder,
      child: Container(
        decoration: BoxDecoration(
          color: showDisabledButton
              ? AppColors.denotiveColor4
              : AppColors.primaryColor2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 28.0),
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }

  Widget _leftBodyComponent() => SingleChildScrollView(
        child: Column(children: [
          Visibility(
              visible: !_isPaymentDone,
              child: Column(
                children: [
                  _paymentModeWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: AppColors.gradientColor1.withOpacity(0.2),
                      thickness: 1,
                    ),
                  ),
                ],
              )),
          SingleChildScrollView(
              child: _isPaymentDone
                  ? paymentSuccess(StringConstants.dummyOrder)
                  : const Text('')),
        ]),
      );

  Widget _paymentModeWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _paymentModeView(StringConstants.cash, PaymentModeConstants.cash,
                AssetsConstants.cash),
            _paymentModeView(
                StringConstants.creditCard,
                PaymentModeConstants.creditCard,
                AssetsConstants.creditCardScan),
/*            _paymentModeView(
                StringConstants.creditCardManual,
                PaymentModeConstants.creditCardManual,
                AssetsConstants.creditCard),*/
          ],
        ),
      );

  Widget _paymentModeView(String title, int index, String icon) =>
      GestureDetector(
        onTap: () {
          _onTapPaymentMode(index);
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: _paymentModeType == index
                      ? AppColors.primaryColor2
                      : null,
                  border: Border.all(color: AppColors.primaryColor2),
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
                    color: AppColors.textColor1)),
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
                  color: AppColors.textColor1)),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonWidgets().textWidget(
                '${StringConstants.transactionId}:',
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: AppColors.textColor1)),
            CommonWidgets().textWidget(
                transactionId,
                StyleConstants.customTextStyle12MontserratSemiBold(
                    color: AppColors.textColor1)),
          ]),
          const SizedBox(height: 38.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 135.0),
            child: Divider(
              color: AppColors.gradientColor1.withOpacity(0.2),
              thickness: 1,
            ),
          ),
          const SizedBox(height: 28.0),
          CommonWidgets().textWidget(
              StringConstants.howWouldYouLikeToReceiveTheReceipt,
              StyleConstants.customTextStyle16MonsterMedium(
                  color: AppColors.textColor1)),
          const SizedBox(height: 12.0),
          Visibility(
            visible: false,
            child: Container(
              width: 203.0,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: AppColors.primaryColor2)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _receiptMode = 1;
                      });
                    },
                    child: _buildContainer1(),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _receiptMode = 2;
                      });
                    },
                    child: _buildContainer2(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 19.0),
          _receiptMode == 1
              ? _emailReceiptWidget()
              : _textMessageReceiptWidget(),
          const SizedBox(height: 20.0),
        ],
      );

  Container _buildContainer1() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: _receiptMode == 1 ? AppColors.primaryColor2 : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 9.0),
        child: CommonWidgets().textWidget(
            StringConstants.email,
            StyleConstants.customTextStyle09MonsterRegular(
                color: AppColors.textColor1)),
      ),
    );
  }

  Container _buildContainer2() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: _receiptMode == 2 ? AppColors.primaryColor2 : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 9.0),
          child: CommonWidgets().textWidget(
              StringConstants.textMessage,
              StyleConstants.customTextStyle09MonsterRegular(
                  color: AppColors.textColor1)),
        ));
  }

  Widget _emailReceiptWidget() => Container(
        width: 253.0,
        height: 47.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: AppColors.gradientColor1,
          border: Border.all(color: AppColors.gradientColor1),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 45.0,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: AppColors.gradientColor1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0, left: 4.0),
                      child: TextField(
                        maxLength: 100,
                        controller: _emailController,
                        style:
                            StyleConstants.customTextStyle12MontserratSemiBold(
                                color: AppColors.textColor1),
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterEmailId,
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
                _emailValidation();
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

  Widget _textMessageReceiptWidget() => Container(
        width: 253.0,
        height: 47.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: AppColors.gradientColor1,
          border: Border.all(color: AppColors.gradientColor1),
        ),
        child: Row(
          children: [
            Container(
              width: 203.0,
              height: 45.0,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // border: Border.all(color: AppColors.gradientColor1),
              ),
              child: Row(
                children: [
                  SizedBox(width: 50.0, child: _countryPicker()),
                  Container(
                    width: 1.0,
                    height: 20.0,
                    color: AppColors.primaryColor1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                      child: TextField(
                        maxLength: 15,
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style:
                            StyleConstants.customTextStyle12MontserratSemiBold(
                                color: AppColors.textColor1),
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
                _smsValidation();
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

  Widget _countryPicker() => CountryCodePicker(
        onChanged: (value) {
          _countryCode = value.toString();
        },
        padding: EdgeInsets.zero,
        textStyle: StyleConstants.customTextStyle12MonsterMedium(
            color: AppColors.textColor1),
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

  _onAmountEnter(double value) {
    _receivedAmount = value;
    if (value > totalAmount) {
      setState(() {
        _returnAmount = value - totalAmount;
      });
    } else {
      setState(() {
        _returnAmount = 0.0;
      });
    }
  }

  // Right side panel design
  Widget _rightSideWidget() => Padding(
        padding: const EdgeInsets.only(top: 21.0, right: 18.0, bottom: 18.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.307,
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
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
                                color: AppColors.textColor1))),
                    _customerNameWidget(
                        customerName:
                            widget.placeOrderRequestModel.getCustomerName()),
                    const SizedBox(height: 7.0),
                    _orderDetailsWidget(
                        orderId: _orderID,
                        orderDate:
                            widget.placeOrderRequestModel.getOrderDate()),
                    const SizedBox(height: 8.0),
                    _customerDetailsComponent(
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
                            color: AppColors.whiteColor, child: _itemView()),
                      ),
                    ),
                    DottedLine(height: 2.0, color: AppColors.textColor1),
                    _componentBill(),
                  ]),
            ),
          ),
        ),
      );

  // customer Name
  Widget _customerNameWidget({required String customerName}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CommonWidgets().textView(
            '${StringConstants.customerName} - ',
            StyleConstants.customTextStyle12MonsterRegular(
                color: AppColors.textColor1)),
        Expanded(
            child: CommonWidgets().textView(
                customerName,
                StyleConstants.customTextStyle12MontserratBold(
                    color: AppColors.textColor1))),
      ]);

  // customer Details
  Widget _customerDetailsComponent(
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
                        color: AppColors.textColor1)),
                Expanded(
                    child: CommonWidgets().textView(
                        eventName,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: AppColors.textColor2))),
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
                        color: AppColors.textColor1)),
                Expanded(
                    child: CommonWidgets().textView(
                        email,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: AppColors.textColor2))),
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
                        color: AppColors.textColor1)),
                Expanded(
                    child: CommonWidgets().textView(
                        phone,
                        StyleConstants.customTextStyle09MonsterMedium(
                            color: AppColors.textColor2))),
              ]),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonWidgets().textView(
                '${StringConstants.storeAddress}: ',
                StyleConstants.customTextStyle09MonsterRegular(
                    color: AppColors.textColor1)),
            Expanded(
                child: CommonWidgets().textView(
                    storeAddress,
                    StyleConstants.customTextStyle09MonsterMedium(
                        color: AppColors.textColor2))),
          ]),
        ],
      );

  // Widget orderDetails
  Widget _orderDetailsWidget(
          {required String orderId, required String orderDate}) =>
      Column(children: [
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderId,
              StyleConstants.customTextStyle09MonsterRegular(
                  color: AppColors.textColor1)),
          CommonWidgets().textView(
              ' #$orderId',
              StyleConstants.customTextStyle09MonsterMedium(
                  color: AppColors.textColor2)),
        ]),
        const SizedBox(height: 8.0),
        Row(children: [
          CommonWidgets().textView(
              StringConstants.orderDate,
              StyleConstants.customTextStyle09MonsterRegular(
                  color: AppColors.textColor1)),
          CommonWidgets().textView(
              ' $orderDate',
              StyleConstants.customTextStyle09MonsterMedium(
                  color: AppColors.textColor2)),
        ]),
      ]);

  Widget _itemView() => Column(children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.placeOrderRequestModel.orderItemsList!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _itemViewListItem(
                  orderItem:
                      widget.placeOrderRequestModel.orderItemsList![index]);
            }),
      ]);

  Widget _itemViewListItem({required OrderItemsList orderItem}) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: CommonWidgets().textView(
                  orderItem.name!,
                  StyleConstants.customTextStyle12MonsterRegular(
                      color: AppColors.textColor1)),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CommonWidgets().textView(
                    "${StringConstants.qty} - ${orderItem.quantity!}",
                    StyleConstants.customTextStyle12MonsterRegular(
                        color: AppColors.textColor1)),
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonWidgets().textView(
                  "\$${orderItem.getTotalPrice().toStringAsFixed(2)}",
                  StyleConstants.customTextStyle12MontserratSemiBold(
                      color: AppColors.textColor1)),
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
                        child: _subOrderItemView(orderItem
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

  Widget _subOrderItemView(String subItem) => Text(
        subItem,
        style: const TextStyle(fontSize: 10.0),
      );

  Widget _componentBill() => Column(
        children: [
          const SizedBox(height: 14.0),
          _billTextView(StringConstants.foodCost, _foodCost),
          _billTextView(StringConstants.salesTax, _salesTax),
          _billTextView(StringConstants.subTotal, _foodCost + _salesTax),
          _billTextView(StringConstants.tip, _tip),
          _totalBillView(totalAmount),
          const SizedBox(height: 22.0),
        ],
      );

  Widget _billTextView(String billTitle, num itemAmount) => Column(
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CommonWidgets().textView(
            '${StringConstants.billTotal}:',
            StyleConstants.customTextStyle20MontserratBold(
                color: AppColors.textColor1)),
        CommonWidgets().textView(
            '\$${totalAmount.toStringAsFixed(2)}',
            StyleConstants.customTextStyle24MontserratBold(
                color: AppColors.textColor1)),
      ]);

  //Action Event
  _onTapPaymentMode(int index) {
    setState(() {
      _paymentModeType = index;
      _updateSelectedPaymentMode();
    });
    if (_paymentModeType == PaymentModeConstants.creditCardManual) {
/*      String msg="{\"authorizationResponseModel\":{\"finixAuthorizationResponse\":{\"transferId\":\"AUke6WrvA5BCsyTf7dG9MKN6\",\"updated\":1656068927.09,\"amount\":4.4,\"cardLogo\":\"Visa\",\"cardHolderName\":\"TESTCARD07\",\"expirationMonth\":\"12\",\"resourceTags\":{\"environment\":\"TestCertification\",\"eventCode\":\"F00181787\",\"paymentMethod\":\"BBPOS\",\"customerEmail\":\"\",\"eventName\":\"RAZZLEDAZZLE\",\"customerName\":\"GuestCustomer\"},\"emv\":\"applicationidentifier:A000000003101001\\napplicationLabel:VISACREDIT\\napplicationPreferredName:Notpresent\\ncryptogram:ARQCDB7FBB82548E0E6F\\napplicationTransactionCounter:0128\\ntags:Notpresent\\nissuerCodeTableIndex:Notpresent\",\"hostResponse\":\"expressResponseCode:0\\nexpressResponseMessage:Approved\\nexpressTransactionDate:20220624\\nexpressTransactionTime:060843\\nexpressTransactionTimezone:UTC-05:00:00\\nhostResponseCode:00\\nhostResponseMessage:\\nprocessorName:VANTIV_TEST\\ntransactionID:157507468\\napprovalNumber:28345A\\nnetworkLabel:\\nexpressResponseXml:\\n<CreditCardAuthorizationResponsexmlns='https://transaction.elementexpress.com'><Response><ExpressResponseCode>0</ExpressResponseCode><ExpressResponseMessage>Approved</ExpressResponseMessage><HostResponseCode>00</HostResponseCode><ExpressTransactionDate>20220624</ExpressTransactionDate><ExpressTransactionTime>060843</ExpressTransactionTime><ExpressTransactionTimezone>UTC-05:00:00</ExpressTransactionTimezone><Batch><HostBatchID>1</HostBatchID></Batch><Card><ExpirationMonth>12</ExpirationMonth><ExpirationYear>22</ExpirationYear><CardLogo>Visa</CardLogo><EMVData>kQqKf02i0lZpyjAwigIwMA==</EMVData><CardNumberMasked>xxxx-xxxx-xxxx-0076</CardNumberMasked><BIN>476173</BIN><CardLevelResults>A</CardLevelResults></Card><Transaction><TransactionID>157507468</TransactionID><ApprovalNumber>28345A</ApprovalNumber><ReferenceNumber>FNXv1ZEjjm1JUJVbMtpQyDMcD</ReferenceNumber><AcquirerData>507468|217506507468|0624110843|1042000314|N|5|002175401248760|0000||||||||A|||||||00|0520|060843|||||||M18203|0624||||||||</AcquirerData><ProcessorName>VANTIV_TEST</ProcessorName><TransactionStatus>Authorized</TransactionStatus><TransactionStatusCode>5</TransactionStatusCode><HostTransactionID>010000</HostTransactionID><ApprovedAmount>4.40</ApprovedAmount><NetworkTransactionID>002175401248760</NetworkTransactionID><PAR>V0010013820179861073690933044</PAR><RetrievalReferenceNumber>217506507468</RetrievalReferenceNumber><SystemTraceAuditNumber>507468</SystemTraceAuditNumber></Transaction><Terminal><MotoECICode>1</MotoECICode></Terminal></Response></CreditCardAuthorizationResponse>\",\"entryMode\":\"Icc\",\"maskedAccountNumber\":\"476173******0076\",\"created\":1656068917.26,\"traceId\":\"FNXv1ZEjjm1JUJVbMtpQyDMcD\",\"transferState\":\"succeeded\",\"expirationYear\":\"22\"},\"finixAuthorizationReceipt\":{\"cryptogram\":\"ARQCDB7FBB82548E0E6F\",\"merchantId\":\"ID3s4MqoJDJ43pinKMsFHs7q\",\"accountNumber\":\"476173******0076\",\"referenceNumber\":\"AUke6WrvA5BCsyTf7dG9MKN6\",\"applicationLabel\":\"VISACREDIT\",\"entryMode\":\"Icc\",\"approvalCode\":\"28345A\",\"transactionId\":\"AUke6WrvA5BCsyTf7dG9MKN6\",\"cardBrand\":\"Visa\",\"merchantName\":\"KonaSchoolSide\",\"merchantAddress\":\"741DouglassStApartment8SanMateoCA94114\",\"responseCode\":\"00\",\"transactionType\":\"Sale\",\"responseMessage\":\"\",\"applicationIdentifier\":\"A000000003101001\",\"date\":1656068923}},\"tipAmount\":3,\"finixCaptureResponse\":{\"amount\":7.4,\"deviceId\":\"DVqrsA5EWLDfJUDs3JSpvqrq\",\"updated\":1656068931.76,\"traceId\":\"FNXv1ZEjjm1JUJVbMtpQyDMcD\",\"created\":1656068930.69,\"transferId\":\"TRnjb2bDDT3gh9JnRD8rjxi6\",\"resourceTags\":{},\"transferState\":\"succeeded\"}}";

      _paymentSuccess(msg);*/
      showDialog(
          barrierColor: AppColors.textColor1.withOpacity(0.7),
          context: context,
          builder: (context) {
            return CreditCardDetailsPopup(totalAmount: totalAmount.toString());
          }).then((value) {
        debugPrint('>>>>>>>$value');
        if (value.toString() == 'false') {
          setState(() {
            _paymentModeType = -1;
          });
        }
        bool valueForApi = value[ConstantKeys.cardValue];
        debugPrint('>>>>>>>$valueForApi');
        if (valueForApi == true) {
          String cardNumberStr = value[ConstantKeys.cardNumber];
          String cardExpiry = value[ConstantKeys.cardExpiry];
          int cardExpiryMonth = value[ConstantKeys.cardMonth];
          String zipcodeString = value[ConstantKeys.zipcode];
          String cardCvv = value[ConstantKeys.cardCvv];
          int valCardExpiry = int.parse(cardExpiry);
          int valCardCvv = int.parse(cardCvv);
          String zipcode = zipcodeString;
          debugPrint('>>>>>>>>>$cardExpiry');
          _onTapConfirmPayment(cardNumberStr, valCardExpiry, valCardCvv,
              cardExpiryMonth, zipcode);
        }
      });
    }
    if (_paymentModeType == PaymentModeConstants.creditCard) {
      _paymentStatusValue = 'progress';
      P2PConnectionManager.shared.updateData(
          action: StaffActionConst.paymentStatus,
          data: _paymentStatusValue.toString());
      _performCardPayment();
    }
    _getEmailIdPhoneNumber();
  }

  _getEmailIdPhoneNumber() {
    setState(() {
      _emailController.text =
          widget.placeOrderRequestModel.email ?? StringExtension.empty();
      debugPrint("?????????????????${widget.placeOrderRequestModel.email}");
      _phoneNumberController.text =
          widget.placeOrderRequestModel.getPhoneNumber();
    });
  }

  Future<void> _getFinixdetailsValues() async {
    _finixMerchantId = await FunctionalUtils.getFinixMerchantId();
    _finixdeviceId = await FunctionalUtils.getFinixDeviceId();
    _finixSerialNumber = await FunctionalUtils.getFinixSerialNumber();
    _finixUsername = await FunctionalUtils.getFinixUserName();
    _finixPassword = await FunctionalUtils.getFinixPassword();
    _merchantIdNCP = await FunctionalUtils.getFinixMerchantIdNCP();
  }

  Future _performCardPayment() async {
    const String application = AssetsConstants.test;
    const String version = AssetsConstants.appVersion;
    final tags = {
      FinixTagsKey.customerEmail.name:
          widget.placeOrderRequestModel.email ?? StringExtension.empty(),
      FinixTagsKey.customerName.name:
          widget.placeOrderRequestModel.getCustomerName(),
      FinixTagsKey.eventName.name: widget.events.getEventName(),
      FinixTagsKey.eventCode.name: widget.events.getEventCode(),
      FinixTagsKey.environment.name: StringConstants.test,
      FinixTagsKey.paymentMethod.name: StringConstants.bbpos
    };
    final values = {
      FinixTagsKey.username.name: _finixUsername,
      FinixTagsKey.password.name: _finixPassword,
      FinixTagsKey.application.name: application,
      FinixTagsKey.version.name: version,
      FinixTagsKey.merchantId.name: _finixMerchantId,
      FinixTagsKey.deviceID.name: _finixdeviceId,
      FinixTagsKey.amount.name: totalAmount,
      FinixTagsKey.serialNumber.name: _finixSerialNumber,
      FinixTagsKey.tags.name: tags
    };
    await _cardPaymentChannel.invokeListMethod('performCardPayment', values);
  }

  _onTapNewOrder() {
    if (_isPaymentDone) {
      Navigator.of(context).pop(_getOrderInfoToSendBack(true));
    }
  }

  _onTapProceed(bool isDisabled) {
    if (!isDisabled) {
      _callPayOrderAPI();
    }
  }

  _onTapBackButton() {
    if (!_isPaymentDone) {
      _editAndUpdateOrder();
    }
    _showEventMenuScreen();
  }

  _onTapBottomListItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _onTapCallBack(bool callBack) {}

  //Navigation
  _showEventMenuScreen() {
    Navigator.of(context).pop(_getOrderInfoToSendBack(_isPaymentDone));
  }

  //data for p2pConnection to Customer
  _updateSelectedPaymentMode() {
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.paymentModeSelected,
        data: _paymentModeType.toString());
  }

  _editAndUpdateOrder() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.editOrderDetails);
  }

  _updatePaymentSuccess() {
    P2PConnectionManager.shared
        .updateData(action: StaffActionConst.paymentCompleted);
  }

  //Other functions
  Map _getOrderInfoToSendBack(bool isOrderComplete) {
    String orderComplete = isOrderComplete ? "True" : "False";
    Map orderInfo = {"isOrderComplete": orderComplete, "orderID": _orderID};
    debugPrint("insideGetMap $orderInfo");
    return orderInfo;
  }

  PayOrderRequestModel _getPayOrderRequestModel() {
    PayOrderRequestModel payOrderRequestModel = PayOrderRequestModel();
    payOrderRequestModel.orderId = _orderID;
    payOrderRequestModel.paymentMethod = PaymentMethods.cash;
    payOrderRequestModel.cardId = StringExtension.empty();

    return payOrderRequestModel;
  }

  //API call
  _callPlaceOrderAPI() async {
    _orderPresenter.placeOrder(widget.placeOrderRequestModel);

    debugPrint('>>>>>>>>>>>>${widget.placeOrderRequestModel}');
  }

  //API call for card payment method
  _callPayOrderAPI() {
    PayOrderRequestModel payOrderRequestModel = _getPayOrderRequestModel();
    setState(() {
      _isApiProcess = true;
    });
    _orderPresenter.payOrder(payOrderRequestModel);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSuccess(response) {
    setState(() {
      _isApiProcess = false;
    });

    if (response is GeneralSuccessModel) {
      GeneralSuccessModel responseModel = response;
      CommonWidgets().showSuccessSnackBar(
          message: responseModel.general![0].message ??
              StringConstants.eventCreatedSuccessfully,
          context: context);
      _phoneNumberController.clear();
      _emailController.clear();
      P2PConnectionManager.shared.updateData(
          action: StaffActionConst.receiptEmailProgress,
          data: "Sucess" );
    } else {
      setState(() {
        _updatePaymentSuccess();
        _isPaymentDone = true;
      });
      _clearOderData();
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
    _placeOrderResponseModel = response;
    if (_placeOrderResponseModel.id != null) {
      setState(() {
        _orderID = _placeOrderResponseModel.id!;
      });
    }
  }

  //DB Calls
  _clearOderData() async {
    await SavedOrdersDAO().clearEventDataByOrderID(_orderID);
  }

  //P2P Implemented Method
  @override
  void receivedDataFromP2P(P2PDataModel response) {
    debugPrint('>>>>>>>>>>');
    if (response.action == CustomerActionConst.paymentModeSelected) {
      String modeType = response.data;
      setState(() {
        _paymentModeType = int.parse(modeType);
      });
      if (_paymentModeType == PaymentModeConstants.creditCard) {
        _onTapPaymentMode(_paymentModeType);
      }
    } else if (response.action == CustomerActionConst.editOrderDetails) {
      _showEventMenuScreen();
    } else if (response.action == StaffActionConst.paymentStatus) {
      setState(() {
        _isAnimation = true;
      });
      setState(() {
        _paymentStatusValue = response.data.toString();
      });
      debugPrint('response--->' + response.data.toString());
    }
    else if (response.action == StaffActionConst.receiptEmail) {
      String emailFromCustomer=response.data;
      _sendReciptMailOrSmsApiCall("", "", emailFromCustomer);
      debugPrint('>>>>>>>>>>$emailFromCustomer');
    }
  }

  //FinixMannual CardDetails
  _onTapConfirmPayment(String cardNumber, int expirationYear, int cardCvvNumber,
      int cardExpiryMonth, String zipcode) async {
    final valuesCardDetails = {
      CardDetails.cardNumber.name: cardNumber,
      CardDetails.expirationYear.name: expirationYear,
      CardDetails.expirationMonth.name: cardExpiryMonth,
      CardDetails.cvv.name: cardCvvNumber,
      CardDetails.zipcode.name: zipcode
    };
    debugPrint(valuesCardDetails.toString());
    await _cardPaymentChannel.invokeListMethod(
        'getPaymentToken', valuesCardDetails);
  }

  //ApiCall After getting Manual Card token
  _finixManualApiCall() {
    _getPayReceiptModel(true);
  }

  PayReceipt _getPayReceiptModel(bool paymentMethodCall) {
    PayReceipt payReceiptModel = PayReceipt();
    // FinixResponseDto finixResponseDto = FinixResponseDto();
    FinixSaleResponse finixSaleResponse = FinixSaleResponse();
    /*FinixSaleReciptResponseRequest finixSaleReciptResponseRequest =
    FinixSaleReciptResponseRequest();*/
    FinixSaleReceipt finixSaleReceiptRequest = FinixSaleReceipt();

    payReceiptModel.orderId = _orderID;
    payReceiptModel.paymentMethod = PaymentMethods.bbpos;
    finixSaleResponse.transferId = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.transferId;
    finixSaleResponse.updated = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.updated;
    finixSaleResponse.amount = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.amount;
    finixSaleResponse.cardLogo = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.cardLogo;
    finixSaleResponse.cardHolderName = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.cardHolderName;
    finixSaleResponse.expirationMonth = _finixResponse
        .authorizationResponseModel
        ?.finixAuthorizationResponse
        ?.expirationMonth;
    finixSaleResponse.emv = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.emv;
    finixSaleResponse.hostResponse = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.hostResponse;
    finixSaleResponse.verification = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.verification;

    ResourceTags resourceTagsRequest = ResourceTags();
    resourceTagsRequest.customerEmail =
        widget.placeOrderRequestModel.email ?? StringExtension.empty();
    resourceTagsRequest.customerName =
        widget.placeOrderRequestModel.getPhoneNumber();
    resourceTagsRequest.eventName = widget.events.getEventName();
    resourceTagsRequest.eventCode = widget.events.getEventCode();
    resourceTagsRequest.environment = ""; //***********
    resourceTagsRequest.paymentMethod = ""; //***********

    finixSaleResponse.entryMode = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.entryMode;
    finixSaleResponse.maskedAccountNumber = _finixResponse
        .authorizationResponseModel
        ?.finixAuthorizationResponse
        ?.maskedAccountNumber;
    finixSaleResponse.created = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.created;
    finixSaleResponse.traceId = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.traceId;
    finixSaleResponse.transferState = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.transferState;
    finixSaleResponse.expirationYear = _finixResponse
        .authorizationResponseModel?.finixAuthorizationResponse?.expirationYear;

    finixSaleReceiptRequest.cryptogram = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.cryptogram;
    finixSaleReceiptRequest.merchantId = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.merchantId;
    finixSaleReceiptRequest.accountNumber = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.accountNumber;
    finixSaleReceiptRequest.referenceNumber = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.referenceNumber;
    finixSaleReceiptRequest.applicationLabel = _finixResponse
        .authorizationResponseModel
        ?.finixAuthorizationReceipt
        ?.applicationLabel;
    finixSaleReceiptRequest.entryMode = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.entryMode;
    finixSaleReceiptRequest.approvalCode = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.approvalCode;
    finixSaleReceiptRequest.transactionId = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.transactionId;
    finixSaleReceiptRequest.cardBrand = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.cardBrand;
    finixSaleReceiptRequest.merchantName = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.merchantName;
    finixSaleReceiptRequest.merchantAddress = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.merchantAddress;
    finixSaleReceiptRequest.responseCode = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.responseCode;
    finixSaleReceiptRequest.transactionType = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.transactionType;
    finixSaleReceiptRequest.responseMessage = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.responseMessage;
    finixSaleReceiptRequest.applicationIdentifier = _finixResponse
        .authorizationResponseModel
        ?.finixAuthorizationReceipt
        ?.applicationIdentifier;
    finixSaleReceiptRequest.date = _finixResponse
        .authorizationResponseModel?.finixAuthorizationReceipt?.date;

    FinixResponseDto finixResponseDto = FinixResponseDto();
    FinixCaptureResponse finixCaptureResponse = FinixCaptureResponse();

    finixCaptureResponse.amount = _finixResponse.finixCaptureResponse?.amount;
    finixCaptureResponse.deviceId =
        _finixResponse.finixCaptureResponse?.deviceId;
    finixCaptureResponse.updated = _finixResponse.finixCaptureResponse?.updated;
    finixCaptureResponse.traceId = _finixResponse.finixCaptureResponse?.traceId;
    finixCaptureResponse.transferId =
        _finixResponse.finixCaptureResponse?.traceId;
    finixCaptureResponse.transferState =
        _finixResponse.finixCaptureResponse?.transferState;

    finixResponseDto.finixSaleResponse = finixSaleResponse;
    finixResponseDto.finixSaleResponse?.resourceTags = resourceTagsRequest;
    finixResponseDto.finixSaleReceipt = finixSaleReceiptRequest;
    finixResponseDto.tipAmount = _finixResponse.tipAmount;
    finixResponseDto.finixCaptureResponse = finixCaptureResponse;
    payReceiptModel.finixResponseDto = finixResponseDto;

    debugPrint('>>>>>>>>>>>${payReceiptModel.toString()}');

    if (paymentMethodCall == true) {
      payReceiptModel.paymentMethod = PaymentMethods.creditCard;
      payReceiptModel.orderId = _orderID;
      payReceiptModel.stripePaymentMethodId = null;
      payReceiptModel.stripeCardId = null;
      // payReceiptModel.finixNCPaymentToken = _finixNCPaymentToken;
      // payReceiptModel.finixNCPMerchantId = _merchantIdNCP;
    }

    setState(() {
      double? newAmount = _finixResponse
          .finixCaptureResponse?.amount;
      _isApiProcess = true;
      _tip = _finixResponse.tipAmount;
      totalAmount = newAmount!;
    });
    _orderPresenter.finixReceipt(payReceiptModel);
    return payReceiptModel;
  }

  _emailValidation() {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailValidationMessage = StringConstants.emptyValidEmail;
        _validationPopup(_emailValidationMessage);
      });
      return false;
    }
    if (!_emailController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = StringConstants.enterValidEmail;
        _validationPopup(_emailValidationMessage);
      });
      return false;
    }
    if (_emailController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = "";
        _sendReciptMailOrSmsApiCall("", "", _emailController.text);
      });
      return true;
    }
  }

  _smsValidation() {
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _smsValidationMessage = StringConstants.emptyContactNumber;
        _validationPopup(_smsValidationMessage);
      });
      return false;
    }
    if (_phoneNumberController.text.isNotEmpty) {
      setState(() {
        _smsValidationMessage = "";
        _sendReciptMailOrSmsApiCall(
            _countryCode, _phoneNumberController.text, "");
      });
      return true;
    }
  }

  _validationPopup(String validationMessage) {
    showDialog(
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return ValidationPopup(validationMessage: validationMessage);
        });
  }

  void _sendReciptMailOrSmsApiCall(
      String countryCode, String phoneNumber, String emailAddress) {
    FinixSendReceiptRequest finixSendReceiptRequest = FinixSendReceiptRequest();
    finixSendReceiptRequest.phoneNumCountryCode = countryCode;
    finixSendReceiptRequest.phoneNumber = phoneNumber;
    finixSendReceiptRequest.email = emailAddress;
    setState(() {
      _isApiProcess = true;
    });
    _orderPresenter.finixSendReceipt(_orderID, finixSendReceiptRequest);
  }
}

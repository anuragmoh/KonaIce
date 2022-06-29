import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:blinkcard_flutter/microblink_scanner.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/order_complete/order_complete.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:lottie/lottie.dart';

import '../../utils/payment_utils.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({Key? key}) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption>
    implements P2PContractor, PaymentUtilsContractor {
  int _paymentModeType = -1;
  bool _isAnimation = false;
  bool _isApiProcess = false;
  var _animationFileName = AssetsConstants.progressAnimationPath;

  _PaymentOptionState() {
    P2PConnectionManager.shared.getP2PContractor(this);
    PaymentUtils.shared.getPaymentUtilsContractor(this);
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.textColor3.withOpacity(0.2),
      child: Column(
        children: [
          CommonWidgets().topEmptyBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      _paymentOption(0.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          color: AppColors.gradientColor1.withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
                      _paymentModeWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          color: AppColors.gradientColor1.withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Visibility(
                      visible: _isAnimation,
                      child: BackdropFilter(
                        filter:
                            new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Lottie.asset(_animationFileName,
                            height: 350, width: 350, animate: true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CommonWidgets().bottomEmptyBar(),
        ],
      ),
    ));
  }

  Widget _paymentOption(double totalAmount) => Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30, top: 20),
        child: SizedBox(
          height: 25.0,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _onTapBackButton();
                  },
                  child: CommonWidgets().image(
                      image: AssetsConstants.backArrow,
                      width: 25.0,
                      height: 25.0),
                ),
                const SizedBox(
                  width: 22.0,
                ),
                CommonWidgets().textWidget(
                    StringConstants.selectPaymentOption,
                    StyleConstants.customTextStyle(
                        fontSize: 22.0,
                        color: AppColors.textColor1,
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
            // Amount to return field
          ]),
        ),
      );

  Widget _paymentModeWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _paymentModeView(StringConstants.cash, PaymentModeConstants.cash,
                AssetsConstants.cash),
            _paymentModeView(StringConstants.creditCard,
                PaymentModeConstants.creditCard, AssetsConstants.creditCard),
            // paymentModeView(StringConstants.qrCode, PaymentModeConstants.qrCode, AssetsConstants.qrCode),
/*            _paymentModeView(
                StringConstants.creditCardManual,
                PaymentModeConstants.creditCardManual,
                AssetsConstants.creditCardScan),*/
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
                StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratMedium)),
          ],
        ),
      );

  //Action Event
  onTapCashMode() {}

  _onTapPaymentMode(int index) {
    setState(() {
      _paymentModeType = index;
    });
    if (_paymentModeType == PaymentModeConstants.creditCard) {
      P2PConnectionManager.shared.updateData(
          action: CustomerActionConst.paymentModeSelected,
          data: PaymentModeConstants.creditCard.toString());
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _paymentModeType = -1;
        });
      });
    } else if (_paymentModeType == PaymentModeConstants.creditCardManual) {
      P2PConnectionManager.shared.updateData(
          action: CustomerActionConst.paymentModeSelected,
          data: PaymentModeConstants.creditCardManual.toString());
    } else {
      _updateSelectedPaymentMode();
    }
  }

  _onTapBackButton() {
    _editAndUpdateOrder();
    _showOrderDetailsScreen();
  }

  //Navigation
  _showPaymentSuccessScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const OrderComplete()));
  }

  _showOrderDetailsScreen() {
    Navigator.of(context).pop();
  }

  //data for p2pConnection to Staff
  _updateSelectedPaymentMode() {
    P2PConnectionManager.shared.updateData(
        action: CustomerActionConst.paymentModeSelected,
        data: _paymentModeType.toString());
  }

  _editAndUpdateOrder() {
    P2PConnectionManager.shared
        .updateData(action: CustomerActionConst.editOrderDetails);
  }

  _showTipCustomerScreen() async {
    await PaymentUtils.showTipScreen();
  }

  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == StaffActionConst.paymentModeSelected) {
      String modeType = response.data;
      setState(() {
        _paymentModeType = int.parse(modeType);
      });
    } else if (response.action == StaffActionConst.editOrderDetails) {
      _showOrderDetailsScreen();
    } else if (response.action == StaffActionConst.paymentCompleted) {
      setState(() {
        _isApiProcess = false;
      });
      _showPaymentSuccessScreen();
    } else if (response.action ==
        StaffActionConst.showSplashAtCustomerForHomeAndSettings) {
      FunctionalUtils.showCustomerSplashScreen();
    } else if (response.action == StaffActionConst.paymentStatus) {
      debugPrint('=======${response.data.toString()}');
      if (response.data.toString() == StringConstants.paymentStatusSucc ||
          response.data.toString() == StringConstants.paymentStatusFailed) {
        setState(() {
          _isAnimation = false;
        });
        } else if (response.data.toString() == "insertCard") {
          _animationFileName = AssetsConstants.insertCardAnimationPath;
          _isAnimation = true;
        } else if (response.data.toString() == "removeCard") {
          _animationFileName = AssetsConstants.removeCardAnimationPath;
          _isAnimation = true;
        } else if (response.data.toString() == "progress") {
          _animationFileName = AssetsConstants.progressAnimationPath;
          _isAnimation = true;
        } else if (response.data.toString() == "authorizationSuccess") {
          _isAnimation = false;
          _showTipCustomerScreen();
        } else {
          _isAnimation = true;
        }
      debugPrint('response--->' + response.data.toString());
    }
  }

  @override
  Future<void> getCustomerEnteredTipAmount(double amount) async {
    final values = {"tipAmount": amount};
    debugPrint(amount.toString());
    setState(() {
      _animationFileName = AssetsConstants.progressAnimationPath;
      _isAnimation = true;
    });
    await PaymentUtils.captureTipAmount(values);
  }

  @override
  void getPaymentToken(response) {
    // TODO: implement getPaymentToken
  }

  @override
  void paymentFailed(response) {
    // TODO: implement paymentFailed
  }

  @override
  void paymentStatus(response) {
    // TODO: implement paymentStatus
  }

  @override
  void paymentSuccess(response) {
    // TODO: implement paymentSuccess
  }
}

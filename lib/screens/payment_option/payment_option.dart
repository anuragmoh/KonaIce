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
import 'package:kona_ice_pos/utils/utils.dart';
import 'package:lottie/lottie.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({Key? key}) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption>
    implements P2PContractor {
  int paymentModeType = -1;
  String paymentStatus = "";
  bool isAnimation=false;
  _PaymentOptionState() {
    P2PConnectionManager.shared.getP2PContractor(this);
  }
  bool isApiProcess = false;

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
          CommonWidgets().topEmptyBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      paymentOption(0.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          color: getMaterialColor(AppColors.gradientColor1)
                              .withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
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
                  ),
                  Center(
                    child: Visibility(
                        visible: (paymentModeType == PaymentModeConstants.creditCard && isAnimation)||(paymentModeType == PaymentModeConstants.creditCardManual && isAnimation),
                        child: Lottie.asset(paymentStatus == 'insert'?AssetsConstants.insertCardAnimationPath:paymentStatus == 'progress'?AssetsConstants.progressAnimationPath:AssetsConstants.removeCardAnimationPath,
                            height: 150, width: 150)),
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

  Widget paymentOption(double totalAmount) => Padding(
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
                CommonWidgets().textWidget(
                    StringConstants.selectPaymentOption,
                    StyleConstants.customTextStyle(
                        fontSize: 22.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
              ],
            ),
            // Amount to return field
          ]),
        ),
      );

  Widget paymentModeWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            paymentModeView(StringConstants.cash, PaymentModeConstants.cash,
                AssetsConstants.cash),
            paymentModeView(StringConstants.creditCard,
                PaymentModeConstants.creditCard, AssetsConstants.creditCard),
            // paymentModeView(StringConstants.qrCode, PaymentModeConstants.qrCode, AssetsConstants.qrCode),
            paymentModeView(
                StringConstants.creditCardManual,
                PaymentModeConstants.creditCardManual,
                AssetsConstants.creditCardScan),
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

  //Action Event
  onTapCashMode() {}

  onTapPaymentMode(int index) {
    paymentStatus = 'insert';
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.paymentStatus,
        data: paymentStatus.toString());
    setState(() {
      paymentModeType = index;
      updateSelectedPaymentMode();
    });
    setState(() {
      paymentModeType = index;
      updateSelectedPaymentMode();
    });
    if (paymentModeType == PaymentModeConstants.creditCard) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          paymentModeType = -1;
        });
      });
    }
    else if (paymentModeType == PaymentModeConstants.creditCardManual) {
      paymentStatus = 'progress';
      P2PConnectionManager.shared.updateData(
          action: StaffActionConst.paymentStatus,
          data: paymentStatus.toString());
    }
  }

  onTapBackButton() {
    editAndUpdateOrder();
    showOrderDetailsScreen();
  }

  //Navigation
  showPaymentSuccessScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const OrderComplete()));
  }

  showOrderDetailsScreen() {
    Navigator.of(context).pop();
  }

  //data for p2pConnection to Staff
  updateSelectedPaymentMode() {
    P2PConnectionManager.shared.updateData(
        action: CustomerActionConst.paymentModeSelected,
        data: paymentModeType.toString());
  }

  editAndUpdateOrder() {
    P2PConnectionManager.shared
        .updateData(action: CustomerActionConst.editOrderDetails);
  }

  @override
  void receivedDataFromP2P(P2PDataModel response) {
    if (response.action == StaffActionConst.paymentModeSelected) {
      String modeType = response.data;
      setState(() {
        paymentModeType = int.parse(modeType);
      });
    } else if (response.action == StaffActionConst.editOrderDetails) {
      showOrderDetailsScreen();
    } else if (response.action == StaffActionConst.paymentCompleted) {
      setState(() {
        isApiProcess = false;
      });
      showPaymentSuccessScreen();
    } else if (response.action ==
        StaffActionConst.showSplashAtCustomerForHomeAndSettings) {
      FunctionalUtils.showCustomerSplashScreen();
    }else if (response.action ==
        StaffActionConst.paymentStatus) {
      setState(() {
        isAnimation=true;
      });
      setState(() {
        paymentStatus=response.data.toString();
      });
      debugPrint('response--->' + response.data.toString());
    }else if (response.action ==
        StaffActionConst.showSplashAtCustomerForHomeAndSettings) {
      FunctionalUtils.showCustomerSplashScreen();
    }else if (response.action ==
        StaffActionConst.paymentStatus) {
      setState(() {
        isAnimation=true;
      });
      setState(() {
        paymentStatus=response.data.toString();
      });
      debugPrint('response--->' + response.data.toString());
    }
  }
}

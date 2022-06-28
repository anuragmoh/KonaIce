import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/payment/validation_popup.dart';
import 'package:kona_ice_pos/screens/splash/splash_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/p2p_utils/p2p_models/p2p_data_model.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete({Key? key}) : super(key: key);

  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete>
    implements P2PContractor {
  bool _isMovedToNextScreen = true;
  TextEditingController _emailController = TextEditingController();
  bool _isApiProcess = false;
  String _emailValidationMessage = "";
  _OrderCompleteState() {
    P2PConnectionManager.shared.getP2PContractor(this);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isMovedToNextScreen) {
        _showSplashScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }
  Widget _mainUi(BuildContext context){
    return Scaffold(
      body: Container(
        color: AppColors.textColor3.withOpacity(0.2),
        child: Column(
          children: [
            CommonWidgets().topEmptyBar(),
            Expanded(child: _paymentSuccess()),
            CommonWidgets().bottomEmptyBar(),
          ],
        ),
      ),
    );
  }
  Widget _paymentSuccess() => SingleChildScrollView(
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 68.0),
            CommonWidgets().image(
                image: AssetsConstants.success,
                width: 9.3 * SizeConfig.imageSizeMultiplier,
                height: 9.3 * SizeConfig.imageSizeMultiplier),
            const SizedBox(height: 21.0),
            CommonWidgets().textWidget(
                StringConstants.orderCompleted,
                StyleConstants.customTextStyle(
                    fontSize: 22.0,
                    color: AppColors.textColor1,
                    fontFamily: FontConstants.montserratBold)),
            const SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CommonWidgets().textWidget(
                  '${StringConstants.transactionId}:',
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratSemiBold)),
              CommonWidgets().textWidget(
                  "35891456",
                  StyleConstants.customTextStyle(
                      fontSize: 12.0,
                      color: AppColors.textColor1,
                      fontFamily: FontConstants.montserratSemiBold)),
            ]),
            const SizedBox(height: 34.0),
            CommonWidgets().textWidget(
                StringConstants.howWouldYouLikeToReceiveTheReceipt,
                StyleConstants.customTextStyle16MonsterMedium(
                    color: AppColors.textColor1)),
            const SizedBox(height: 15.0),
            _emailReceiptWidget(),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 23.0,
                    vertical: 3.90 * SizeConfig.heightSizeMultiplier),
                child: Visibility(
                  visible: true,
                  child: CommonWidgets().buttonWidget(
                    StringConstants.okay,
                    _onTapOkay,
                  ),
                ),
              ),
            )
          ],
        ),
  );

  _onTapOkay() {
    _showSplashScreen();
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
        setState(() {
          _isApiProcess = true;
        });
        debugPrint(_emailController.text);
        P2PConnectionManager.shared.updateData(
            action: StaffActionConst.receiptEmail,
            data: _emailController.text.toString());
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

  //Navigation
  _showSplashScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  void receivedDataFromP2P(P2PDataModel response) {
    debugPrint("EmailsResponse{$response}");
    if (response.action == StaffActionConst.receiptEmailProgress) {
      if (response.data=="Sucess") {
        CommonWidgets().showSuccessSnackBar(
            message: StringConstants.emailSendSuccessfully,
            context: context);
        _emailController.clear();
        setState(() {
          _isApiProcess = false;
          Future.delayed(const Duration(seconds: 3), () {
              _showSplashScreen();
          });
        });
      }
    }
  }
}

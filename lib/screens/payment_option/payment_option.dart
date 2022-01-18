import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({Key? key}) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  int paymentModeType = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
      child: Column(
        children: [
          CommonWidgets().topEmptyBar(),
          Expanded(child: Column(
            children: [
              paymentOption(0.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color:
                  getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
                  thickness: 1,
                ),
              ),
              paymentModeWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color:
                  getMaterialColor(AppColors.gradientColor1).withOpacity(0.2),
                  thickness: 1,
                ),
              ),
            ],
          ),),
          CommonWidgets().bottomEmptyBar(),
        ],
      ),));
  }

  Widget paymentOption(double totalAmount) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    child: SizedBox(
      height: 25.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child:  CommonWidgets().image(
                      image: AssetsConstants.backArrow, width: 25.0, height: 25.0),
                ),
                const SizedBox(width: 22.0,),
                CommonWidgets().textWidget(
                    StringConstants.selectPaymentOption,
                    StyleConstants.customTextStyle(
                        fontSize: 22.0,
                        color: getMaterialColor(AppColors.textColor1),
                        fontFamily: FontConstants.montserratBold)),
                const SizedBox(
                  height: 2.0,
                ),
              ],
            ),
            const SizedBox(
              width: 51.0,
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
        paymentModeView(StringConstants.cash, 0, AssetsConstants.cash),
        paymentModeView(
            StringConstants.creditCard, 1, AssetsConstants.creditCard),
        paymentModeView(StringConstants.qrCode, 2, AssetsConstants.qrCode),
      ],
    ),
  );

  Widget paymentModeView(String title, int index, String icon) =>
      GestureDetector(
        onTap: () {
          setState(() {
            paymentModeType = index;
          });
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
                child: CommonWidgets()
                    .image(image: icon, width:3.25*SizeConfig.imageSizeMultiplier , height: 3.25*SizeConfig.imageSizeMultiplier),
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

}

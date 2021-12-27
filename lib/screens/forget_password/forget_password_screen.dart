import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class ForgetPasswordScreen extends StatefulWidget {

  Function navigateBackToLoginView;

   ForgetPasswordScreen({required this.navigateBackToLoginView, Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration:
          StyleConstants.customBoxShadowDecorationStyle(circularRadius: 3.6),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            child: CommonWidgets().textWidget(
                StringConstants.forgotPassword,
                StyleConstants.customTextStyle(
                    fontSize: 22.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratSemiBold)),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 23),
              child: CommonWidgets().textWidget(
                  StringConstants.emailId,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor2),
                      fontFamily: FontConstants.montserratRegular)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 20.0, left: 22.0, right: 22.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'abc@gmail.com',
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: GestureDetector(
              onTap: onTapSignIn,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: StringConstants.rememberPassword, style: StyleConstants.customTextStyle(
                          fontSize: 12.0, color: getMaterialColor(AppColors.denotiveColor4), fontFamily: FontConstants.montserratSemiBold)),
                      TextSpan(text: ' ${StringConstants.signIn}', style: TextStyle(
                        color: getMaterialColor(AppColors.gradientColor2),
                        fontSize: 12.0, fontFamily: FontConstants.montserratSemiBold,
                        decoration: TextDecoration.underline
                      )),
                    ]
                  )
              ),
            )
          ),
          submitButton(StringConstants.submit, StyleConstants.customTextStyle(
              fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),
        ],
      ),
    );
  }

  Widget submitButton(String buttonText, TextStyle textStyle){
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, top: 35.0),
      child: GestureDetector(
        onTap:  onTapSubmit,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 84.0),
            child: CommonWidgets().textWidget(buttonText, textStyle),
          ),
        ),
      ),
    );
  }

  //Actions
 onTapSubmit() {
   widget.navigateBackToLoginView();
 }

 onTapSignIn() {
   widget.navigateBackToLoginView();
 }
}

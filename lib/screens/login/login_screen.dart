import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/screens/forget_password/forget_password_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = true;
  bool isLoginView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getMaterialColor(AppColors.primaryColor1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 52.0, bottom: 39.0),
                child: icon(),
              ),
              isLoginView ? loginContainer() : ForgetPasswordScreen(navigateBackToLoginView: onTapFromForgetPasswordView,),
             // loginContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget icon() {
    return CommonWidgets().image(image: AssetsConstants.konaIcon, width: 161.0, height: 120.0);
  }

  Widget loginContainer() {
    return Container(
      width: 360.0,
      decoration: StyleConstants.customBoxShadowDecorationStyle(circularRadius: 3.6),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 141.0),
            child: textWidget(
                StringConstants.loginText,
                StyleConstants.customTextStyle(
                    fontSize: 22.0,
                    color: getMaterialColor(AppColors.textColor1),
                    fontFamily: FontConstants.montserratBold)),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:23.0),
              child: textWidget(
                  StringConstants.emailId,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0,bottom: 20.0,left: 22.0,right: 22.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color:
                          getMaterialColor(AppColors.textColor1).withOpacity(0.2),
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:23.0),
              child: textWidget(
                  StringConstants.password,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0,bottom: 20.0,left: 22.0,right: 22.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color:
                      getMaterialColor(AppColors.textColor1).withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: isPasswordVisible,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: isPasswordVisible ? const Icon(Icons.visibility_off) :const Icon(Icons.visibility) ),
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0,right: 21.0,bottom: 20.0),
              child: InkWell(
                onTap: onTapForgotPassword,
                child: textWidget(
                    StringConstants.forgotPassword,
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: getMaterialColor(AppColors.denotiveColor4),
                        fontFamily: FontConstants.montserratBold)),
              ),
            ),
          ),
          signInButton(StringConstants.signIn,StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratBold)),
        ],
      ),
    );
  }

  Widget textWidget(String textTitle, TextStyle textStyle) {
    return Text(textTitle, style: textStyle);
  }
  
  Widget signInButton(String buttonText,TextStyle textStyle){
    return Padding(
      padding: const EdgeInsets.only(bottom: 44.0),
      child: GestureDetector(
        onTap:  onTapSingIn,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 84.0),
            child: Text(buttonText,style: textStyle),
          ),
        ),
      ),
    );
  }

  onTapSingIn(){
     Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => const Dashboard())
     );
  }
  onTapForgotPassword(){
   setState(() {
     isLoginView = false;
   });
  }
  onTapFromForgetPasswordView() {
    setState(() {
      isLoginView = true;
    });
  }

}

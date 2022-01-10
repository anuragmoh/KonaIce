import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/repository/login/login_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/screens/forget_password/forget_password_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements ResponseContractor{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LoginPresenter loginPresenter;

  _LoginScreenState(){
    loginPresenter = LoginPresenter(this);
  }


  bool isPasswordVisible = true;
  bool isLoginView = true;
  bool isApiProcess = false;

  login(){
    setState(() {
      isApiProcess = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
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
                padding:  EdgeInsets.only(top: 6.77*SizeConfig.imageSizeMultiplier, bottom: 5.07*SizeConfig.imageSizeMultiplier),
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
    return CommonWidgets().image(image: AssetsConstants.konaIcon, width: 20.96*SizeConfig.imageSizeMultiplier, height: 15.62*SizeConfig.imageSizeMultiplier);
  }

  Widget loginContainer() {
    return Container(
      width: 360,
      decoration: StyleConstants.customBoxShadowDecorationStyle(circularRadius: 3.6),
      child: Column(
        children: [
          Padding(
            padding:
                  EdgeInsets.symmetric(vertical: 3.25*SizeConfig.imageSizeMultiplier, horizontal: 141.0),
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
            padding:  EdgeInsets.only(top:0.65*SizeConfig.imageSizeMultiplier,bottom: 2.60*SizeConfig.imageSizeMultiplier,left: 22.0,right: 22.0),
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
            padding:  EdgeInsets.only(top:0.65*SizeConfig.imageSizeMultiplier,bottom: 2.60*SizeConfig.imageSizeMultiplier,left: 22.0,right: 22.0),
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
              padding:  EdgeInsets.only(top: 3.25*SizeConfig.imageSizeMultiplier,right: 21.0,bottom: 2.60*SizeConfig.imageSizeMultiplier),
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
      padding:  EdgeInsets.only(bottom: 5.72*SizeConfig.imageSizeMultiplier),
      child: GestureDetector(
        onTap:  onTapSingIn,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 1.56*SizeConfig.imageSizeMultiplier,horizontal: 84.0),
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

  @override
  void showError(FetchException exception) {
    setState(() {
      isApiProcess = false;
    });

  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess = false;
    });

  }

}

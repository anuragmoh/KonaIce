import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/forgot_password/forgot_password_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/forget_password/forgot_password_model.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';
//ignore: must_be_immutable
class ForgetPasswordScreen extends StatefulWidget {

  Function navigateBackToLoginView;
  Function forgotPasswordLoader;

   ForgetPasswordScreen({required this.navigateBackToLoginView, required this.forgotPasswordLoader,Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> implements ResponseContractor{
  bool isApiProcess = false;
  bool isEmailValid = true;
  TextEditingController emailController = TextEditingController();

  late ForgotPasswordPresenter forgotPasswordPresenter;
  ForgotPasswordRequestModel forgotPasswordRequestModel=ForgotPasswordRequestModel();

  _ForgetPasswordScreenState() {
    forgotPasswordPresenter = ForgotPasswordPresenter(this);
  }
    forgotPasswordApiCall(){

    widget.forgotPasswordLoader(true);
      forgotPasswordRequestModel.email=emailController.text.toString();
      forgotPasswordPresenter.forgotPassword(forgotPasswordRequestModel);
    }


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
            padding:  EdgeInsets.only(top: 3.25*SizeConfig.imageSizeMultiplier, bottom: 3.25*SizeConfig.imageSizeMultiplier),
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
            padding:  EdgeInsets.only(
                top:0.65*SizeConfig.imageSizeMultiplier,bottom: 2.60*SizeConfig.imageSizeMultiplier, left: 22.0, right: 22.0),
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
            padding:  EdgeInsets.only(bottom:0.65*SizeConfig.imageSizeMultiplier),
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
      padding:  EdgeInsets.only(bottom: 4.55*SizeConfig.imageSizeMultiplier, top: 4.55*SizeConfig.imageSizeMultiplier),
      child: GestureDetector(
        onTap:  onTapSubmit,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 1.56*SizeConfig.imageSizeMultiplier,horizontal: 84.0),
            child: CommonWidgets().textWidget(buttonText, textStyle),
          ),
        ),
      ),
    );
  }

  //Actions
 onTapSubmit() {
   setState(() {
     isEmailValid = emailController.text.isValidEmail();
   });

   if (isEmailValid) {
     CheckConnection().connectionState().then((value){
       if(value == true){
         forgotPasswordApiCall();
       }else{
         CommonWidgets().showErrorSnackBar(errorMessage: StringConstants.noInternetConnection, context: context);
       }
     });
   }


 }

 onTapSignIn() {
   widget.navigateBackToLoginView();
 }

  @override
  void showError(GeneralErrorResponse exception) {
    print(exception);
    widget.forgotPasswordLoader(false);
  }

  @override
  void showSuccess(response) {
    print('response$response');
    widget.forgotPasswordLoader(false);
    widget.navigateBackToLoginView();
  }
}

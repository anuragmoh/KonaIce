import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/models/network_model/forgot_password/forgot_password_model.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

//ignore: must_be_immutable
class ForgetPasswordScreen extends StatefulWidget {
  Function navigateBackToLoginView;
  Function forgotPasswordLoader;

  ForgetPasswordScreen(
      {required this.navigateBackToLoginView,
      required this.forgotPasswordLoader,
      Key? key})
      : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    implements ResponseContractor {
  bool isApiProcess = false;
  bool isEmailValid = true;
  String emailValidationMessage = "";
  TextEditingController emailController = TextEditingController();

  late UserPresenter userPresenter;
  ForgotPasswordRequestModel forgotPasswordRequestModel =
      ForgotPasswordRequestModel();

  _ForgetPasswordScreenState() {
    userPresenter = UserPresenter(this);
  }
  forgotPasswordApiCall() {
    widget.forgotPasswordLoader(true);
    forgotPasswordRequestModel.email = emailController.text.toString();
    userPresenter.forgotPassword(forgotPasswordRequestModel);
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
            padding: EdgeInsets.only(
                top: 3.25 * SizeConfig.imageSizeMultiplier,
                bottom: 3.25 * SizeConfig.imageSizeMultiplier),
            child: CommonWidgets().textWidget(
                StringConstants.forgotPassword,
                StyleConstants.customTextStyle22MontserratSemiBold(
                    color: getMaterialColor(AppColors.textColor1))),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 23),
              child: CommonWidgets().textWidget(
                  StringConstants.emailId,
                  StyleConstants.customTextStyle14MonsterRegular(
                      color: getMaterialColor(AppColors.textColor2))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.65 * SizeConfig.imageSizeMultiplier,
                bottom: 2.60 * SizeConfig.imageSizeMultiplier,
                left: 22.0,
                right: 22.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: TextField(
                onChanged: (value) {
                  emailValidation();
                },
                maxLength: 100,
                controller: emailController,
                decoration: InputDecoration(
                  counterText: "",
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.textColor2, width: 1.0),
                  ),
                  hintText: 'abc@gmail.com',
                  errorText: emailValidationMessage,
                  hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                      color: getMaterialColor(AppColors.textColor1)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.textColor2, width: 1.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryColor1, width: 1.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: 0.65 * SizeConfig.imageSizeMultiplier),
              child: GestureDetector(
                onTap: onTapSignIn,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: StringConstants.rememberPassword,
                      style: StyleConstants.customTextStyle12MontserratSemiBold(
                          color: getMaterialColor(AppColors.denotiveColor4))),
                  TextSpan(
                      text: ' ${StringConstants.signIn}',
                      style: TextStyle(
                          color: getMaterialColor(AppColors.gradientColor2),
                          fontSize: 12.0,
                          fontFamily: FontConstants.montserratSemiBold,
                          decoration: TextDecoration.underline)),
                ])),
              )),
          submitButton(
              StringConstants.submit,
              StyleConstants.customTextStyle12MontserratBold(
                  color: getMaterialColor(AppColors.textColor1))),
        ],
      ),
    );
  }

  Widget submitButton(String buttonText, TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 4.55 * SizeConfig.imageSizeMultiplier,
          top: 4.55 * SizeConfig.imageSizeMultiplier),
      child: GestureDetector(
        onTap: onTapSubmit,
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 1.56 * SizeConfig.imageSizeMultiplier,
                horizontal: 84.0),
            child: CommonWidgets().textWidget(buttonText, textStyle),
          ),
        ),
      ),
    );
  }

  emailValidation() {
    if (emailController.text.isEmpty) {
      setState(() {
        emailValidationMessage = StringConstants.emptyValidEmail;
      });
      return false;
    }
    if (!emailController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = StringConstants.enterValidEmail;
      });
      return false;
    }
    if (emailController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = "";
      });
      return true;
    }
  }

  //Actions
  onTapSubmit() {
    FunctionalUtils.hideKeyboard();
    setState(() {
      emailController.text.isEmpty ? isEmailValid = false : isEmailValid = true;
    });

    emailValidation();
    if (isEmailValid) {
      CheckConnection().connectionState().then((value) {
        if (value == true) {
          forgotPasswordApiCall();
        } else {
          CommonWidgets().showErrorSnackBar(
              errorMessage: StringConstants.noInternetConnection,
              context: context);
        }
      });
    }
  }

  onTapSignIn() {
    widget.navigateBackToLoginView("");
  }

  @override
  void showError(GeneralErrorResponse exception) {
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
    widget.forgotPasswordLoader(false);
  }

  @override
  void showSuccess(response) {
    ForgotPasswordResponseModel responseModel = response;
    widget.forgotPasswordLoader(false);
    widget.navigateBackToLoginView(responseModel.general!.first.message);
  }
}

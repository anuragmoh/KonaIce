import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/account_switch/account_switch_screen.dart';
import 'package:kona_ice_pos/screens/forget_password/forget_password_screen.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements ResponseContractor {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late UserPresenter userPresenter;
  LoginRequestModel loginRequestModel = LoginRequestModel();

  _LoginScreenState() {
    userPresenter = UserPresenter(this);
  }

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isPasswordVisible = true;
  bool isLoginView = true;
  bool isApiProcess = false;
  String osVersion = '';
  String deviceName = '';
  String emailValidationMessage = "";
  String passwordValidationMessage = "";

  @override
  void initState() {
    super.initState();
    removeModeSelectionScreen();
  }

  @override
  Widget build(BuildContext context) {
    getDeviceInfo();
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
                padding: EdgeInsets.only(
                    top: 6.77 * SizeConfig.imageSizeMultiplier,
                    bottom: 5.07 * SizeConfig.imageSizeMultiplier),
                child: icon(),
              ),
              isLoginView
                  ? loginContainer()
                  : ForgetPasswordScreen(
                      navigateBackToLoginView: onTapFromForgetPasswordView,
                      forgotPasswordLoader: onForgotPasswordScreenLoader,
                    ),
              // loginContainer(),
            ],
          ),
        ),
      ),
    );
  }

  onForgotPasswordScreenLoader(bool isLoaderOn) {
    setState(() {
      isApiProcess = isLoaderOn;
    });
  }

  Widget icon() {
    return CommonWidgets().image(
        image: AssetsConstants.konaIcon,
        width: 20.96 * SizeConfig.imageSizeMultiplier,
        height: 15.62 * SizeConfig.imageSizeMultiplier);
  }

  Widget loginContainer() {
    return Container(
      width: 360,
      decoration:
          StyleConstants.customBoxShadowDecorationStyle(circularRadius: 3.6),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 3.25 * SizeConfig.imageSizeMultiplier,
                horizontal: 141.0),
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
              padding: const EdgeInsets.only(left: 23.0),
              child: textWidget(
                  StringConstants.emailId,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
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
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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
                  hintStyle: StyleConstants.customTextStyle(
                      fontSize: 15.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular),
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: textWidget(
                  StringConstants.password,
                  StyleConstants.customTextStyle(
                      fontSize: 14.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.65 * SizeConfig.imageSizeMultiplier,
                left: 22.0,
                right: 22.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: TextField(
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  passwordValidation();
                },
                controller: passwordController,
                obscureText: isPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: isPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.textColor2, width: 1.0),
                  ),
                  hintText: 'Password',
                  errorText: passwordValidationMessage,
/*                  errorText: (isPasswordValid = true)
                      ? null
                      : (isPasswordValid = false)
                          ? StringConstants.emptyValidPassword
                          : StringConstants.enterValidPassword,*/
                  hintStyle: StyleConstants.customTextStyle(
                      fontSize: 15.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratRegular),
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  right: 21.0,
                  bottom: 2.60 * SizeConfig.imageSizeMultiplier),
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
          signInButton(
              StringConstants.signIn,
              StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratBold)),
        ],
      ),
    );
  }

  Widget textWidget(String textTitle, TextStyle textStyle) {
    return Text(textTitle, style: textStyle);
  }

  Widget signInButton(String buttonText, TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.72 * SizeConfig.imageSizeMultiplier),
      child: GestureDetector(
        onTap: () {
          onTapSingIn();
        },
        child: Container(
          decoration: BoxDecoration(
            color: getMaterialColor(AppColors.primaryColor2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 1.56 * SizeConfig.imageSizeMultiplier,
                horizontal: 84.0),
            child: Text(buttonText, style: textStyle),
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

  passwordValidation() {
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordValidationMessage = StringConstants.emptyValidPassword;
      });
      return false;
    }
    if (!passwordController.text.isValidPassword()) {
      setState(() {
        passwordValidationMessage = StringConstants.enterValidPassword;
      });
      return false;
    }
    if (passwordController.text.isValidPassword()) {
      setState(() {
        passwordValidationMessage = "";
      });
      return true;
    }
  }

  onTapSingIn() {
    FocusScope.of(context).unfocus();
    setState(() {
      emailController.text.isEmpty ? isEmailValid = false : isEmailValid = true;
      passwordController.text.isEmpty
          ? isPasswordValid = false
          : isPasswordValid = true;
    });
    emailValidation();
    passwordValidation();
    /* if(emailController.text.isEmpty){
      setState(() {
        emailValidationMessage = StringConstants.emptyValidEmail;
      });
      return false;
    }
    if(!emailController.text.isValidEmail()){
      setState(() {
        emailValidationMessage = StringConstants.enterValidEmail;
      });
      return false;
    }*/
  /*  if (passwordController.text.isEmpty) {
      setState(() {
        passwordValidationMessage = StringConstants.emptyValidPassword;
      });
      return false;
    }
    if (!passwordController.text.isValidPassword()) {
      setState(() {
        passwordValidationMessage = StringConstants.emptyValidPassword;
      });
      return false;
    }*/

    if (isEmailValid && isPasswordValid) {
      CheckConnection().connectionState().then((value) {
        if (value == true) {
          callLoginApi();
        } else {
          CommonWidgets().showErrorSnackBar(
              errorMessage: StringConstants.noInternetConnection,
              context: context);
        }
      });
    }
  }

  onTapForgotPassword() {
    setState(() {
      isLoginView = false;
    });
  }

  onTapFromForgetPasswordView(String message) {
    setState(() {
      isLoginView = true;
    });
    CommonWidgets().showSuccessSnackBar(message: message, context: context);
  }

  //API Calls

  callLoginApi() {
    setState(() {
      isApiProcess = true;
    });
    loginRequestModel.email = emailController.text.toString();
    loginRequestModel.password = passwordController.text.toString();
    loginRequestModel.deviceId = deviceName;
    loginRequestModel.deviceType = Platform.operatingSystem;
    loginRequestModel.deviceModel = deviceName;
    loginRequestModel.os = Platform.operatingSystem;
    loginRequestModel.osVersion = osVersion;
    loginRequestModel.appVersion = AssetsConstants.appVersion;
    loginRequestModel.deviceName = deviceName;
    userPresenter.login(loginRequestModel);
  }

  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    osVersion = iosInfo.systemVersion;
    deviceName = iosInfo.localizedModel;
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    setState(() {
      isApiProcess = false;
    });
    LoginResponseModel loginResponseModel = response;
    checkUserDataAvailableINDB(loginResponseModel);
  }

  //DB Operations
  checkUserDataAvailableINDB(LoginResponseModel loginResponseModel) async {
    var sessionObj = await SessionDAO().getValueForKey(DatabaseKeys.userID);
    if (sessionObj != null && sessionObj.value == loginResponseModel.id) {
      debugPrint("old user");
    } else {
      await FunctionalUtils.clearAllDBData();
    }
    storeInformation(loginResponseModel);
  }

  storeInformation(LoginResponseModel loginResponseModel) async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.sessionKey, value: loginResponseModel.sessionKey!));
    await FunctionalUtils.saveUserDetailInDB(userModel: loginResponseModel);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AccountSwitchScreen()));
  }

  removeModeSelectionScreen() async {
    await SessionDAO().delete(DatabaseKeys.selectedMode);
  }
}

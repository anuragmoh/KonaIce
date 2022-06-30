import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/network_model/login/login_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/account_switch/account_switch_screen.dart';
import 'package:kona_ice_pos/screens/forget_password/forget_password_screen.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements ResponseContractor {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late UserPresenter _userPresenter;
  LoginRequestModel _loginRequestModel = LoginRequestModel();

  _LoginScreenState() {
    _userPresenter = UserPresenter(this);
  }

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isPasswordVisible = true;
  bool _isLoginView = true;
  bool _isApiProcess = false;
  String _osVersion = '';
  String _deviceName = '';
  String _populateEmail = '';
  String _emailValidationMessage = "";
  String _passwordValidationMessage = "";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _removeModeSelectionScreen();
  }

  _getUserInfo() async{
    var result = await SessionDAO().getValueForKey(DatabaseKeys.email);
    debugPrint('emailId------->${result!.value}');
    _populateEmail = result.value;
    _emailController.text=_populateEmail;
  }

  @override
  Widget build(BuildContext context) {
    _getDeviceInfo();
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor1,
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
                child: _icon(),
              ),
              _isLoginView
                  ? _loginContainer()
                  : ForgetPasswordScreen(
                      navigateBackToLoginView: _onTapFromForgetPasswordView,
                      forgotPasswordLoader: _onForgotPasswordScreenLoader,
                    ), // loginContainer(),
            ],
          ),
        ),
      ),
    );
  }

  _onForgotPasswordScreenLoader(bool isLoaderOn) {
    setState(() {
      _isApiProcess = isLoaderOn;
    });
  }

  Widget _icon() {
    return CommonWidgets().image(
        image: AssetsConstants.konaIcon,
        width: 20.96 * SizeConfig.imageSizeMultiplier,
        height: 15.62 * SizeConfig.imageSizeMultiplier);
  }

  Widget _loginContainer() {
    return Container(
      width: 360,
      decoration:
          StyleConstants.customBoxShadowDecorationStyle(circularRadius: 3.6),
      child: Column(
        children: [
          _imagePadding(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: _textWidget(
                  StringConstants.emailId,
                  StyleConstants.customTextStyle14MonsterRegular(
                      color: AppColors.textColor1)),
            ),
          ),
          _paddingEmail(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: _textWidget(
                  StringConstants.password,
                  StyleConstants.customTextStyle14MonsterRegular(
                      color: AppColors.textColor1)),
            ),
          ),
          _paddingPassword(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                  right: 21.0, bottom: 2.60 * SizeConfig.imageSizeMultiplier),
              child: InkWell(
                onTap: _onTapForgotPassword,
                child: _textWidget(
                    StringConstants.forgotPassword,
                    StyleConstants.customTextStyle12MontserratBold(
                        color: AppColors.denotiveColor4)),
              ),
            ),
          ),
          _signInButton(
              StringConstants.signIn,
              StyleConstants.customTextStyle12MontserratBold(
                  color: AppColors.textColor1)),
        ],
      ),
    );
  }

  Padding _paddingPassword() {
    return Padding(
      padding: EdgeInsets.only(
          top: 0.65 * SizeConfig.imageSizeMultiplier, left: 22.0, right: 22.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextField(
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            _passwordValidation();
          },
          controller: _passwordController,
          obscureText: _isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: _isPasswordVisible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor2, width: 1.0),
            ),
            hintText: 'Password',
            errorText: _passwordValidationMessage,
            hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                color: AppColors.textColor1),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor2, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor1, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Padding _paddingEmail() {
    return Padding(
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
            _emailValidation();
          },
          maxLength: 100,
          controller: _emailController,
          decoration: InputDecoration(
            counterText: "",
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor2, width: 1.0),
            ),
            hintText: 'abc@gmail.com',
            errorText: _emailValidationMessage,
            hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                color: AppColors.textColor1),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColor2, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor1, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Padding _imagePadding() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 3.25 * SizeConfig.imageSizeMultiplier, horizontal: 141.0),
      child: _textWidget(
          StringConstants.loginText,
          StyleConstants.customTextStyle22MontserratBold(
              color: AppColors.textColor1)),
    );
  }

  Widget _textWidget(String textTitle, TextStyle textStyle) {
    return Text(textTitle, style: textStyle);
  }

  Widget _signInButton(String buttonText, TextStyle textStyle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.72 * SizeConfig.imageSizeMultiplier),
      child: GestureDetector(
        onTap: () {
          _onTapSingIn();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor2,
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

  _emailValidation() {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailValidationMessage = StringConstants.emptyValidEmail;
      });
      return false;
    }
    if (!_emailController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = StringConstants.enterValidEmail;
      });
      return false;
    }
    if (_emailController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = "";
      });
      return true;
    }
  }

  _passwordValidation() {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordValidationMessage = StringConstants.emptyValidPassword;
      });
      return false;
    }
    if (!_passwordController.text.isValidPassword()) {
      setState(() {
        _passwordValidationMessage = "";
      });
      return false;
    }
    if (_passwordController.text.isValidPassword()) {
      setState(() {
        _passwordValidationMessage = "";
      });
      return true;
    }
  }

  _onTapSingIn() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _emailController.text.isEmpty || !_emailController.text.isValidEmail()
          ? _isEmailValid = false
          : _isEmailValid = true;
      _passwordController.text.isEmpty
          ? _isPasswordValid = false
          : _isPasswordValid = true;
    });
    _emailValidation();
    _passwordValidation();

    if (_isEmailValid && _isPasswordValid) {
      if (await CheckConnection.connectionState() == true) {
        _callLoginApi();
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
      debugPrint(">>>>>${await CheckConnection.connectionState()}");
    }
  }

  _onTapForgotPassword() {
    setState(() {
      _isLoginView = false;
    });
  }

  _onTapFromForgetPasswordView(String message) {
    setState(() {
      _isLoginView = true;
    });
    if (message != "") {
      CommonWidgets().showSuccessSnackBar(message: message, context: context);
    }
  }

  //API Calls
  _callLoginApi() {
    setState(() {
      _isApiProcess = true;
    });
    _loginRequestModel.email = _emailController.text.toString();
    _loginRequestModel.password = _passwordController.text.toString();
    _loginRequestModel.deviceId = _deviceName;
    _loginRequestModel.deviceType = Platform.operatingSystem;
    _loginRequestModel.deviceModel = _deviceName;
    _loginRequestModel.os = Platform.operatingSystem;
    _loginRequestModel.osVersion = _osVersion;
    _loginRequestModel.appVersion = AssetsConstants.appVersion;
    _loginRequestModel.deviceName = _deviceName;
    _userPresenter.login(_loginRequestModel);
  }

  _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    _osVersion = iosInfo.systemVersion;
    _deviceName = iosInfo.localizedModel;
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    setState(() {
      _isApiProcess = false;
    });
    LoginResponseModel loginResponseModel = response;
    _checkUserDataAvailableINDB(loginResponseModel);
  }

  //DB Operations
  _checkUserDataAvailableINDB(LoginResponseModel loginResponseModel) async {
    var sessionObj = await SessionDAO().getValueForKey(DatabaseKeys.userID);
    if (sessionObj != null && sessionObj.value == loginResponseModel.id) {
      debugPrint("old user");
    } else {
      await FunctionalUtils.clearAllDBData();
    }
    _storeInformation(loginResponseModel);
  }

  _storeInformation(LoginResponseModel loginResponseModel) async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.sessionKey, value: loginResponseModel.sessionKey!));
    await FunctionalUtils.saveUserDetailInDB(userModel: loginResponseModel);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AccountSwitchScreen()));
  }

  _removeModeSelectionScreen() async {
    await SessionDAO().delete(DatabaseKeys.selectedMode);
  }
}

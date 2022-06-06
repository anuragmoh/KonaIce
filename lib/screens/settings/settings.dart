import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/login/login_screen.dart';
import 'package:kona_ice_pos/utils/ServiceNotifier.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    implements ResponseContractor {
  late UserPresenter userPresenter;

  _SettingScreenState() {
    userPresenter = UserPresenter(this);
  }

  bool isApiProcess = false;

  @override
  void initState() {
    super.initState();
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textColor3,
        child: Center(child: body()),
      ),
    );
  }

  Widget body() {
    return CommonWidgets().buttonWidget(StringConstants.signOut, () {
      onTapSignOutButton();
    });
  }

  //Action Event
  onTapSignOutButton() {
    callLogoutApi();
  }

  //API Call
  callLogoutApi() {
    setState(() {
      isApiProcess = true;
    });

    userPresenter.logOut();
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
    final service = ServiceNotifier();
    setState(() {
      isApiProcess = false;
      service.increment(0);
    });
    deleteUserInformation();
  }

  //DB Operations

  deleteUserInformation() async {
    await SessionDAO().delete(DatabaseKeys.sessionKey);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

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

import '../reconnect_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    implements ResponseContractor {
  late UserPresenter _userPresenter;

  _SettingScreenState() {
    _userPresenter = UserPresenter(this);
  }

  bool _isApiProcess = false;
  bool _isShowReconnectButton = true;

  @override
  void initState() {
    super.initState();
    showReconnectButton();
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textColor3,
        child: Center(child: _body()),
      ),
    );
  }

  Widget _body() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonWidgets().buttonWidget(
          StringConstants.signOut,
          () {
            _onTapSignOutButton();
          },
        ),
        const SizedBox(
          width: 20,
        ),
        Visibility(
          visible: _isShowReconnectButton,
          child: CommonWidgets().buttonWidget(
            StringConstants.reconnect,
            () {
              _onTapReconnectButton();
            },
          ),
        ),
      ],
    );
  }
  _onTapReconnectButton() {
    showDialog(
        barrierDismissible: false,
        barrierColor: AppColors.textColor1.withOpacity(0.7),
        context: context,
        builder: (context) {
          return ReconnectScreenDialog(callBack: _showButton);
        });
  }
  _showButton(bool isConnected){
    if (isConnected) {
      setState(() {
        _isShowReconnectButton = false;
      });
    } else {
      setState(() {
        _isShowReconnectButton = true;
      });
    }
  }
  //Action Event
  _onTapSignOutButton() {
    _callLogoutApi();
  }

  //API Call
  _callLogoutApi() {
    setState(() {
      _isApiProcess = true;
    });

    _userPresenter.logOut();
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
    final service = ServiceNotifier();
    setState(() {
      _isApiProcess = false;
      service.increment(0);
    });
    _deleteUserInformation();
  }

  //DB Operations

  _deleteUserInformation() async {
    await SessionDAO().delete(DatabaseKeys.sessionKey);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
  showReconnectButton() async{
    var result = await SessionDAO().getValueForKey(DatabaseKeys.reConnect);
    if (result != null) {
      String lastValue = result.value;
      debugPrint("lastValue----->"+lastValue);
      if (lastValue == "true") {
        setState(() {
          _isShowReconnectButton = false;
        });
      } else {
        setState(() {
          _isShowReconnectButton = true;
        });
      }
    } else {
      setState(() {
        _isShowReconnectButton = true;
      });
    }
  }
}

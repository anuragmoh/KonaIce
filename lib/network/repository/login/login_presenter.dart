import 'package:kona_ice_pos/network/app_exception.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/login/login_repository.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';

import '../../general_error_model.dart';

class LoginPresenter {
  late ResponseContractor _view;
  late LoginRepository _loginRepository;

  LoginPresenter(this._view) {
    _loginRepository = LoginRepository();
  }

  void login(LoginRequestModel loginRequestModel) {
    _loginRepository
        .login(loginRequestModel)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

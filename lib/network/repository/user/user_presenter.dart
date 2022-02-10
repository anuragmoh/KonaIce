import 'package:kona_ice_pos/network/app_exception.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/user/user_repository.dart';
import 'package:kona_ice_pos/screens/forget_password/forgot_password_model.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';

import '../../general_error_model.dart';

class UserPresenter {
  late final ResponseContractor _view;
  late UserRepository _userRepository;

  UserPresenter(this._view) {
    _userRepository = UserRepository();
  }

  void login(LoginRequestModel loginRequestModel) {
    _userRepository
        .login(loginRequestModel)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

  void forgotPassword(ForgotPasswordRequestModel forgotPasswordRequestModel) {
    _userRepository
        .forgotPassword(forgotPasswordRequestModel)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }

  void logOut() {
    _userRepository
        .logOut()
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}

import 'package:kona_ice_pos/models/network_model/forgot_password/forgot_password_model.dart';
import 'package:kona_ice_pos/models/network_model/login/login_model.dart';
import 'package:kona_ice_pos/models/network_model/my_profile_model/my_profile_request_model.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/user/user_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class UserPresenter {
  late final ResponseContractor _view;
  late UserRepository _userRepository;

  UserPresenter(
    this._view,
  ) {
    _userRepository = UserRepository();
  }

  void login(LoginRequestModel loginRequestModel) {
    _userRepository.login(loginRequestModel).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

  void forgotPassword(ForgotPasswordRequestModel forgotPasswordRequestModel) {
    _userRepository.forgotPassword(forgotPasswordRequestModel).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

  void logOut() {
    _userRepository.logOut().then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }

  void getMyProfile(String userID) {
    _userRepository.getMyProfile(userID).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

  void updateProfile(
      String userID, MyProfileUpdateRequestModel myProfileUpdateRequestModel) {
    _userRepository
        .updateProfile(userID, myProfileUpdateRequestModel)
        .then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

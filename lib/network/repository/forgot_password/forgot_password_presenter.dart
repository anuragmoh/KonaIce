import 'package:kona_ice_pos/network/repository/forgot_password/forgot_password_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/login/login_repository.dart';
import 'package:kona_ice_pos/screens/forget_password/forgot_password_model.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';

class ForgotPasswordPresenter {
  late ResponseContractor _view;
  late ForgotPasswordRepository _forgotPasswordRepository;

  ForgotPasswordPresenter(this._view) {
    _forgotPasswordRepository = ForgotPasswordRepository();
  }

  void forgotPassword(ForgotPasswordRequestModel forgotPasswordRequestModel) {
    print(forgotPasswordRequestModel.email);
    _forgotPasswordRepository
        .forgotPassword(forgotPasswordRequestModel)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error.toString()));
    });
  }
}

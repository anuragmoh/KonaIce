import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/login/login_repository.dart';

class LoginPresenter {
  late ResponseContractor _view;
  late LoginRepository _loginRepository;

  LoginPresenter(this._view) {
    _loginRepository = LoginRepository();
  }


}

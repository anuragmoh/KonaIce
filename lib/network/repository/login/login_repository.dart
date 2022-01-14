import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/base_client.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';

class LoginRepository{
  BaseClient baseClient = BaseClient();

  Future<LoginResponseModel> login(loginRequestModel){
    return baseClient.post(UrlConstants.login, loginRequestModel).then((value){
      return loginResponseModelFromJson(value);
    });
  }
}
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/base_client.dart';
import 'package:kona_ice_pos/screens/forget_password/forgot_password_model.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile_model/my_profile_response_model.dart';

class UserRepository {
  BaseClient baseClient = BaseClient();

  Future<LoginResponseModel> login(loginRequestModel) {
    return baseClient.post(UrlConstants.login, loginRequestModel).then((value) {
      return loginResponseModelFromJson(value);
    });
  }

  Future<ForgotPasswordResponseModel> forgotPassword(
      forgotPasswordRequestModel) {
    return baseClient
        .post(UrlConstants.forgotPassword, forgotPasswordRequestModel)
        .then((value) {
      return forgotPasswordResponseModelFromJson(value);
    });
  }

  Future<General> logOut() {
    return baseClient.delete(UrlConstants.logout).then((value) {
      return generalResponseModelFromJson(value);
    });
  }


  Future<MyProfileResponseModel> getMyProfile(String userID){
    return baseClient.get(UrlConstants.getMyProfile(userID: userID)).then((value){
      return myProfileResponseModelFromJson(value);
    });
  }

  Future<General> updateProfile(String userID,myProfileUpdateRequestModel) {
    return baseClient
        .put(UrlConstants.getMyProfile(userID: userID), myProfileUpdateRequestModel)
        .then((value) {
      return generalResponseModelFromJson(value);
    });
  }
}

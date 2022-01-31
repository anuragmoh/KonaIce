
import 'package:kona_ice_pos/screens/forget_password/forgot_password_model.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import '../../base_client.dart';

class ClockInOutPresenterRepository{
  BaseClient baseClient = BaseClient();


  Future<General> clockInOutPresenter(clockInOutPresenterRequestModel){
    return baseClient.post(UrlConstants.forgotPassword, clockInOutPresenterRequestModel).then((value){
      return General.fromJson(value);
    });
  }

}
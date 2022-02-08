
import 'package:kona_ice_pos/constants/url_constants.dart';
import '../../base_client.dart';

class ClockInOutRepository{
  BaseClient baseClient = BaseClient();


  Future<bool> clockInOut(clockInOutRequestModel, String userID){
    return baseClient.put(UrlConstants.getDutyStatus(userID: userID), clockInOutRequestModel).then((value){
      return true;
    });
  }

}
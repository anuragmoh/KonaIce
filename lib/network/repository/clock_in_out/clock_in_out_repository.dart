
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/clock_in_out_model.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import '../../base_client.dart';

class ClockInOutRepository{
  BaseClient baseClient = BaseClient();


  Future<bool> clockInOutUpdate(clockInOutRequestModel, String userID){
    return baseClient.put(UrlConstants.getDutyStatus(userID: userID), clockInOutRequestModel).then((value){
      return true;
    });
  }

  Future<List<ClockInOutDetailsResponseModel>> clockInOutDetails({required String userID, required String startTimestamp, required String endTimestamp}){
    return baseClient.get(UrlConstants.getClockInOutDetails(userID: userID, startTimestamp:startTimestamp, endTimestamp: endTimestamp)).then((value){
      return clockInOutDetailsResponseModelFromJson(value);
    });
  }
}
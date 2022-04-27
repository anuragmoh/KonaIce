import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/base_client.dart';
import 'package:kona_ice_pos/network/general_success_model.dart';

class EventRepository {
  BaseClient baseClient = BaseClient();

  Future<GeneralSuccessModel> deleteOrder({required String orderId}) {
    return baseClient
        .delete(UrlConstants.deleteOrder(orderId: orderId))
        .then((value) => generalSuccessModelFromJson(value));
  }
}

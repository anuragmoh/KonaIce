import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/models/network_model/home/assest_model.dart';
import 'package:kona_ice_pos/models/network_model/home/create_event_model.dart';

import '../../base_client.dart';

class CreateAdhocEventRepository {
  BaseClient baseClient = BaseClient();

  Future<AssetsResponseModel> getAssets() {
    return baseClient.get(UrlConstants.assets).then((value) {
      return assetsModelResponseFromJson(value);
    });
  }

  Future<CreateEventResponseModel> createEvent(
      CreateEventRequestModel requestModel) {
    return baseClient
        .post(UrlConstants.createAdhocEvent, requestModel)
        .then((value) => createEventResponseModelFromJson(value));
  }
}

import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/screens/home/assest_model.dart';

import '../../base_client.dart';

class AssetsRepository{

  BaseClient baseClient = BaseClient();

  Future<AssetsResponseModel> getAssets(){
    return baseClient.get(UrlConstants.assets).then((value){
      return assetsModelResponseFromJson(value);
    });
  }

}
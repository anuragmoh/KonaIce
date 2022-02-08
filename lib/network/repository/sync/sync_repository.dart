import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class SyncRepository{
  BaseClient baseClient = BaseClient();


  Future<SyncEventMenu> syncData(syncEventRequestModel){
    return baseClient.post(UrlConstants.syncData,syncEventRequestModel).then((value){
      return syncEventMenuFromJson(value);
    });
  }

}
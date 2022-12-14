import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class SyncRepository {
  BaseClient baseClient = BaseClient();

  Future<dynamic> syncData(int lastSyncTime) async {
    return baseClient
        .post(UrlConstants.syncData, getSyncData(lastSyncTime))
        .then((value) {
      return syncEventMenuFromJson(value);
    });
  }

  getSyncData(int lastSyncTime) {
    SyncEventRequestModel _eventRequestModel = SyncEventRequestModel();
    _eventRequestModel.lastSyncAt = lastSyncTime;
    _eventRequestModel.entities = [
      DatabaseKeys.events,
      DatabaseKeys.categories,
      DatabaseKeys.items,
      DatabaseKeys.itemExtras
    ];
    return _eventRequestModel;
  }
}

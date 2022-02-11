import 'dart:convert';

import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/database/daos/events_dao.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class SyncRepository {
  BaseClient baseClient = BaseClient();

  Future<dynamic> syncData() async {
    return baseClient.post(UrlConstants.syncData, getSyncData(0)).then((value){
      return syncEventMenuFromJson(value);
    });
  }

  getSyncData(int lastSync) {
    SyncEventRequestModel _eventRequestModel = SyncEventRequestModel();
    _eventRequestModel.lastSyncAt = lastSync;
    _eventRequestModel.entities = [
      DatabaseKeys.events,
      DatabaseKeys.categories,
      DatabaseKeys.items,
      DatabaseKeys.itemExtras
    ];
    return _eventRequestModel;
  }
}

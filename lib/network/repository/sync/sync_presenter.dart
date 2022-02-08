import 'package:kona_ice_pos/models/data_models/sync_event_menu.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/sync/sync_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class SyncPresenter {
  late final ResponseContractor _view;
  late SyncRepository _syncRepository;

  SyncPresenter(this._view) {
    _syncRepository = SyncRepository();
  }

  void syncData(SyncEventRequestModel syncEventRequestModel) {
    _syncRepository.syncData(syncEventRequestModel).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}

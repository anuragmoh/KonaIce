import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/sync/sync_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class SyncPresenter {
  late final SyncResponseContractor _view;
  late SyncRepository _syncRepository;

  SyncPresenter(this._view) {
    _syncRepository = SyncRepository();
  }

  void syncData(int lastSyncTime) {
    _syncRepository.syncData(lastSyncTime).then((value) {
      _view.showSyncSuccess(value);
    }).onError((error, stackTrace) {
      _view.showSyncError(FetchException(error).fetchErrorModel());
    });
  }
}

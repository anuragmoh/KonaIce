import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/create_adhoc_event/create_adhoc_event_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/models/network_model/home/create_event_model.dart';

class CreateAdhocEventPresenter {
  late final AssetsResponseContractor _view;
  late CreateAdhocEventRepository repository;

  CreateAdhocEventPresenter(this._view) {
    repository = CreateAdhocEventRepository();
  }

  void getAssets() {
    repository.getAssets().then((value) {
      _view.showAssetsSuccess(value);
    }).onError((error, stackTrace) {
      _view.showAssetsError(FetchException(error.toString()).fetchErrorModel());
    });
  }

  void createEvent(CreateEventRequestModel requestModel) {
    repository.createEvent(requestModel).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

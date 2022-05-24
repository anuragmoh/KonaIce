import 'package:kona_ice_pos/models/network_model/clock_in_clock_out/clock_in_out_model.dart';

import '../../exception.dart';
import '../../response_contractor.dart';
import 'clock_in_out_repository.dart';

class ClockInOutPresenter {
  late final ClockInOutResponseContractor _view;
  late ClockInOutRepository _clockInOutRepository;

  ClockInOutPresenter(this._view) {
    _clockInOutRepository = ClockInOutRepository();
  }

  void clockInOutUpdate(
      ClockInOutRequestModel clockInOutPresenterRequestModel, String userID) {
    _clockInOutRepository
        .clockInOutUpdate(clockInOutPresenterRequestModel, userID)
        .then((value) {
      _view.showSuccessForUpdateClockIN(value);
    }).onError((error, stackTrace) {
      _view.showErrorForUpdateClockIN(FetchException(error).fetchErrorModel());
    });
  }

  void clockInOutDetails(
      {required String userID,
      required String startTimestamp,
      required String endTimestamp}) {
    _clockInOutRepository
        .clockInOutDetails(
            userID: userID,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp)
        .then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

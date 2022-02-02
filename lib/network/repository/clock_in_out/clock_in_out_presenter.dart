import 'package:kona_ice_pos/screens/dashboard/clock_in_out_model.dart';

import '../../exception.dart';
import '../../response_contractor.dart';
import 'clock_in_out_repository.dart';

class ClockInOutPresenter {
  late ResponseContractor _view;
  late ClockInOutPresenterRepository _clockInOutPresenterRepository;

  ClockInOutPresenter(this._view) {
    _clockInOutPresenterRepository = ClockInOutPresenterRepository();
  }

  void clockInOutPresenter(ClockInOutPresenterRequestModel clockInOutPresenterRequestModel) {
    _clockInOutPresenterRepository
        .clockInOutPresenter(clockInOutPresenterRequestModel)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}

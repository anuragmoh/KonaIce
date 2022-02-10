import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/extra_food_item/extra_food_item_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ExtraFoodItemPresenter {
  late final ResponseContractor _view;
  late ExtraFoodItemRepository _extraFoodItemRepository;

  ExtraFoodItemPresenter(this._view) {
    _extraFoodItemRepository = ExtraFoodItemRepository();
  }

  void getExtraFoodItemByItemId({required String eventId, required String itemId}) {
    _extraFoodItemRepository
        .getExtraFoodItemByItemId(eventId,itemId)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

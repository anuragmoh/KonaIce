import 'package:kona_ice_pos/network/repository/extra_food_item/extra_food_item_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ExtraFoodItemPresenter {
  late ResponseContractor _view;
  late ExtraFoodItemRepository _extraFoodItemRepository;

  ExtraFoodItemPresenter(this._view) {
    _extraFoodItemRepository = ExtraFoodItemRepository();
  }
}

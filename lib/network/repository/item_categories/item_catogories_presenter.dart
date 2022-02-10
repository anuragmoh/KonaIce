import 'package:kona_ice_pos/network/repository/item_categories/item_categories_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ItemCategoriesPresenter{
  late ResponseContractor _view;
  late ItemCategoriesRepository _itemCategoriesRepository;

  ItemCategoriesPresenter(this._view){
    _itemCategoriesRepository = ItemCategoriesRepository();
  }


}
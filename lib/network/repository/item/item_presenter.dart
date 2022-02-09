import 'package:kona_ice_pos/network/repository/item/item_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ItemPresenter{
  late ResponseContractor _view;
  late ItemRepository _itemRepository;

  ItemPresenter(this._view){
    _itemRepository = ItemRepository();
  }

}
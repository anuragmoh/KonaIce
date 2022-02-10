import 'package:kona_ice_pos/network/app_exception.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/item/item_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ItemPresenter {
  late final ResponseContractor _view;
  late ItemRepository _itemRepository;

  ItemPresenter(this._view) {
    _itemRepository = ItemRepository();
  }


  getAllItemsByEvent(String eventId){
    _itemRepository.getAllItemsByEvent(eventId).then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
  getItemsByCategories(String categoryId){
    _itemRepository.getItemsByCategories(categoryId).then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}

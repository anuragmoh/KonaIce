import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/item_categories/item_categories_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class ItemCategoriesPresenter{
  late final ResponseContractor _view;
  late ItemCategoriesRepository _itemCategoriesRepository;

  ItemCategoriesPresenter(this._view){
    _itemCategoriesRepository = ItemCategoriesRepository();
  }


  void getItemCategories(String eventId) {
    _itemCategoriesRepository
        .getItemCategories(eventId)
        .then((value){
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
  void getAllItemCategories() {
    _itemCategoriesRepository
        .getAllItemCategories()
        .then((value){
          print("Presenter Success $value");
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      print("Presenter error ${error.toString()}");
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

}
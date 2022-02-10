import 'package:kona_ice_pos/database/daos/item_categories_dao.dart';
import 'package:kona_ice_pos/models/data_models/item_categories.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class ItemCategoriesRepository{
  BaseClient baseClient = BaseClient();

  Future<ItemCategories> getItemCategories(String eventId){
    return ItemCategoriesDAO().getCategoriesByEventId(eventId).then((value){
      return value!;
    });
  }
  Future<dynamic> getAllItemCategories(){
    return ItemCategoriesDAO().getAllCategories().then((value){
      print("Repository value $value");
      return value!;
    });
  }
}
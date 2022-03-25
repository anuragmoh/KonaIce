import 'package:kona_ice_pos/database/daos/item_dao.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class ItemRepository{
  BaseClient baseClient = BaseClient();

  // Future<Item> getAllItemsByEvent(String eventId){
  //   return ItemDAO().getAllItemsByEventId(eventId).then((value){
  //     return value!;
  //   });
  // }
  // Future<Item> getItemsByCategories(String categoryId){
  //   return ItemDAO().getAllItemsByCategories(categoryId).then((value){
  //     return value!;
  //   });
  // }

}
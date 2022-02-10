import 'package:kona_ice_pos/database/daos/food_extra_items_dao.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/network/base_client.dart';

class ExtraFoodItemRepository{
  BaseClient baseClient = BaseClient();

/*  Future<FoodExtraItems> getExtraFoodItemByItemId(String eventId,String itemId){
    return FoodExtraItemsDAO().getFoodExtraByEventIdAndItemId(eventId, itemId).then((value){
      return value!;
    });
  }*/
}
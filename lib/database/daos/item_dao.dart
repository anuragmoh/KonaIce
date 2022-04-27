import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';
import 'food_extra_items_dao.dart';

class ItemDAO {
  static const String tableName = "items";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(Item item) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, event_id ,item_category_id, image_file_id, item_code, name, description, price, activated,sequence, created_by, created_at, updated_by, updated_at, deleted, franchise_id) "
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)",
          [
            item.id,
            item.eventId,
            item.itemCategoryId,
            item.imageFileId,
            item.itemCode,
            item.name,
            item.description,
            item.price,
            item.activated,
            item.sequence,
            item.createdBy,
            item.createdAt,
            item.updatedBy,
            item.updatedAt,
            item.deleted,
            item.franchiseId
          ]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<Item>?> getAllItemsByEventId(String eventId) async {
    try {
      final db = await _db;
      var result = await db.rawQuery(
          "SELECT * from $tableName where event_id=? ORDER BY sequence ASC",
          [eventId]);
      if (result.isNotEmpty) {
        return getItemList(result);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

// Future<List<Item>?> getAllItemsByEventId(String eventId) async {
//   try {
//     final db = await _db;
//     var result =
//     await db.rawQuery("SELECT * from $tableName where event_id=?",[eventId]);
//     if (result.isNotEmpty) {
//       List<Item> itemList = List.generate(result.length, (index)  {
//         Item item = Item.fromMap(result[index]);
//         FoodExtraItemsDAO().getFoodExtraByEventIdAndItemId(item.eventId, item.id).then((value) {
//           if(value != null) {
//             item.foodExtraItemList.addAll(value);
//           }
//         });
//         return item;
//       });
//       return itemList;
//     } else {
//       return null;
//     }
//   } catch (error) {
//     debugPrint(error.toString());
//   }
// }
  Future<List<Item>?> getAllItemsByCategories(String categoryId) async {
    try {
      final db = await _db;
      var result = await db.rawQuery(
          "SELECT * from $tableName where item_category_id=? ORDER BY sequence ASC",
          [categoryId]);
      if (result.isNotEmpty) {
        return List.generate(
            result.length, (index) => Item.fromMap(result[index]));
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearItemsByEventID({required String eventID}) async {
    try {
      final db = await _db;
      await db
          .rawDelete("DELETE from $tableName where event_id = ?", [eventID]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearItemData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<Item>?> getItemList(List<dynamic> result) async {
    List<Item> itemList = [];
    int count = 0;
    for (var element in result) {
      count = count + 1;
      Item item = Item.fromMap(element);
      List<FoodExtraItems> extrasList =
          await getExtraFoodItem(eventID: item.eventId, itemID: item.id);
      item.foodExtraItemList.addAll(extrasList);
      itemList.add(item);
      if (count == result.length) {
        return itemList;
      }
    }
  }

//Dependent Function or Dao class
  Future<List<FoodExtraItems>> getExtraFoodItem(
      {required String eventID, required String itemID}) async {
    var result = await FoodExtraItemsDAO()
        .getFoodExtraByEventIdAndItemId(eventID, itemID);
    List<FoodExtraItems> foodExtraItemList = [];
    if (result != null) {
      return result;
    } else {
      return foodExtraItemList;
    }
  }
}


import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class FoodExtraItemsDAO {
  static const String tableName = "food_extra_items";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(FoodExtraItems foodExtraItems) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, food_extra_item_category_id, item_name, selling_price, selection, image_file_id, min_qty_allowed, max_qty_allowed, activated, created_by, created_at, updated_by, updated_at, deleted)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [foodExtraItems.id, foodExtraItems.foodExtraItemCategoryId, foodExtraItems.itemName, foodExtraItems.sellingPrice, foodExtraItems.selection, foodExtraItems.imageFileId, foodExtraItems.minQtyAllowed, foodExtraItems.maxQtyAllowed, foodExtraItems.activated, foodExtraItems.createdBy, foodExtraItems.createdAt, foodExtraItems.updatedBy, foodExtraItems.updatedAt, foodExtraItems.deleted]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<FoodExtraItems?> getFoodExtraByEventIdAndItemId(String eventId,String itemId) async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName where eventId=? AND itemId=?",[eventId,itemId]);
      if (result.isNotEmpty) {
        return FoodExtraItems.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearFoodExtraItemsData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
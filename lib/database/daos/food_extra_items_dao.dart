import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          "INSERT OR REPLACE INTO $tableName (id, food_extra_item_category_id,item_id,event_id, item_name, selling_price, selection, image_file_id, min_qty_allowed, max_qty_allowed, activated, created_by, created_at, updated_by, updated_at, deleted)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? ,?)",
          [foodExtraItems.id, foodExtraItems.foodExtraItemCategoryId,foodExtraItems.itemId,foodExtraItems.eventId, foodExtraItems.itemName, foodExtraItems.sellingPrice, foodExtraItems.selection, foodExtraItems.imageFileId, foodExtraItems.minQtyAllowed, foodExtraItems.maxQtyAllowed, foodExtraItems.activated, foodExtraItems.createdBy, foodExtraItems.createdAt, foodExtraItems.updatedBy, foodExtraItems.updatedAt, foodExtraItems.deleted]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<FoodExtraItems>?> getFoodExtraByEventIdAndItemId(String eventId,String itemId) async {
    try {
      final db = await _db;
      print('itemID $itemId---->eventID $eventId');
      var result =
      await db.rawQuery("SELECT * from $tableName where event_id=? AND item_id=?",[eventId,itemId]);
      if (result.isNotEmpty) {
        print(result);
        return List.generate(result.length, (index) => FoodExtraItems.fromMap(result[index]));
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearFoodExtraItemsByEventID({required String eventID}) async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName where event_id = ?", [eventID]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearFoodExtraItemsByEventIDAndItemID({required String eventID, required String itemID}) async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName where event_id = ? and item_id = ?", [eventID, itemID]);
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
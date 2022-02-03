import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/event_food_extra_item_mapping.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class EventFoodExtraItemMappingDAO {
  static const String tableName = "event_food_extra_item_mappings";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(EventFoodExtraItemMapping eventFoodExtraItemMapping) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, event_item_id, event_id, item_category_id, item_id, food_extra_category_id, food_extra_item_id, activated, created_by, created_at, updated_by, updated_at, deleted, price, sequence)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                [eventFoodExtraItemMapping.id, eventFoodExtraItemMapping.eventItemId, eventFoodExtraItemMapping.eventId, eventFoodExtraItemMapping.itemCategoryId, eventFoodExtraItemMapping.itemId, eventFoodExtraItemMapping.foodExtraCategoryId, eventFoodExtraItemMapping.foodExtraItemId, eventFoodExtraItemMapping.activated, eventFoodExtraItemMapping.createdBy, eventFoodExtraItemMapping.createdAt, eventFoodExtraItemMapping.updatedBy, eventFoodExtraItemMapping.updatedAt, eventFoodExtraItemMapping.deleted, eventFoodExtraItemMapping.price, eventFoodExtraItemMapping.sequence]);
                return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<EventFoodExtraItemMapping?> getValues() async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return EventFoodExtraItemMapping.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearEventFoodExtraItemMappingData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
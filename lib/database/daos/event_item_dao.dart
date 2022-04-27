import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/event_item.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class EventItemDAO {
  static const String tableName = "event_items";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(EventItem eventItem) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, item_id, event_id, price, created_by, created_at, updated_by, updated_at, deleted, sequence, gift, item_category_id, sold_qty, comp_qty)"
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            eventItem.id,
            eventItem.itemId,
            eventItem.eventId,
            eventItem.price,
            eventItem.createdBy,
            eventItem.createdAt,
            eventItem.updatedBy,
            eventItem.updatedAt,
            eventItem.deleted,
            eventItem.sequence,
            eventItem.gift,
            eventItem.itemCategoryId,
            eventItem.soldQty,
            eventItem.compQty
          ]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<EventItem?> getValues() async {
    try {
      final db = await _db;
      var result = await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return EventItem.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearEventItemData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

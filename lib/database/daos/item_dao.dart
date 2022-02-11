


import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/item.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class ItemDAO {
static const String tableName = "items";

Future<Database> get _db async => await DatabaseHelper.shared.database;

Future insert(Item item) async {
  try {
    final db = await _db;
    var result = await db.rawInsert(
        "INSERT OR REPLACE INTO $tableName (id, event_id ,item_category_id, image_file_id, item_code, name, description, price, activated, created_by, created_at, updated_by, updated_at, deleted, franchise_id) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)",
        [item.id, item.eventId,item.itemCategoryId, item.imageFileId, item.itemCode, item.name, item.description, item.price, item.activated, item.createdBy, item.createdAt, item.updatedBy, item.updatedAt, item.deleted, item.franchiseId]);
    return result;
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<Item?> getAllItemsByEventId(String eventId) async {
  try {
    final db = await _db;
    var result =
    await db.rawQuery("SELECT * from $tableName where event_id=?",[eventId]);
    if (result.isNotEmpty) {
      return Item.fromMap(result.first);
    } else {
      return null;
    }
  } catch (error) {
    debugPrint(error.toString());
  }
}
Future<Item?> getAllItemsByCategories(String categoryId) async {
  try {
    final db = await _db;
    var result =
    await db.rawQuery("SELECT * from $tableName where item_category_id=?",[categoryId]);
    if (result.isNotEmpty) {
      return Item.fromMap(result.first);
    } else {
      return null;
    }
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
}
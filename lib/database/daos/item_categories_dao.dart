
import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/item_categories.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class ItemCategoriesDAO {
  static const String tableName = "item_categories";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(ItemCategories itemCategories) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, category_code, category_name, description, activated, created_by, created_at, updated_by, updated_at, deleted, franchise_id)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [itemCategories.id, itemCategories.categoryCode, itemCategories.categoryName, itemCategories.description, itemCategories.activated, itemCategories.createdBy, itemCategories.createdAt, itemCategories.updatedBy, itemCategories.updatedAt, itemCategories.deleted, itemCategories.franchiseId]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<ItemCategories?> getValues() async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return ItemCategories.fromMap(result.first);
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

import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/food_extra_items_categories.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class FoodExtraItemsCategoriesDAO {
  static const String tableName = "food_extra_item_categories";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(FoodExtraItemsCategories foodExtraItemsCategories) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, category_name, type, min_qty_allowed, max_qty_allowed, activated, created_by, created_at, updated_by, updated_at, deleted, franchise_id)"
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [foodExtraItemsCategories.id, foodExtraItemsCategories.categoryName, foodExtraItemsCategories.type, foodExtraItemsCategories.minQtyAllowed, foodExtraItemsCategories.maxQtyAllowed, foodExtraItemsCategories.activated, foodExtraItemsCategories.createdBy, foodExtraItemsCategories.createdAt, foodExtraItemsCategories.updatedBy, foodExtraItemsCategories.updatedAt, foodExtraItemsCategories.deleted, foodExtraItemsCategories.franchiseId]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<FoodExtraItemsCategories?> getValues() async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return FoodExtraItemsCategories.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearFoodExtraItemsCategoriesData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
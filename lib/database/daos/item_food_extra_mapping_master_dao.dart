import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/item_food_extra_mapping_master.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_helper.dart';

class ItemFoodExtraMappingMasterDAO {
  static const String tableName = "item_food_extra_mapping_masters";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(ItemFoodExtraMappingMaster itemFoodExtraMappingMaster) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (id, item_category_id, item_id, food_extra_category_id, food_extra_item_id, activated, created_by, created_at, updated_by, updated_at, deleted, price, sequence)"
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            itemFoodExtraMappingMaster.id,
            itemFoodExtraMappingMaster.itemCategoryId,
            itemFoodExtraMappingMaster.itemId,
            itemFoodExtraMappingMaster.foodExtraCategoryId,
            itemFoodExtraMappingMaster.foodExtraItemId,
            itemFoodExtraMappingMaster.price,
            itemFoodExtraMappingMaster.sequence,
            itemFoodExtraMappingMaster.activated,
            itemFoodExtraMappingMaster.createdBy,
            itemFoodExtraMappingMaster.createdAt,
            itemFoodExtraMappingMaster.updatedBy,
            itemFoodExtraMappingMaster.updatedAt,
            itemFoodExtraMappingMaster.deleted
          ]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<ItemFoodExtraMappingMaster?> getValues() async {
    try {
      final db = await _db;
      var result = await db.rawQuery("SELECT * from $tableName");
      if (result.isNotEmpty) {
        return ItemFoodExtraMappingMaster.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearItemFoodExtraMappingMasterData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:kona_ice_pos/database/database_helper.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_extra_items.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SavedOrdersExtraItemsDAO {
  static const String tableName = "saved_orders_extra_items";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(SavedOrdersExtraItems savedOrdersExtraItems) async{
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (order_id,item_id,extra_food_item_id,extra_food_item_name,extra_food_item_category_id,quantity,unit_price,total_price,deleted)"
              "VALUES (?,?,?,?,?,?,?,?,?)",
          [savedOrdersExtraItems.orderId,savedOrdersExtraItems.itemId,savedOrdersExtraItems.extraFoodItemId,savedOrdersExtraItems.extraFoodItemName,savedOrdersExtraItems.extraFoodItemCategoryId,savedOrdersExtraItems.quantity,savedOrdersExtraItems.unitPrice,savedOrdersExtraItems.totalPrice,savedOrdersExtraItems.deleted]);
      return result;
    }catch(error){
      debugPrint(error.toString());
    }
  }
  Future<List<SavedOrdersExtraItems>?> getExtraItemList(
      {required String itemId, required String orderId}) async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName where item_id=? AND order_id=?",[itemId,orderId]);
      if (result.isNotEmpty) {
        return List.generate(result.length, (index) => SavedOrdersExtraItems.fromMap(result[index]));
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearEventDataByOrderID(String orderID) async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName where order_id = ?", [orderID]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearEventsData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }

}

import 'package:flutter/material.dart';
import 'package:kona_ice_pos/database/database_helper.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders_items.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SavedOrdersItemsDAO {
  static const String tableName = "saved_orders_item";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(SavedOrdersItem savedOrdersItem) async{
    try {
      final db = await _db;
      var result = await db.rawInsert(
        "INSERT OR REPLACE INTO $tableName (order_id,item_id,item_name,quantity,unit_price,total_price,item_category_id,deleted)"
         "VALUES (?,?,?,?,?,?,?,?)",
         [savedOrdersItem.orderId,savedOrdersItem.itemId,savedOrdersItem.itemName,savedOrdersItem.quantity,savedOrdersItem.unitPrice,savedOrdersItem.totalPrice,savedOrdersItem.itemCategoryId,savedOrdersItem.deleted]);
      return result;
    }catch(error){
      debugPrint(error.toString());
    }
  }
  Future<List<SavedOrdersItem>?> getItemList({required String orderId}) async {
    try {
      final db = await _db;
      var result =
      await db.rawQuery("SELECT * from $tableName where order_id=$orderId");
      if (result.isNotEmpty) {
        return List.generate(result.length, (index) => SavedOrdersItem.fromMap(result[index]));
      } else {
        return null;
      }
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
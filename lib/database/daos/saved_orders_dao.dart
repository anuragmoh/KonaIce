import 'package:flutter/material.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/database/database_helper.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SavedOrdersDAO {
  static const String tableName = "saved_orders";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(SavedOrders savedOrders) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (event_id,card_id,order_code,order_id,customer_name,phone_number,phone_country_code,address1,address2,country,state,city,zip_code,order_date,tip,discount,food_cost,total_amount,payment,order_status,deleted,payment_term,refund_amount)"
          "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            savedOrders.eventId,
            savedOrders.cardId,
            savedOrders.orderCode,
            savedOrders.orderId,
            savedOrders.customerName,
            savedOrders.phoneNumber,
            savedOrders.phoneCountryCode,
            savedOrders.address1,
            savedOrders.address2,
            savedOrders.country,
            savedOrders.state,
            savedOrders.city,
            savedOrders.zipCode,
            savedOrders.orderDate,
            savedOrders.tip,
            savedOrders.discount,
            savedOrders.foodCost,
            savedOrders.totalAmount,
            savedOrders.payment,
            savedOrders.orderStatus,
            savedOrders.deleted,
            savedOrders.paymentTerm,
            savedOrders.refundAmount
          ]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<SavedOrders>?> getOrdersList(String eventId) async {
    try {
      final db = await _db;
      var result = await db.rawQuery(
          "SELECT * from $tableName where event_id=? order by order_date DESC",
          [eventId]);
      if (result.isNotEmpty) {
        return List.generate(
            result.length, (index) => SavedOrders.fromMap(result[index]));
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<SavedOrders>?> getOrder(String orderId) async {
    try {
      final db = await _db;
      var result = await db
          .rawQuery("SELECT * from $tableName where order_id=?", [orderId]);
      if (result.isNotEmpty) {
        return List.generate(
            result.length, (index) => SavedOrders.fromMap(result[index]));
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
      await db
          .rawDelete("DELETE from $tableName where order_id = ?", [orderID]);
    } catch (error) {
      debugPrint(error.toString());
    }
    await SavedOrdersItemsDAO().clearEventDataByOrderID(orderID);
    await SavedOrdersExtraItemsDAO().clearEventDataByOrderID(orderID);
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

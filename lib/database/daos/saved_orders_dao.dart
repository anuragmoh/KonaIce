import 'package:flutter/material.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/database/database_helper.dart';
import 'package:kona_ice_pos/models/data_models/saved_orders.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../models/data_models/session.dart';

class SavedOrdersDAO {
  static const String tableName = "saved_orders";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(SavedOrders savedOrders) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (event_id,card_id,order_code,order_id,customer_name,phone_number,phone_country_code,address1,address2,country,state,city,zip_code,order_date,tip,tax_amount,discount,food_cost,total_amount,grand_total,payment,order_status,deleted,payment_term,refund_amount,pos_payment_method)"
          "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
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
            savedOrders.tax_amount,
            savedOrders.discount,
            savedOrders.foodCost,
            savedOrders.totalAmount,
            savedOrders.grandTotalAmount,
            savedOrders.payment,
            savedOrders.orderStatus,
            savedOrders.deleted,
            savedOrders.paymentTerm,
            savedOrders.refundAmount,
            savedOrders.posPaymentMethod
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
        debugPrint('saveOrderDao${result}');
        return List.generate(
            result.length, (index) => SavedOrders.fromMap(result[index]));
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<SavedOrders>?> getFilteredOrdersList(String text) async {
    try {
      final db = await _db;
      var result = await db.rawQuery(
          "SELECT * FROM $tableName WHERE customer_name LIKE '%${text}%' OR order_id LIKE '%${text}%' OR order_code LIKE '%${text}%' order by order_date DESC");
      if (result.isNotEmpty) {
        debugPrint('saveOrderDao${result}');
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

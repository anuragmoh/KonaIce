import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../database_helper.dart';

class SessionDAO {
  static const String tableName = "session_data";

  Future<Database> get _db async => await DatabaseHelper.shared.database;

  Future insert(Session session) async {
    try {
      final db = await _db;
      var result = await db.rawInsert(
          "INSERT OR REPLACE INTO $tableName (key,value) VALUES (?,?)",
          [session.key, session.value]);
      return result;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<Session?> getValueForKey(String key) async {
    try {
      final db = await _db;
      var result =
          await db.rawQuery("SELECT * from $tableName where key = ?", [key]);

      if (result.isNotEmpty) {
        return Session.fromMap(result.first);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future delete(String key) async {
    try {
      final db = await _db;
      await db.delete(tableName, where: "key = ?", whereArgs: [key]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future clearSessionData() async {
    try {
      final db = await _db;
      await db.rawDelete("DELETE from $tableName");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

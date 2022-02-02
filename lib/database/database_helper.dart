import 'package:sqflite_sqlcipher/sqflite.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/database/secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'db_scheme.dart';

class DatabaseHelper {
  final Map<int, List<String>> migrationScripts = {
    1: [
      DBScheme.sessionTable,
      DBScheme.eventsTable,
      DBScheme.eventItemTable,
      DBScheme.eventFoodExtraItemMappingTable,
      DBScheme.foodExtraItemsCategoriesTable,
      DBScheme.foodExtraItemsTable,
      DBScheme.itemCategoriesTable,
      DBScheme.itemFoodExtraMappingMasterTable,
      DBScheme.itemsTable,
      // DBScheme.orderFoodExtraItemMappingTable,
      // DBScheme.orderItemsTable,
      // DBScheme.ordersTable,

        ],
  };

  // Singleton instance
  static final DatabaseHelper _shared = DatabaseHelper._();

  // Singleton accessor
  static DatabaseHelper get shared => _shared;

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDB();
    return _database!;
  }

  Future initializeDB() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    debugPrint(documentsDir.toString());
    final dbPath = join(documentsDir.path, "trans_passenger.db");
   var password = await SecureStorage.getDBPassword();
   // var password = "";
    if (password == null) {
      password = _randomAlphaNumericString(16);
      await SecureStorage.setDBPassword(password);
    }
    debugPrint(password);
    return await openDatabase(dbPath,
        password: password, version: migrationScripts.length,
        onCreate: (Database db, int version) async {
      var queries = [];
      migrationScripts.forEach((key, value) {
        queries.addAll(value);
      });
      for (int i = 0; i < queries.length; i++) {
        await db.execute(queries[i]);
      }
    }, onUpgrade: (db, olderVersion, newVersion) async {
      var queries = [];
      for (int i = olderVersion + 1; i <= newVersion; i++) {
        var list = migrationScripts[i];
        if (list != null) {
          queries.addAll(list);
        }
      }
      for (int i = 0; i < queries.length; i++) {
        await db.execute(queries[i]);
      }
    });
  }

  String _randomAlphaNumericString(int length) {
    const allowedChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    var randomString = "";
    for (var i = 0; i <= length - 1; i++) {
      final randomIndex = Random().nextInt(allowedChars.length);
      final newCharacter = allowedChars[randomIndex];
      randomString += newCharacter;
    }
    return randomString;
  }
}

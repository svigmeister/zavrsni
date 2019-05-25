import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/parcel.dart';


class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyCropDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    debugPrint('Entered _initDatabase [dbHelper]');
    // The path_provider plugin gets the right directory for Android or iOS.
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter...
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    debugPrint('Entered _onCreate [dbHelper]');
    await db.execute('''
              CREATE TABLE $tableParcel (
                $columnParcelId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnParcelName TEXT NOT NULL,
                $columnM2 REAL NOT NULL,
                $columnCrop TEXT NOT NULL,
                $columnIncome REAL,
                $columnTotalQuantity REAL,
                $columnCurrentQuantity REAL
              )
              ''');
  }

  // Database helper methods:

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertParcel(Map<String, dynamic> row) async {
    debugPrint('Entered insertParcel [dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableParcel, row);
    return id;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  /*Future<List<Map<String, dynamic>>> queryAllParcels() async {
    Database db = await instance.database;
    return await db.query(tableParcel);
  }*/

  Future<List<Parcel>> getAllParcels() async {
    debugPrint('Entered getAllParcels [dbHelper]');
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(tableParcel);
    int count = mapList.length;
    List<Parcel> parcelList = List<Parcel>(count);
    for (int i = 0; i < count; i++) {
      parcelList.add(Parcel.fromMap(mapList[i]));
    }
    debugPrint('Parcel list: [dbHelper]\n' + parcelList.toString());
    return parcelList;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateParcel(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnParcelId];
    return await db.update(tableParcel, row, where: '$columnParcelId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteParcel(int id) async {
    Database db = await instance.database;
    return await db.delete(tableParcel, where: '$columnParcelId = ?', whereArgs: [id]);
  }

// All repeated column names are commented, here only to see the whole table structure
  final String tableParcel = 'parcel';
  final String columnParcelId = '_id';
  final String columnParcelName = 'parcelName';
  final String columnM2 = 'm2';
  final String columnCrop = 'crop';
  final String columnIncome = 'income';
  final String columnTotalQuantity = 'totalQuantity';
  final String columnCurrentQuantity = 'currentQuantity';

  final String tableTool = 'tool';
  final String columnToolId = '_id';
  final String columnToolName = 'toolName';
  final String columnCropName = 'cropName';
  final String columnActivityType = 'activityType';

  final String tableCrop = 'crop';
  final String columnCropId = '_id';
// final String columnCropName = 'cropName';

  final String tableActivity = 'activity';
  final String columnActivityId = '_id';
// final String columnActivityType = 'ActivityType';
// final String columnCropName = 'cropName';
  final String columnStartTime = 'startTime';
  final String columnTips = 'tips';

  final String tableActivityType = 'activityType';
  final String columnActivityTypeId = '_id';
// final String columnActivityType = 'activityType';
  final String columnRepetitive = 'repetitive';

  final String tableRecord = 'record';
  final String columnRecordId = '_id';
// final String columnParcelName = 'parcelName';
// final String columnActivityType = 'activityType';
  final String columnDate = 'date';
// final String columnIncome = 'income';
  final String columnQuantity = 'quantity';
}
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/parcel.dart';
import '../models/crop.dart';
import '../models/activity.dart';
import '../models/tool.dart';
import '../models/record.dart';


class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyCropDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 2;

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
    // Open the database
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database and all tables
  Future _onCreate(Database db, int version) async {
    debugPrint('Entered _onCreate [dbHelper]');
    await db.execute('''
              CREATE TABLE $tableParcel (
                $columnParcelId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnParcelName TEXT NOT NULL,
                $columnM2 REAL NOT NULL,
                $columnCrop TEXT NOT NULL,
                $columnStartTime TEXT NOT NULL,
                $columnIncome REAL,
                $columnTotalQuantity REAL,
                $columnCurrentQuantity REAL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableTool (
                $columnToolId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnToolName TEXT NOT NULL,
                $columnCropName TEXT NOT NULL,
                $columnActivityType TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableCrop (
                $columnCropId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnCropName TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableActivity (
                $columnActivityId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnActivityType TEXT NOT NULL,
                $columnCropName TEXT NOT NULL,
                $columnStartDay INTEGER NOT NULL,
                $columnRepeatTimes INTEGER NOT NULL,
                $columnTips TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableActivityType (
                $columnActivityTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnActivityType TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableRecord (
                $columnRecordId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnParcelName TEXT NOT NULL,
                $columnActivityType TEXT NOT NULL,
                $columnDate TEXT NOT NULL,
                $columnIncome REAL,
                $columnQuantity REAL
              )
              ''');

    // _initCrops();
    debugPrint('Starteded _initCrops [dbHelper]');
    int id;

    Map<String, dynamic> cropRow1 = {
      columnCropName : 'Kukuruz'
    };
    id = await db.insert(tableCrop, cropRow1);
    debugPrint('Inserted crop: $cropRow1 with id: $id [_initCrops]');

    Map<String, dynamic> cropRow2 = {
      columnCropName : 'Pšenica'
    };
    id = await db.insert(tableCrop, cropRow2);
    debugPrint('Inserted crop: $cropRow2 with id: $id [_initCrops]');

    Map<String, dynamic> cropRow3 = {
      columnCropName : 'Rajčica'
    };
    id = await db.insert(tableCrop, cropRow3);
    debugPrint('Inserted crop: $cropRow3 with id: $id [_initCrops]');

    Map<String, dynamic> cropRow4 = {
      columnCropName : 'Mrkva'
    };
    id = await db.insert(tableCrop, cropRow4);
    debugPrint('Inserted crop: $cropRow4 with id: $id [_initCrops]');

    // _initTools();

    // _initActivityTypes();
    debugPrint('Started _initActivityTypes [dbHelper]');

    Map<String, dynamic> actTypRow1 = {
      columnActivityType : 'Obrada tla'
    };
    id = await db.insert(tableActivityType, actTypRow1);
    debugPrint('Inserted activity type: $actTypRow1 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow2 = {
      columnActivityType : 'Gnojenje'
    };
    id = await db.insert(tableActivityType, actTypRow2);
    debugPrint('Inserted activity type: $actTypRow2 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow3 = {
      columnActivityType : 'Sjetva'
    };
    id = await db.insert(tableActivityType, actTypRow3);
    debugPrint('Inserted activity type: $actTypRow3 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow4 = {
      columnActivityType : 'Sadnja'
    };
    id = await db.insert(tableActivityType, actTypRow4);
    debugPrint('Inserted activity type: $actTypRow4 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow5 = {
      columnActivityType : 'Prihranjivanje'
    };
    id = await db.insert(tableActivityType, actTypRow5);
    debugPrint('Inserted activity type: $actTypRow5 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow6 = {
      columnActivityType : 'Njega'
    };
    id = await db.insert(tableActivityType, actTypRow6);
    debugPrint('Inserted activity type: $actTypRow6 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow7 = {
      columnActivityType : 'Berba'
    };
    id = await db.insert(tableActivityType, actTypRow7);
    debugPrint('Inserted activity type: $actTypRow7 with id: $id [_initActivityTypes]');

    Map<String, dynamic> actTypRow8 = {
      columnActivityType : 'Prodaja'
    };
    id = await db.insert(tableActivityType, actTypRow8);
    debugPrint('Inserted activity type: $actTypRow8 with id: $id [_initActivityTypes]');

    // _initActivities();

  }

  // Database helper methods:
  // Parcels

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertParcel(Map<String, dynamic> row) async {
    debugPrint('Entered insertParcel [dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableParcel, row);
    return id;
  }

  // Return all parcels of the user, immediate conversion from map to parcel objects
  Future<List<Parcel>> getAllParcels() async {
    debugPrint('Entered getAllParcels [dbHelper]');
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(tableParcel);
    int count = mapList.length;
    debugPrint('Maps list: [dbHelper] [getAllParcels]\n' + mapList.toString()
        + '\nCount: $count');
    List<Parcel> parcelList = new List();
    for (int i = 0; i < count; i++) {
      Parcel tmp = Parcel.fromMap(mapList[i]);
      parcelList.add(tmp);
    }
    debugPrint('Return parcel list: [dbHelper]\n' + parcelList.toString());
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

  // Crops

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertCrop(Map<String, dynamic> row) async {
    debugPrint('Entered insertCrop [dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableCrop, row);
    return id;
  }

  // Return all crops, immediate conversion from map to crop objects
  Future<List<Crop>> getAllCrops() async {
    debugPrint('Entered getAllCrops [dbHelper]');
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(tableCrop);
    int count = mapList.length;
    debugPrint('Maps list: [dbHelper] [getAllCrops]\n' + mapList.toString()
        + '\nCount: $count');
    List<Crop> cropList = new List();
    for (int i = 0; i < count; i++) {
      Crop tmp = Crop.fromMap(mapList[i]);
      cropList.add(tmp);
    }
    debugPrint('Return crop list: [dbHelper]\n' + cropList.toString());
    return cropList;
  }

  // ActivityTypes

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertActivityType(Map<String, dynamic> row) async {
    debugPrint('Entered insertActivityType [dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableActivityType, row);
    return id;
  }

  // Activities
  // TODO: insert, init, get(multiple)

  // Tools
  // TODO: insert, init, get(multiple)

  // Records
  // TODO: insert, update, delete, getAll

// All repeated column names are commented
  final String tableParcel = 'parcel';
  final String columnParcelId = '_id';
  final String columnParcelName = 'parcelName';
  final String columnM2 = 'm2';
  final String columnCrop = 'crop';
  final String columnStartTime = 'startTime';
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
  final String columnStartDay = 'startDay';
  final String columnRepeatTimes = 'repeatTimes';
  final String columnRepeatDays = 'repeatDays';
  final String columnTips = 'tips';

  final String tableActivityType = 'activityType';
  final String columnActivityTypeId = '_id';
// final String columnActivityType = 'activityType';

  final String tableRecord = 'record';
  final String columnRecordId = '_id';
// final String columnParcelName = 'parcelName';
// final String columnActivityType = 'activityType';
  final String columnDate = 'date';
// final String columnIncome = 'income';
  final String columnQuantity = 'quantity';
}
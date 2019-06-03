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
                $columnRepeatDays INTEGER NOT NULL,
                $columnDescription TEXT NOT NULL
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
                $columnExpense REAL,
                $columnQuantity REAL
              )
              ''');

    // TODO: _initCrops();
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

    // TODO: _initActivityTypes();
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

    // TODO: complete init
    // _initActivities();
    debugPrint('Started _initActivities [dbHelper]');

    Map<String, dynamic> actRow1 = {
      columnActivityType : 'Obrada tla',
      columnCropName : 'Kukuruz',
      columnStartDay : 0,
      columnRepeatTimes : 1,
      columnRepeatDays : 0,
      columnDescription : 'Treba delat i to samo jako nema pauze dok nije gotovo'
    };
    id = await db.insert(tableActivity, actRow1);
    debugPrint('Inserted activity: $actRow1 with id: $id [_initActivity]');

    // TODO: complete init
    // _initTools();

    Map<String, dynamic> toolRow1 = {
      columnToolName : 'Lopata',
      columnCropName : 'Kukuruz',
      columnActivityType : 'Obrada tla'
    };
    id = await db.insert(tableTool, toolRow1);
    debugPrint('Inserted tool: $toolRow1 with id: $id [_initTools]');
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

  Future<int> insertActivity(Map<String, dynamic> row) async {
    debugPrint('Entered insertActivity [dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableActivity, row);
    return id;
  }

  Future<List<Activity>> getCropActivities(String crop) async {
    debugPrint('Entered getCropActivities [dbHelper]');
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(tableActivity, where: '$columnCropName = ?', whereArgs: [crop]);
    int count = mapList.length;
    debugPrint('Maps list: [dbHelper] [getCropActivities]\n' + mapList.toString()
        + '\nCount: $count');
    List<Activity> activityList = new List();
    for (int i = 0; i < count; i++) {
      Activity tmp = Activity.fromMap(mapList[i]);
      activityList.add(tmp);
    }
    debugPrint('Return activity list: [dbHelper]\n' + activityList.toString());
    return activityList;
  }

  // Tools

  Future<int> insertTool(Map<String, dynamic> row) async {
    debugPrint('Entered insertTool[dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableTool, row);
    return id;
  }

  Future<List<Tool>> getActivityTools(Activity activity) async {
    debugPrint('Entered getActivityTools [dbHelper]');
    Database db = await instance.database;
    String crop = activity.cropName;
    String actType = activity.activityType;
    String sql = 'SELECT * FROM $tableTool WHERE $columnCropName = ? AND $columnActivityType = ?';
    List<Map<String, dynamic>> mapList = await db.rawQuery(sql, [crop, actType]);
    int count = mapList.length;
    debugPrint('Maps list: [dbHelper] [getActivityTools]\n' + mapList.toString()
        + '\nCount: $count');
    List<Tool> toolList = new List();
    for (int i = 0; i < count; i++) {
      Tool tmp = Tool.fromMap(mapList[i]);
      toolList.add(tmp);
    }
    debugPrint('Return tool list: [dbHelper]\n' + toolList.toString());
    return toolList;
  }

  // Records

  Future<int> insertRecord(Map<String, dynamic> row) async {
    debugPrint('Entered insertRecord[dbHelper]\nRow to enter: ' + row.toString());
    Database db = await instance.database;
    int id = await db.insert(tableRecord, row);
    return id;
  }

  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnRecordId];
    return await db.update(tableRecord, row, where: '$columnRecordId = ?', whereArgs: [id]);
  }

  Future<int> deleteRecord(int id) async {
    Database db = await instance.database;
    return await db.delete(tableRecord, where: '$columnRecordId = ?', whereArgs: [id]);
  }

  Future<List<Record>> getParcelRecords(String parcel) async {
    debugPrint('Entered getParcelRecords [dbHelper]');
    Database db = await instance.database;
    List<Map<String, dynamic>> mapList = await db.query(tableRecord, where: '$columnParcelName = ?', whereArgs: [parcel]);
    int count = mapList.length;
    debugPrint('Maps list: [dbHelper] [getParcelRecords]\n' + mapList.toString()
        + '\nCount: $count');
    List<Record> recordList = new List();
    for (int i = 0; i < count; i++) {
      Record tmp = Record.fromMap(mapList[i]);
      recordList.add(tmp);
    }
    debugPrint('Return record list: [dbHelper]\n' + recordList.toString());
    return recordList;
  }

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
  final String columnDescription = 'description';

  final String tableActivityType = 'activityType';
  final String columnActivityTypeId = '_id';
// final String columnActivityType = 'activityType';

  final String tableRecord = 'record';
  final String columnRecordId = '_id';
// final String columnParcelName = 'parcelName';
// final String columnActivityType = 'activityType';
  final String columnDate = 'date';
// final String columnIncome = 'income';
  final String columnExpense = 'expense';
  final String columnQuantity = 'quantity';
}
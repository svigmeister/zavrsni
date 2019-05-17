import 'dart:io';
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

  Future<int> insertParcel(Parcel parcel) async {
    Database db = await database;
    int id = await db.insert(tableParcel, parcel.toMap());
    return id;
  }

  Future<List<Parcel>> getAllParcels() async {
    Database db = await database;
    List<Map<String, dynamic>> mapList = await db.query('SELECT * FROM $tableParcel');
    int count = mapList.length;
    List<Parcel> parcelList = List<Parcel>(count);
    for (int i = 0; i < count; i++) {
      parcelList.add(Parcel.fromMap(mapList[i]));
    }
    return parcelList;
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
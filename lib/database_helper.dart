import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'device.dart';

class DatabaseHelper {

  static final _databaseName = "DevicesDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'device_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnIconLocation = 'icon_location';
  static final columnDeviceStatus = 'device_status';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        // When the database is first created, create a table to store devices.
        onCreate: _onCreate,
        version: _databaseVersion);
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnIconLocation TEXT NOT NULL,
            $columnDeviceStatus TEXT NOT NULL

          )
          ''');
  }

  /**Insert a new device into the local database**/
  Future<void> insert(Device device) async {
    // Get a reference to the database.
    Database db = await instance.database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      table,
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /**Retrieves all the devices on startup**/
  Future<List<Device>> retreiveDevices() async {
    // Get a reference to the database.
    Database db = await database;

    // Query the table for all The Devices.
    final List<Map<String, dynamic>> maps = await db.query(table);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Device(
        id:maps[i]['_id'],
        name: maps[i]['name'],
        iconLocation: maps[i]['icon_location'],
        deviceStatus: (maps[i]['device_status'])
      );
    });
  }

  /**Update the device in the local database**/
  Future<void> updateDevice(Device device) async {
    // Get a reference to the database.
    Database db = await instance.database;

    // Update the given Device.
    await db.update(
      table,
      device.toMap(),
      // Ensure that the Device has a matching id.
      where: "$columnId = ?",
      // Pass the Device's id as a whereArg to prevent SQL injection.
      whereArgs: [device.id],
    );
  }

  /**Delete the device from local database**/
  Future<void> deleteDevice(int id) async {
    // Get a reference to the database.
    Database db = await instance.database;

    // Remove the Dog from the Database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific dog.
      where: "$columnId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

}
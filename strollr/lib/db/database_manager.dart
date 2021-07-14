import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/model/walk.dart';
import 'package:strollr/logger.dart';
import 'package:strollr/db/database_interface_helper.dart';
import 'package:strollr/utils/shared_prefs.dart';

import '../globals.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();

  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('strollr.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // gets the default path
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .i('Creating database... ');
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final dataType = 'BLOB';
    final floatType =
        'REAL'; // floating point value, stored as an 8-byte IEEE floating point number

    // activate foreign keys
    await db.execute('''
      PRAGMA foreign_keys = ON;
    ''');

    // create table for the categories each picture can have
    await db.execute('''
      CREATE TABLE $tablePictureCategories (
        ${PictureCategoriesField.id} $idType,
        ${PictureCategoriesField.description} TEXT DEFAULT "undefined" NOT NULL
      )
    ''');
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .i('Table $tablePictureCategories created.');

    // create table for the walks
    // for DateTime -> TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS"), because there is to timestamp in sqlite
    // route as String -> the resulting xml file from the gpx package
    await db.execute('''
      CREATE TABLE $tableWalks (
        ${WalkField.id} $idType,
        ${WalkField.name} $textType,
        ${WalkField.duration} $textType,  
        ${WalkField.distance} $floatType,
        ${WalkField.route} $textType,     
        ${WalkField.startedAt} $textType,
        ${WalkField.endedAt} $textType
      )
    ''');
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .i('Table $tableWalks created.');
    // create table for the pictures
    // image data as Uint8List -> BLOB in DB
    // color, size and description are user input -> questions about each taken picture
    await db.execute('''
      CREATE TABLE $tablePictures (
        ${PictureField.id} $idType,
        ${PictureField.data} $dataType, 
        ${PictureField.filename} $textType, 
        ${PictureField.createdAt} $textType,
        ${PictureField.generic1} $textType, 
        ${PictureField.generic2} $textType, 
        ${PictureField.description} $textType, 
        ${PictureField.location} $textType,
        ${PictureField.category} $integerType,
        ${PictureField.walk_id} $integerType,
        FOREIGN KEY (${PictureField.category}) REFERENCES $tablePictureCategories(${PictureCategoriesField.id}) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (${PictureField.walk_id}) REFERENCES $tableWalks(${WalkField.id}) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .i('Table $tablePictures created.');

    // fill the categories as they are known from the beginning
    _insertCategories(db);
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .i('Table $tablePictureCategories filled.');
  }

  void _insertCategories(Database db) {
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('inserting categories in the database');
    Categories.values.forEach((v) async {
      int id = await db.rawInsert(
          "INSERT INTO $tablePictureCategories (description) "
          "VALUES (?)",
          [v.toShortString()]); // id is automatically created
    });
  }

  Future<int> getCategoryIdFromCategory(Categories category) async {
    var cat = category.toShortString();
    final db = await DatabaseManager.instance.database;
    final List<Map> map = await db
        .rawQuery('SELECT ID FROM categories WHERE description = ?', [cat]);

    if (map.isNotEmpty) {
      int id = -1;
      map.forEach((element) {
        id = element[PictureCategoriesField.id] as int;
      });
      return id;
    } else {
      throw Exception('Category ${category.toShortString()} not found!');
    }
  }

  /// insert a picture into the database
  Future<Picture> insertPicture(Picture picture) async {
    final db = await instance.database;
    final id = await db.insert(tablePictures, picture.toJson());
    ApplicationLogger.getLogger('DatabaseManager', colors: true).d(
        'insertPicture | Picture inserted into $tablePictures with ID = $id');
    return picture.copy(id: id);
  }

  /// insert a walk into the database
  Future<Walk> insertWalk(Walk walk) async {
    final db = await instance.database;
    final id = await db.insert(tableWalks, walk.toJson());
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('insertWalk | Walk inserted into $tableWalks with ID = $id');
    return walk.copy(id: id);
  }

  /// read a picture from the database with id [id]
  Future<Picture> readPictureFromPictureId(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tablePictures,
      columns: PictureField.values,
      where: '${PictureField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Picture.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found!');
    }
  }

  /// read all pictures from the database ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPictures(
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    if (!PictureField.values.contains(orderedByColumn))
      throw Exception(
          'readALlPictures | Invalid parameter: there is no column $orderedByColumn in the $tablePictures table');
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tablePictures, orderBy: orderBy);
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read all pictures from the database in category [category] ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPicturesFromCategory(int category,
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    if (!PictureField.values.contains(orderedByColumn))
      throw Exception(
          'readALlPicturesFromCategory | Invalid parameter: there is no column $orderedByColumn in the $tablePictures table');
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(
      tablePictures,
      where: '${PictureField.category} = ?',
      whereArgs: [category],
      orderBy: orderBy,
    );
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read all pictures from the database from walk [walkId] ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPicturesFromWalk(int walkId,
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    if (!PictureField.values.contains(orderedByColumn))
      throw Exception(
          'readALlPicturesFromWalk | Invalid parameter: there is no column $orderedByColumn in the $tablePictures table');
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(
      tablePictures,
      where: '${PictureField.walk_id} = ?',
      whereArgs: [walkId],
      orderBy: orderBy,
    );
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read all pictures from the database from walk [walkId] in category [walkId] ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPicturesFromWalkInCategory(
      int walkId, int category,
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    if (!PictureField.values.contains(orderedByColumn))
      throw Exception(
          'readALlPicturesFromWalkInCategory | Invalid parameter: there is no column $orderedByColumn in the $tablePictures table');
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(
      tablePictures,
      where: '${PictureField.walk_id} = ? AND ${PictureField.category} = ?',
      whereArgs: [walkId, category],
      orderBy: orderBy,
    );
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read a walk from the database with id [id]
  Future<Walk> readWalkFromId(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWalks,
      columns: WalkField.values,
      where: '${WalkField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Walk.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found!');
    }
  }

  /// read all walks from the database ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by ending date and time in descending way
  Future<List<Walk>> readALlWalks(
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = WalkField.endedAt;
    if (!WalkField.values.contains(orderedByColumn))
      throw Exception(
          'readALlWalks | Invalid parameter: there is no column $orderedByColumn in the $tableWalks table');
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tableWalks, orderBy: orderBy);
    return result.map((json) => Walk.fromJson(json)).toList();
  }

  Future<List<YearlyDistance>> readAllWalkDistancesYearly() async {
    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%Y\', ${WalkField.endedAt}) AS ${YearlyDistancesField.year}',
          'SUM(${WalkField.distance}) AS ${YearlyDistancesField.distKm} '
        ],
        orderBy: '${WalkField.endedAt} DESC',
        groupBy: '${YearlyDistancesField.year}');
    return result.map((json) => YearlyDistance.fromJson(json)).toList();
  }

  Future<List<MonthlyDistance>> readAllWalkDistancesMonthly(String year) async {
    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%m\', ${WalkField.endedAt}) AS ${MonthlyDistancesField.monthInYear}',
          'SUM(${WalkField.distance}) AS ${MonthlyDistancesField.distKm} '
        ],
        where: 'strftime(\'%Y\', ${WalkField.endedAt}) = ?',
        orderBy: '${WalkField.endedAt}',
        groupBy: '${MonthlyDistancesField.monthInYear}',
        whereArgs: [year]);
    return result.map((json) => MonthlyDistance.fromJson(json)).toList();
  }

  Future<List<DailyDistance>> readAllWalkDistancesInAMonth(
      String month, String year) async {
    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%d\', ${WalkField.endedAt}) AS ${DailyDistancesField.day}',
          'strftime(\'%m\', ${WalkField.endedAt}) AS ${DailyDistancesField.month}',
          'strftime(\'%Y\', ${WalkField.endedAt}) AS ${DailyDistancesField.year}',
          'SUM(${WalkField.distance}) AS ${DailyDistancesField.distKm}'
        ],
        where:
            'strftime(\'%m\', ${WalkField.endedAt}) = ? AND strftime(\'%Y\', ${WalkField.endedAt}) = ?',
        orderBy: '${WalkField.endedAt} ASC',
        groupBy: '${DailyDistancesField.day}',
        whereArgs: [month, year]);

    return result.map((json) => DailyDistance.fromJson(json)).toList();
    // where: 'strftime(\'%m\', ${WalkField.endedAt}) = ? AND strftime(\'%Y\', ${WalkField.endedAt}) = ?',
    // groupBy: '${DailyDistancesField.day}');
    // orderBy: WalkField.endedAt,
    /*
    where: 'strftime(\'%m\', ${WalkField.endedAt}) = ? AND strftime(\'%Y\', ${WalkField.endedAt}) = ?',
        groupBy: '${DailyDistancesField.day}',
        whereArgs: [month, year]
     */
  }

  Future<List<YearlyDuration>> readAllWalkDurationsYearly() async {
    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%Y\', ${WalkField.endedAt}) AS ${YearlyDurationField.year}',
          '${WalkField.duration} AS ${YearlyDurationField.duration}',
        ],
        orderBy: '${WalkField.endedAt} ASC');
    return result.map((json) => YearlyDuration.fromJson(json)).toList();
  }

  Future<List<MonthlyDuration>> readAllWalkDurationsMonthly(String year) async {
    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%m\', ${WalkField.endedAt}) AS ${MonthlyDurationField.month}',
          '${WalkField.duration} AS ${MonthlyDurationField.duration}',
        ],
        where: 'strftime(\'%Y\', ${WalkField.endedAt}) = ?',
        orderBy: '${WalkField.endedAt} ASC',
        whereArgs: [year]);
    return result.map((json) => MonthlyDuration.fromJson(json)).toList();
  }


  Future<List<DailyDuration>> readAllWalkDurationsInAMonth(
      String month, String year) async {

    final db = await instance.database;
    final result = await db.query(tableWalks,
        columns: [
          'strftime(\'%d\', ${WalkField.endedAt}) AS ${DailyDurationField.day}',
          'strftime(\'%m\', ${WalkField.endedAt}) AS ${DailyDurationField.month}',
          'strftime(\'%Y\', ${WalkField.endedAt}) AS ${DailyDurationField.year}',
          '${WalkField.duration} AS ${DailyDurationField.duration}'
        ],

        where:
            'strftime(\'%m\', ${WalkField.endedAt}) = ? AND strftime(\'%Y\', ${WalkField.endedAt}) = ?',
        orderBy: '${WalkField.endedAt} ASC',
        whereArgs: [month, year]);


    return result.map((json) => DailyDuration.fromJson(json)).toList();
  }

  /// update a picture in the database by passing the updated version [picture]. Returns the number of changes made
  Future<int> updatePicture(Picture picture) async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('updatePicture | Updating picture with ID = ${picture.id}');
    return await db.update(
      tablePictures,
      picture.toJson(),
      where: '${PictureField.id} = ?',
      whereArgs: [picture.id],
    );
  }

  /// update a walk in the database by passing the updated version [walk]. Returns the number of changes made
  Future<int> updateWalk(Walk walk) async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('updateWalk | Updating walk with ID = ${walk.id}');
    return await db.update(
      tableWalks,
      walk.toJson(),
      where: '${WalkField.id} = ?',
      whereArgs: [walk.id],
    );
  }

  /// delete a picture in the database by passing its id [id]
  Future<int> deletePicture(int id) async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('deletePicture | Deleting picture with ID = $id');
    return await db.delete(
      tablePictures,
      where: '${PictureField.id} = ?',
      whereArgs: [id],
    );
  }

  /// delete a walk in the database by passing its id [id]
  Future<int> deleteWalk(int id) async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('deleteWalk | Deleting walk with ID = $id');
    return await db.delete(
      tableWalks,
      where: '${WalkField.id} = ?',
      whereArgs: [id],
    );
  }

  /// clear the database, should be used for the database testing
  Future<void> deleteDb() async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true).d(
        'deleteDb | Deleting all entries in table $tableWalks and table $tablePictures');
    await db.delete(
      tableWalks,
    );
    await db.delete(
      tablePictures,
    );
  }

  Future close() async {
    final db = await instance.database;
    ApplicationLogger.getLogger('DatabaseManager', colors: true)
        .d('close | Closing database');
    db.close();
  }
}

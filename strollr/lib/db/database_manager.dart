import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/model/walk.dart';

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
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    // final integerType = 'INTEGER NOT NULL';
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
        ${PictureCategoriesField.description} $textType DEFAULT 'undefiened',
      )
    ''');

    // create table for the walks
    await db.execute('''
      CREATE TABLE $tableWalks (
        ${WalkField.id} $idType,
        ${WalkField.name} $textType,
        // TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS"), because there is to timestamp in sqlite
        // when insertring into the table .toISO8601String() should be used
        ${WalkField.duration} $textType,  
        ${WalkField.distance} $floatType,
        ${WalkField.route} $textType,     // the resulting xml file from the gpx package 
        ${WalkField.startedAt} $textType,
        ${WalkField.endedAt} $textType
      )
    ''');

    // create table for the pictures
    await db.execute('''
      CREATE TABLE $tablePictures (
        ${PictureField.id} $idType,
        ${PictureField.data} $dataType,
        // TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS"), because there is to timestamp in sqlite
        // when inserting DateTime into the table .toIso8601String() should be used -> see toJson() method in picture.dart for example
        ${PictureField.createdAt} $textType,
        ${PictureField.color} $textType, // user input, one of the questions
        ${PictureField.size} $textType, // user input, one of the questions
        ${PictureField.description} $textType, // user input, one of the questions
        ${PictureField.location} $textType, // the resulting xml file from the gpx package
        FOREIGN KEY (${PictureCategoriesField.id}) REFERENCES $tablePictureCategories(${PictureCategoriesField.id}) // get the id of the category -> from there the description 
        FOREIGN KEY (${PictureField.walk_id}) REFERENCES $tableWalks(${WalkField.id}) // match the picture to the walk
      )
    ''');

    // fill the categories as they are known from the beginning
    _insertCategories(db);
  }

  void _insertCategories(Database db) {
    Categories.values.forEach((v) => () async {
          await db
              .execute("INSERT INTO $tablePictureCategories ('description') "
                  "VALUES ($v)"); // id is automatically created
        });
  }

  /// insert a picture into the database
  Future<Picture> insertPicture(Picture picture) async {
    final db = await instance.database;
    final id = await db.insert(tablePictures, picture.toJson());
    return picture.copy(id: id);
  }

  /// insert a walk into the database
  Future<Walk> insertWalk(Walk walk) async {
    final db = await instance.database;
    final id = await db.insert(tablePictures, walk.toJson());
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
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tablePictures, where: '${PictureField.category} = ?', whereArgs: [category], orderBy: orderBy, );
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read all pictures from the database from walk [walkId] ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPicturesFromWalk(int walkId,
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tablePictures, where: '${PictureField.walk_id} = ?', whereArgs: [walkId], orderBy: orderBy, );
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  /// read all pictures from the database from walk [walkId] in category [walkId] ordered by [orderedByColumn] asc if [ascending] is true, desc if false.
  /// Default is ordered by creation time in descending way
  Future<List<Picture>> readALlPicturesFromWalkInCategory(int walkId, int category,
      {String orderedByColumn = '', bool ascending = false}) async {
    final db = await instance.database;
    if (orderedByColumn.isEmpty) orderedByColumn = PictureField.createdAt;
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tablePictures, where: '${PictureField.walk_id} = ? AND ${PictureField.category} = ?', whereArgs: [walkId, category], orderBy: orderBy, );
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
    final String orderBy = orderedByColumn + (ascending ? ' ASC' : ' DESC');
    final result = await db.query(tableWalks, orderBy: orderBy);
    return result.map((json) => Walk.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

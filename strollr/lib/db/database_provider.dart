import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/model/walk.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();

  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final dataType = 'BLOB';
    final floatType =
        'REAL'; // floating point value, stored as an 8-byte IEEE floating point number

    await db.execute('''
      PRAGMA foreign_keys = ON;
    ''');
    await db.execute('''
      CREATE TABLE $tablePictureCategories (
        ${PictureCategoriesField.id} $idType,
        ${PictureCategoriesField.description} $textType DEFAULT 'undefiened',
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableWalks (
        ${WalkField.id} $idType,
        ${WalkField.name} $textType,
        ${WalkField.duration} $textType,  // TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS"), because there is to timestamp in sqlite
        ${WalkField.distance} $floatType,
        ${WalkField.route} $textType,     // the resulting xml file from the gpx package 
        ${WalkField.started_at} $textType,
        ${WalkField.ended_at} $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePictures (
        ${PictureField.id} $idType,
        ${PictureField.data} $dataType,
        ${PictureField.created_at} $textType,
        ${PictureField.color} $textType,
        ${PictureField.size} $textType, // user input, one of the questions
        ${PictureField.description} $textType,
        ${PictureField.location} $textType, // probably as xml file from the gpx package
        FOREIGN KEY (${PictureCategoriesField.id}) REFERENCES $tablePictureCategories(${PictureCategoriesField.id}) // get the id of the category -> from there the description 
        FOREIGN KEY (${PictureField.walk_id}) REFERENCES $tableWalks(${WalkField.id})
      )
    ''');

    insertCategories(db);
  }

  void insertCategories(Database db) {
    Categories.values.forEach((v) => () async {
          await db
              .execute("INSERT INTO $tablePictureCategories ('description') "
                  "VALUES ($v)");
        });
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

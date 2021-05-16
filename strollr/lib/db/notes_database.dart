import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strollr/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

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

  Future _createDB(Database db, int versio) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes (
  ${NoteFields.id} $idType,
  ${NoteFields.data} $textType,
  ${NoteFields.created_at} $textType,
  ${NoteFields.color} $textType,
  ${NoteFields.size} $integerType,
  ${NoteFields.description} $textType,
  ${NoteFields.location} $textType,
  ${NoteFields.categories} $textType,
  ${NoteFields.categories} $integerType,
)
    
    
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

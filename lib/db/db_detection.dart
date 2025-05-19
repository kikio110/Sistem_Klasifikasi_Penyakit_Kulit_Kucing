import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DetectionDatabaseHelper {
  static final DetectionDatabaseHelper instance = DetectionDatabaseHelper._init();

  static Database? _database;

  DetectionDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('detection.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE detections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT,
        label TEXT,
        confidence REAL,
        description TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertDetection(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert('detections', data);
  }

  Future<List<Map<String, dynamic>>> getDetections() async {
    final db = await instance.database;
    return await db.query('detections', orderBy: 'timestamp DESC');
  }
}
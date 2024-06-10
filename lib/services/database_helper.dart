import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      product_id TEXT NOT NULL
    )
    ''');
  }

  Future<void> createFavorite(String uid, String productId) async {
    final db = await instance.database;

    final favorite = {'uid': uid, 'product_id': productId};
    await db.insert('favorites', favorite, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> readFavorites(String uid) async {
    final db = await instance.database;

    final result = await db.query('favorites', where: 'uid = ?', whereArgs: [uid]);
    return result;
  }

  Future<void> deleteFavorite(String uid, String productId) async {
    final db = await instance.database;

    await db.delete('favorites', where: 'uid = ? AND product_id = ?', whereArgs: [uid, productId]);
  }
}

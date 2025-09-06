import 'dart:convert'; 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart'; 
import '../models/history_item.dart';
import '../models/art_piece.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'benin_culture_hub.db'); 
    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Favorites (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,  -- 'event', 'history', 'art'
        data TEXT NOT NULL,  -- JSON sérialisé de l'objet
        timestamp INTEGER NOT NULL  -- Date d'ajout en epoch
      )
    ''');
  }

  Future<void> insertFavorite(dynamic item, String type) async {
    final db = await database;
    Map<String, dynamic> map = {
      'id': item.id,
      'type': type,
      'data': jsonEncode(item.toMap()), 
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await db.insert('Favorites', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<dynamic>> getFavoritesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Favorites',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC', 
    );
    return maps.map((map) {
      final data = jsonDecode(map['data']);
      if (type == 'event') return Event.fromMap(data);
      if (type == 'history') return HistoryItem.fromMap(data);
      if (type == 'art') return ArtPiece.fromMap(data);
      return null;
    }).whereType<dynamic>().toList();
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete('Favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('Favorites');
  }
}
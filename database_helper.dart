import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class DatabaseHelper {
  static final _databaseName = "Favorites.db";
  static final _databaseVersion = 1;

  static final table = 'favorites';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnImageUrl = 'imageUrl';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Recipe recipe) async {
    final db = await database;
    return await db.insert(table, {
      columnId: recipe.id,
      columnTitle: recipe.title,
      columnImageUrl: recipe.imageUrl,
    });
  }

  Future<List<Recipe>> queryAllRows() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        imageUrl: maps[i][columnImageUrl],
      );
    });
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

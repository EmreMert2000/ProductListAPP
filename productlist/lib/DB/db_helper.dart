import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/Product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'financial_support.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }
}

Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
        CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          companyName TEXT NOT NULL,
          debt REAL NOT NULL,
          credit REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');
  }
}

Future<int> insertProduct(Product product) async {
  final db = await instance.database;
  return await db.insert('products', product.toMap());
}

Future<List<Product>> fetchProducts() async {
  final db = await instance.database;
  final maps = await db.query('products');
  return maps.map((map) => Product.fromMap(map)).toList();
}

Future<int> deleteProduct(int id) async {
  final db = await instance.database;
  return await db.delete('products', where: 'id = ?', whereArgs: [id]);
}

Future<void> updateProduct(Product updatedProduct) async {
  final db = await database;
  await db.update(
    'products',
    updatedProduct.toMap(),
    where: 'id = ?',
    whereArgs: [updatedProduct.id],
  );
}

Future<void> clearProducts() async {
  final db = await instance.database;
  await db.delete('products');
}

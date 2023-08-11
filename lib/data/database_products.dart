import 'package:jacksiltd/models/categories.dart';
import 'package:jacksiltd/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('products.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE Products (
      id $idType,
      productName $textType,
      storeName $textType,
      price $realType,
      rating $realType,
      category $integerType 
    )
  ''');

    await db.execute('''
    CREATE TABLE Images (
      id $idType,
      productId INTEGER NOT NULL,
      imagePath $textType,
      FOREIGN KEY (productId) REFERENCES Products (id) ON DELETE CASCADE
    )
  ''');
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('Products', product.toMap());
  }

  Future<int> insertImagePath(int productId, String imagePath) async {
    final db = await instance.database;
    return await db
        .insert('Images', {'productId': productId, 'imagePath': imagePath});
  }

  Future<List<Product>> fetchProducts() async {
    final db = await instance.database;

    final products = await db.query('Products');
    final images = await db.query('Images');
    return products.map((product) {
      final List<Map<String, dynamic>> imageMaps =
          images.cast<Map<String, dynamic>>();
      final productImages = imageMaps
          .where((image) => image['productId'] == product['id'])
          .map((image) => File(image['imagePath'] as String))
          .toList();

      return Product(
        id: product['id'] as int,
        productName: product['productName'] as String,
        storeName: product['storeName'] as String,
        price: product['price'] as double,
        rating: product['rating'] as double,
        category: Categories.values[product['category'] as int],
        images: productImages,
      );
    }).toList();
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;

    await db.delete('Products');
    await db.delete('Images');
  }
}

import 'package:hrh_pos/data/models/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasources {
  ProductLocalDatasources._init();
  static final ProductLocalDatasources instance =
      ProductLocalDatasources._init();

  final String tableCaegory = 'categories';
  final String tableProduct = 'products';
  final String tableOrder = 'orders';
  final String tableOrderItem = 'order_items';

  static Database? _database;

  Future<void> _createDb(Database db, int version) async {
    // await db.execute(
    //   '''
    //       CREATE TABLE $tableCaegory (
    //         id INTEGER PRIMARY KEY,
    //         name TEXT NOT NULL,
    //         description TEXT,
    //         created_at TEXT,
    //         updated_at TEXT
    //       )
    //     ''',
    // );
    await db.execute(
      '''
  CREATE TABLE $tableProduct (
    id INTEGER PRIMARY KEY,
    id_category INTEGER,
    name_category TEXT,
    name_product TEXT NOT NULL,
    description TEXT,
    image TEXT,
    price TEXT,
    stock INTEGER,
    status INTEGER,
    created_at TEXT,
    updated_at TEXT
  )
  ''',
    );

    await db.execute(
      "CREATE TABLE $tableOrder("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "payment_amount INTEGER,"
      "sub_total INTEGER,"
      "tax INTEGER,"
      "discount INTEGER,"
      "service_charge INTEGER,"
      "total INTEGER,"
      "payment_method TEXT,"
      "total_item INTEGER,"
      "id_kasir INTEGER,"
      "nama_kasir TEXT,"
      "transaction_time TEXT,"
      "is_sync INTEGER DEFAULT 0)",
    );

    await db.execute(" CREATE TABLE $tableOrderItem("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "id_order INTEGER,"
        "id_product INTEGER,"
        "quantity INTEGER,"
        "price INTEGER )");
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('hrh_pos.db');
      return _database!;
    }
  }

  // Future<void> insertCategories(List<ProductCategory> category) async {
  //   final db = await instance.database;
  //   for (var categories in category) {
  //     await db.insert(tableCaegory, categories.toLocalMap(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //     print('insert category succes ${categories.name}');
  //   }
  // }

  // Future<void> insertCategory(ProductCategory category) async {
  //   final db = await instance.database;
  //   await db.insert(tableCaegory, category.toLocalMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   print('insert category succes ${category.name}');
  // }

  // Future<List<ProductCategory>> getCategories() async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(tableCaegory);
  //   return List.generate(maps.length, (i) {
  //     return ProductCategory.fromLocalMap(maps[i]);
  //   });
  // }

  Future<void> deleteAllCategory() async {
    final db = await instance.database;
    db.delete(tableCaegory);
  }

  Future<void> insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(tableProduct, product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insert list of pruduct
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(tableProduct, product.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('insert product succes ${product.nameProduct}');
      print(product.category!.name);
    }
  }

  Future<List<Product>> getAllProduct() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);
    return List.generate(maps.length, (i) {
      return Product.fromLocalMap(maps[i]);
    });
  }

  //delete all product
  Future<void> deleteAllProduct() async {
    final db = await instance.database;
    db.delete(tableProduct);
  }

  //get product
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);

    return List.generate(maps.length, (i) {
      return Product.fromLocalMap(maps[i]);
    });
  }

  // //save order
  // Future<void> saveOrder(OrderModel order) async {
  //   final db = await instance.database;
  //   int id = await db.insert(tableOrder, order.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   for (var item in order.orderItems) {
  //     await db.insert(tableOrderItem, item.toLocalMap(id),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   }
  // }

  // //get data order
  // Future<List<OrderModel>> getOrderByIsNotSync() async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(tableOrder, where: 'is_sync = ?', whereArgs: [0]);
  //   return List.generate(maps.length, (i) {
  //     return OrderModel.fromMap(maps[i]);
  //   });
  // }

  // Future<List<OrderModel>> getAllOrder(DateTime start, DateTime end) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     tableOrder,
  //     // where: 'transaction_time BETWEEN ? AND ?',
  //     // whereArgs: [
  //     //   DateFormat.yMd().format(start),
  //     //   DateFormat.yMd().format(end),
  //     // ],
  //   );
  //   return List.generate(maps.length, (i) {
  //     return OrderModel.fromMap(maps[i]);
  //   });
  // }

  // //get order item by order id
  // Future<List<ProductQuantity>> getOrderItemByOrderId(int id) async {
  //   final db = await instance.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(tableOrderItem, where: 'id_order = ?', whereArgs: [id]);
  //   return List.generate(maps.length, (i) {
  //     return ProductQuantity.fromLocalMap(maps[i]);
  //   });
  // }

  // //update order is sync
  // Future<void> updateOrderIsSync(int orderId) async {
  //   final db = await instance.database;
  //   await db.update(tableOrder, {'is_sync': 1},
  //       where: 'id = ?', whereArgs: [orderId]);
  // }
}

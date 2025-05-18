import 'package:hrh_pos/data/models/response/discount_response_model.dart';
import 'package:hrh_pos/data/models/response/payment_response_model.dart';
import 'package:hrh_pos/data/models/response/product_response_model.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';
import 'package:hrh_pos/presentation/home/models/order_model.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocal {
  DatabaseLocal._init();
  static final DatabaseLocal instance = DatabaseLocal._init();

  final String tableDiscount = 'diskons';
  final String tableOrder = 'orders';
  final String tableOrderItem = 'order_items';
  final String tablePayment = 'payment_methods';
  final String tableProduct = 'products';
  final String tableTax = 'pajaks';

  static Database? _database;

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableDiscount (
      id_diskon INTEGER PRIMARY KEY,
      nama_diskon TEXT,
      keterangan TEXT,
      status INTEGER,
      diskon_persen INTEGER,
      tanggal_mulai TEXT,
      tanggal_selesai TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
    print("Table diskons created successfully");

    await db.execute('''
    CREATE TABLE $tableOrder (
      id_order INTEGER PRIMARY KEY,
      id_user INTEGER,
      nama_kasir TEXT,
      id_payment INTEGER,
      id_pajak INTEGER,
      pajak_persen INTEGER,
      total_pajak INTEGER,
      id_diskon INTEGER,
      diskon_persen INTEGER,
      total_diskon INTEGER,
      sub_total INTEGER,
      total_item INTEGER,
      total INTEGER,
      payment_amount INTEGER,
      return_payment INTEGER,
      transaksi_time TEXT,
      layanan TEXT,
      is_sync INTEGER DEFAULT 0
    )
    ''');
    print("Table orders created successfully");

    await db.execute('''
    CREATE TABLE $tableOrderItem (
      id_order_item INTEGER PRIMARY KEY,
      id_order INTEGER,
      id_product INTEGER,
      quantity INTEGER,
      price INTEGER,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
    print("Table order_items created successfully");

    await db.execute('''
    CREATE TABLE $tablePayment (
      id_payment INTEGER PRIMARY KEY,
      nama_payment TEXT,
      image_payment TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
    print("Table payment_methods created successfully");

    await db.execute('''
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
    ''');
    print("Table products created successfully");

    await db.execute('''
    CREATE TABLE $tableTax (
      id_pajak INTEGER PRIMARY KEY,
      nama_pajak TEXT,
      pajak_persen INTEGER,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
    print("Table pajaks created successfully");
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE $tableTax (
            id_pajak INTEGER PRIMARY KEY,
            nama_pajak TEXT,
            pajak_persen INTEGER,
            created_at TEXT,
            updated_at TEXT
          )
          ''');
          print("Table pajaks created during migration");

          await db.execute('''
          CREATE TABLE $tableDiscount (
            id_diskon INTEGER PRIMARY KEY,
            nama_diskon TEXT,
            keterangan TEXT,
            status INTEGER,
            diskon_persen INTEGER,
            tanggal_mulai TEXT,
            tanggal_selesai TEXT,
            created_at TEXT,
            updated_at TEXT
          )
          ''');
          print("Table diskons created during migration");
        }
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hrh_pos.db');
    return _database!;
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/hrh_pos.db';
    await deleteDatabase(path);
    print("Database deleted successfully");
  }

  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);

    return List.generate(maps.length, (i) {
      return Product.fromLocalMap(maps[i]);
    });
  }

  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(tableProduct, product.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Insert product success: ${product.nameProduct}');
    }
  }

  Future<List<Tax>> getTaxs() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableTax);

    return List.generate(maps.length, (i) {
      return Tax.fromLocalMap(maps[i]);
    });
  }

  Future<List<Discount>> getDiscounts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableDiscount);

    return List.generate(maps.length, (i) {
      return Discount.fromLocalMap(maps[i]);
    });
  }

  Future<List<Payment>> getPayments() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tablePayment);

    return List.generate(maps.length, (i) {
      return Payment.fromLocalMap(maps[i]);
    });
  }

  Future<void> insertDiscount(List<Discount> discounts) async {
    final db = await instance.database;
    for (var discount in discounts) {
      await db.insert(tableDiscount, discount.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Insert discount success: ${discount.namaDiskon}');
    }
  }

  Future<void> insertTax(List<Tax> taxes) async {
    final db = await instance.database;
    for (var tax in taxes) {
      await db.insert(tableTax, tax.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Insert tax success: ${tax.namaPajak}');
    }
  }

  Future<void> insertPayment(List<Payment> payments) async {
    final db = await instance.database;
    for (var payment in payments) {
      await db.insert(tablePayment, payment.toLocalMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Insert payment success: ${payment.namaPayment}');
    }
  }

  Future<void> deleteAllProduct() async {
    final db = await instance.database;
    db.delete(tableProduct);
  }

  Future<void> deleteAllTax() async {
    final db = await instance.database;
    db.delete(tableTax);
  }

  Future<void> deleteAllPayment() async {
    final db = await instance.database;
    db.delete(tablePayment);
  }

  Future<void> deleteAllDiscount() async {
    final db = await instance.database;
    db.delete(tableDiscount);
  }

  Future<void> deleteAll(String tableName) async {
    final db = await instance.database;
    await db.delete(tableName);
    print("All data from $tableName deleted");
  }

  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await instance.database;
    return await db.query(tableName);
  }

  Future<void> saveOrder(OrderModel order) async {
    final db = await instance.database;
    int idOrder = await db.insert(
      tableOrder,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var item in order.orderItems) {
      await db.insert(
        tableOrderItem,
        item.toLocalMap(idOrder),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<OrderModel>> getOrderByIsNotSync() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableOrder,
      where: 'is_sync = ?',
      whereArgs: [0],
    );
    return List.generate(
      maps.length,
      (i) {
        return OrderModel.fromMap(
          maps[i],
        );
      },
    );
  }

  Future<List<OrderModel>> getTodayOrder() async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().split('T').first;
    final maps = await db.query(
      tableOrder,
      where: 'transaksi_time = ?',
      whereArgs: [today],
    );
    return List.generate(maps.length, (i) => OrderModel.fromMap(maps[i]));
  }

  Future<List<OrderModel>> getAllOrder(DateTime start, DateTime end) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableOrder);
    return List.generate(
      maps.length,
      (i) {
        return OrderModel.fromMap(
          maps[i],
        );
      },
    );
  }

  Future<List<ProductQuantity>> getItemOrder(
      DateTime start, DateTime end) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableOrder);
    return List.generate(
      maps.length,
      (i) {
        return ProductQuantity.fromMap(
          maps[i],
        );
      },
    );
  }

  Future<List<ProductQuantity>> getOrderItemByOrderId(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableOrderItem,
      where: 'id_order = ?',
      whereArgs: [id],
    );
    return List.generate(
      maps.length,
      (i) {
        return ProductQuantity.fromLocalMap(
          maps[i],
        );
      },
    );
  }

  Future<void> updateOrderIsSync(int orderId) async {
    final db = await instance.database;
    await db.update(
      tableOrder,
      {'is_sync': 1},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}

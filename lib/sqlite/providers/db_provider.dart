import 'dart:async';

import 'package:ice_app_new/sqlite/models/customer_price.dart';
import 'package:ice_app_new/sqlite/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  static Database _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB('ice_offline.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createTB);
  }

  Future _createTB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final integernullType = 'INTEGER';
    final floatType = 'REAL';

    await db.execute('''CREATE TABLE $tableCustomerprice(
      ${CustomerpriceFields.id} $integerType,
      ${CustomerpriceFields.code} $textType,
      ${CustomerpriceFields.name} $textType,
      ${CustomerpriceFields.product_id} $integerType,
      ${CustomerpriceFields.sale_price} $textType,
      ${CustomerpriceFields.route_id} $integerType,
      ${CustomerpriceFields.price_group_id} $integernullType,
      ${CustomerpriceFields.createdTime} $textType,
      ${CustomerpriceFields.product_name} $textType
     )
    ''');

    await db.execute('''CREATE TABLE $tableProduct(
      ${ProductFields.id} $textType,
      ${ProductFields.code} $textType,
      ${ProductFields.name} $textType,
      ${ProductFields.qty} $textType,
      ${ProductFields.issue_id} $integerType,
      ${ProductFields.route_id} $integerType,
      ${ProductFields.price_group_id} $integernullType,
      ${ProductFields.createdTime} $textType
     )
    ''');

    // await db.execute('''CREATE TABLE $tableOrder(
    //   ${OrderFields.id} $idType,
    //   ${OrderFields.product_id} $integerType,
    //   ${OrderFields.customer_id} $integerType,
    //   ${OrderFields.qty} $floatType,
    //   ${OrderFields.price} $floatType,
    //   ${OrderFields.issue_id} $integerType,
    //   ${OrderFields.route_id} $integerType,
    //   ${OrderFields.price_group_id} $integerType,
    //   ${OrderFields.createdTime} $textType,
    //   ${OrderFields.company_id} $integerType,
    //   ${OrderFields.branch_id} $integerType
    //  )
    // ''');
  }

  Future<int> checkDB() async {
    final db = await instance.database;
    //final id = await db.insert(tableCustomerprice, note.toJson());
    return 1;
  }

  Future<CustomerPrice> createCustomerPrice(CustomerPrice data) async {
    final db = await instance.database;

    final id = await db.insert(tableCustomerprice, data.toJson());
    return data.copy(id: id);
  }

  Future<List<CustomerPrice>> readAllCustomerPrice() async {
    final db = await instance.database;

    final orderBy = '${CustomerpriceFields.id} ASC';

    final result = await db.query(tableCustomerprice, orderBy: orderBy);
    return result.map((json) => CustomerPrice.fromJson(json)).toList();
  }

  Future<List<CustomerPrice>> readAllCustomer() async {
    final db = await instance.database;

    final orderBy = '${CustomerpriceFields.id} ASC';

    final result =
        //  await db.query(tableCustomerprice, distinct: true, orderBy: orderBy);
        await db.rawQuery('SELECT DISTINCT id, code, name FROM customer_price');
    return result.map((json) => CustomerPrice.fromJsonDropdown(json)).toList();
  }

  Future<List<CustomerProductPrice>> findCustomerproduct(
      String customer_id) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT customer_price.product_id, product.code, product.name, customer_price.sale_price ,product.issue_id, product.price_group_id , product.qty FROM customer_price INNER JOIN product ON product.id = customer_price.product_id WHERE customer_price.id= ?',
        [customer_id]);
    return result.map((json) => CustomerProductPrice.fromJson(json)).toList();
  }

  Future<int> deleteCustpriceAll() async {
    final db = await instance.database;

    return db.delete(tableCustomerprice);
  }

  Future<List> findCustomer(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    List<CustomerPrice> listcustomer = await instance.readAllCustomer();

    return listcustomer
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<Product> createProduct(Product data) async {
    final db = await instance.database;

    final id = await db.insert(tableProduct, data.toJson());
    return data.copy(id: id.toString());
  }

  Future<List<Product>> readAllProduct() async {
    final db = await instance.database;

    final orderBy = '${ProductFields.id} ASC';

    final result = await db.query(tableProduct, orderBy: orderBy);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<int> deleteProductAll() async {
    final db = await instance.database;

    return db.delete(tableProduct);
  }

  // Future<Note> create(Note note) async {
  //   final db = await instance.database;

  //   final id = await db.insert(tableCustomerprice, note.toJson());
  //   return note.copy(id: id);
  // }

  // Future<Note> readNote(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     tableCustomerprice,
  //     columns: CustomerpriceFields.values,
  //     where: '${CustomerpriceFields.id} = ?',
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     return Note.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  // Future<List<Note>> readAllNote() async {
  //   final db = await instance.database;

  //   final orderBy = '${CustomerpriceFields.id} ASC';

  //   final result = await db.query(tableCustomerprice, orderBy: orderBy);
  //   return result.map((json) => Note.fromJson(json)).toList();
  // }

  // Future<int> updateNote(Note note) async {
  //   final db = await instance.database;

  //   return db.update(
  //     tableCustomerprice,
  //     note.toJson(),
  //     where: '${CustomerpriceFields.id} = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  // Future<int> deleteNote(int id) async {
  //   final db = await instance.database;

  //   return db.delete(
  //     tableCustomerprice,
  //     where: '${CustomerpriceFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

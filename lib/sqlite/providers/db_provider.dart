import 'dart:async';
import 'dart:convert';

import 'package:ice_app_new/sqlite/models/customer_price.dart';
import 'package:ice_app_new/sqlite/models/order.dart';
import 'package:ice_app_new/sqlite/models/orderofflinedetail.dart';
import 'package:ice_app_new/sqlite/models/product.dart';
import 'package:ice_app_new/sqlite/models/product_stock_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  static Database _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB('icesystem1.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 3, onCreate: _createTB);
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

    await db.execute('''CREATE TABLE $tableOrder(
      ${OrderFields.id} $idType,
      ${OrderFields.payment_type_id} $textType,
      ${OrderFields.order_date} $textType,
      ${OrderFields.customer_id} $textType,
      ${OrderFields.user_id} $textType,
      ${OrderFields.route_id} $textType,
      ${OrderFields.car_id} $textType,
      ${OrderFields.company_id} $textType,
      ${OrderFields.branch_id} $textType,
      ${OrderFields.data} $textType,
      ${OrderFields.discount} $textType,
      ${OrderFields.sync_status} $textType,
      ${OrderFields.customer_name} $textType,
      ${OrderFields.total_amt} $textType
     )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute(
          '''ALTER TABLE $tableOrder ADD COLUMN customer_name TEXT,total_amt TEXT;''');
    }
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
    // final result = await db.rawQuery(
    //     'SELECT customer_price.product_id, product.code, product.name, customer_price.sale_price ,product.issue_id, product.price_group_id , product.qty FROM customer_price INNER JOIN product ON product.id = customer_price.product_id');
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

  Future<int> upateProductStock(String product_id, String qty) async {
    final db = await instance.database;

    final result = await db
        .rawQuery('UPDATE product SET qty= ?  WHERE id= ?', [qty, product_id]);
    return result.length;
  }

  Future<int> deleteProductAll() async {
    final db = await instance.database;

    return db.delete(tableProduct);
  }

  Future<int> checkhasproductinissuedata(String product_id) async {
    final db = await instance.database;
    final result =
        await db.rawQuery('SELECT * FROM product WHERE id= ?', [product_id]);
    return result.length;
  }

//// Order section

  Future<bool> createOrder(Order data) async {
    final db = await instance.database;

    final id = await db.insert(tableOrder, data.toJson());
    return id > 0 ? true : false;
  }

  Future<List<Map<String, dynamic>>> readAllOrder() async {
    final db = await instance.database;

    final orderBy = '${OrderFields.id} ASC';

    final result = await db.query(tableOrder, orderBy: orderBy);
    return result;
  }

  Future<List<Map<String, dynamic>>> findOrderByCustomerId(
      String customer_id) async {
    final db = await instance.database;

    final where_arg = '${OrderFields.customer_id} = ${customer_id}';
    final orderBy = '${OrderFields.id} ASC';

    final result =
        await db.query(tableOrder, where: where_arg, orderBy: orderBy);
    return result;
  }

  Future<List<Map<String, dynamic>>> findOrderById(String id) async {
    final db = await instance.database;

    final where_arg = '${OrderFields.id} = ${id}';
    final orderBy = '${OrderFields.id} ASC';

    final result =
        await db.query(tableOrder, where: where_arg, orderBy: orderBy);
    return result;
  }

  Future<int> updateDataOrder(var newdata, String id, double new_total) async {
    final db = await instance.database;
    //final update_query = '${OrderFields.data} = ${json.encode(newdata)}';
    Map<String, dynamic> new_data = {
      'data': json.encode(newdata),
      'total_amt': new_total.toString()
    };
    final where_arg = '${OrderFields.id} = ${id}';

    final result = await db.update(tableOrder, new_data, where: where_arg);
    return result;
  }

  Future<int> deleteOrderAll() async {
    final db = await instance.database;

    return db.delete(tableOrder);
  }

  Future<bool> upateProductOfflineStock(
      List<ProductStockUpdate> data_update, String stock_type) async {
    double old_qty = 0;
    List<Map<String, Object>> result;
    final db = await instance.database;

    if (data_update.length > 0) {
      data_update.forEach((element) async {
        List<Map> old_qty_data = await db.rawQuery(
            'SELECT qty FROM product WHERE id= ?', [element.product_id]);

        old_qty = double.parse(old_qty_data[0]['qty']);

        String new_qty = "0";
        if (stock_type == "2") {
          // 1 in 2 out
          new_qty = (old_qty - double.parse(element.qty)).toString();
        } else if (stock_type == "1") {
          new_qty = (old_qty + double.parse(element.qty)).toString();
        }
        if (double.parse(new_qty) >= 0) {
          result = await db.rawQuery('UPDATE product SET qty= ?  WHERE id= ?',
              [new_qty, element.product_id]);
        }
      });
    }

    return true;
  }

  /// list all table
  Future<List<String>> getAllTableNames() async {
    final db = await instance.database;
    List<Map> maps =
        await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');

    List<String> tableNameList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        try {
          tableNameList.add(maps[i]['name'].toString());
        } catch (e) {
          print('Exeption : ' + e);
        }
      }
    }
    return tableNameList;
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

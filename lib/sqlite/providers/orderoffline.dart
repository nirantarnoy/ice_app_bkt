import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/sqlite/models/order.dart';
import 'package:ice_app_new/sqlite/models/orderoffline.dart';
import 'package:ice_app_new/sqlite/models/orderofflinedetail.dart';
import 'package:ice_app_new/sqlite/models/product_stock_update.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:ice_app_new/widgets/order/order_item_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String url_to_add_order_new =
    "http://103.253.73.108/icesystem/frontend/web/api/order/addordernew";

class OrderOfflineData extends ChangeNotifier {
  List<Orderoffline> _orderoffline;
  List<Orderoffline> get listorderoffline => _orderoffline;

  List<Orderofflinedetail> _orderofflinedetail;
  List<Orderofflinedetail> get listorderofflinedetail => _orderofflinedetail;

  set listorderoffline(List<Orderoffline> val) {
    _orderoffline = val;
  }

  set listorderofflinedetail(List<Orderofflinedetail> val) {
    _orderofflinedetail = val;
  }

  double get sumcashdiscount {
    double total = 0;
    // listorder_discount.forEach((discount) {
    //   total = double.parse(discount.discount_cash_amount);
    // });
    return total;
  }

  double get sumcreditdiscount {
    double total = 0;
    // listorder_discount.forEach((discount) {
    //   total = double.parse(discount.discount_credit_amount);
    // });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    if (listorderoffline.isNotEmpty) {
      listorderoffline.forEach((orderItem) {
        //if (orderItem.order_line_status != '500') {
        total += double.parse(orderItem.total_amt);
        // }
      });
    }
    return total;
  }

  double get cashTotalAmount {
    double total = 0.0;
    if (listorderoffline.isNotEmpty) {
      listorderoffline
          .where((items) => items.payment_method_id == "1")
          .forEach((orderItem) {
        // if (orderItem.order_line_status != '500') {
        total += double.parse(orderItem.total_amt);
        //}
      });
    }
    // return (total - sumcashdiscount);
    return total;
  }

  double get cashTotalQty {
    double total = 0.0;
    if (listorderoffline.isNotEmpty) {
      listorderoffline
          .where((items) => items.payment_method_id == "1")
          .forEach((orderItem) {
        var order_line_data = orderItem.data;
        var order_detail = json.decode(order_line_data);
        List<Orderofflinedetail> x = List<Orderofflinedetail>.from(
            order_detail.map((model) => Orderofflinedetail.fromJson(model)));
        x.forEach((element) {
          total += double.parse(element.qty);
        });
      });
    }
    return total;
  }

  double get creditTotalQty {
    double total = 0.0;
    if (listorderoffline.isNotEmpty) {
      listorderoffline
          .where((items) => items.payment_method_id == "2")
          .forEach((orderItem) {
        var order_line_data = orderItem.data;
        var order_detail = json.decode(order_line_data);
        List<Orderofflinedetail> x = List<Orderofflinedetail>.from(
            order_detail.map((model) => Orderofflinedetail.fromJson(model)));
        x.forEach((element) {
          total += double.parse(element.qty);
        });
      });
    }
    return total;
  }

  List<Orderoffline> findOredrById(String order_id) {
    return listorderoffline.where((element) => element.id == order_id).toList();
  }

  double get creditTotalAmount {
    double total = 0.0;
    if (listorderoffline.isNotEmpty) {
      listorderoffline
          .where((items) => items.payment_method_id == "2")
          .forEach((orderItem) {
        //if (orderItem.order_line_status != '500') {
        total += double.parse(orderItem.total_amt);
        //}
      });
    }
    // return (total - sumcreditdiscount);
    return total;
  }

  Future<dynamic> showItemlist() async {
    List<Orderoffline> data = [];
    List<Map<String, dynamic>> queryRows;

    queryRows = await DbHelper.instance.readAllOrder();

    for (int i = 0; i <= queryRows.length - 1; i++) {
      //print(queryRows[i]['id']);
      final Orderoffline items = Orderoffline(
        id: queryRows[i]['id'].toString(),
        customer_id: queryRows[i]['customer_id'],
        qty: '0',
        payment_method_id: queryRows[i]['payment_type_id'],
        total_amt: queryRows[i]['total_amt'].toString(),
        customer_name: queryRows[i]['customer_name'].toString(),
        order_date: queryRows[i]['order_date'].toString(),
        data: queryRows[i]['data'],
        discount_amount: queryRows[i]['discount_amount'],
      );
      // print(items.id);
      data.add(items);
    }
    listorderoffline = data;
    return listorderoffline;
    //print(queryRows);
  }

  Future<dynamic> fetOrderByCustomerId(String customer_id) async {
    List<Orderoffline> data = [];
    List<Map<String, dynamic>> queryRows;

    queryRows = await DbHelper.instance.findOrderByCustomerId(customer_id);

    for (int i = 0; i <= queryRows.length - 1; i++) {
      //print(queryRows[i]['id']);
      final Orderoffline items = Orderoffline(
        id: queryRows[i]['id'].toString(),
        customer_id: queryRows[i]['customer_id'],
        qty: queryRows[i]['customer_id'].toString(),
        payment_method_id: queryRows[i]['payment_type_id'],
        total_amt: queryRows[i]['total_amt'].toString(),
        customer_name: queryRows[i]['customer_name'].toString(),
        order_date: queryRows[i]['order_date'].toString(),
        data: queryRows[i]['data'],
        discount_amount: queryRows[i]['discount_amount'],
      );
      // print(items.id);
      data.add(items);
    }
    listorderoffline = data;
    return listorderoffline;
  }

  double getSumQty() {
    double total = 0;
    listorderofflinedetail.forEach((element) {
      total = total + double.parse(element.qty);
    });
    return total;
  }

  double getTotalAmt() {
    double total = 0;
    listorderofflinedetail.forEach((element) {
      total = total + (double.parse(element.qty) * double.parse(element.price));
    });
    return total;
  }

  double getDiscount() {
    double total = 0;
    listorderofflinedetail.forEach((element) {
      total = total + double.parse(element.discount_amount);
    });
    return total;
  }

  Future<dynamic> fetOrderDetailById(String order_data) async {
    List<Orderoffline> data = [];
    List<Map<String, dynamic>> queryRows;

    var order_detail = json.decode(order_data);
    List<Orderofflinedetail> x = List<Orderofflinedetail>.from(
        order_detail.map((model) => Orderofflinedetail.fromJson(model)));
    listorderofflinedetail = x;
    return listorderofflinedetail;
  }

  Future<dynamic> deleteOrderline(String order_id, String product_id) async {
    List<Orderoffline> data = [];
    List<Map<String, dynamic>> queryRows;
    double new_total = 0;

    queryRows = await DbHelper.instance.findOrderById(order_id);
    String order_detail = '';

    for (int i = 0; i <= queryRows.length - 1; i++) {
      order_detail = queryRows[i]['data'];
    }

    // print('order id is ${order_id}');
    // print('order detail for check delete is ${order_detail}');

    if (order_detail != '') {
      List<ProductStockUpdate> product_stock_update = [];
      var order_data = json.decode(order_detail);
      List<Orderofflinedetail> newdata = List<Orderofflinedetail>.from(
          order_data.map((model) => Orderofflinedetail.fromJson(model)));

      if (newdata.isNotEmpty) {
        newdata.forEach((items) {
          if (items.product_id == product_id) {
            ProductStockUpdate forupdate = ProductStockUpdate(
              product_id: items.product_id,
              qty: items.qty,
            );

            product_stock_update.add(forupdate);
          }
        });
        newdata.removeWhere((element) => element.product_id == product_id);

        newdata.forEach((element) {
          new_total = new_total +
              (double.parse(element.qty) * double.parse(element.price));
        });
      }

      var jsonx = newdata
          .map((e) => {
                'order_id': order_id,
                'product_id': e.product_id,
                'qty': e.qty,
                'price': e.price,
                'price_group_id': e.price_group_id,
                'product_code': e.product_code,
                'product_name': e.product_name,
                'order_line_status': e.order_line_status,
                'discount_amount': e.discount_amount,
              })
          .toList();
      // print('order detail after delete is ${json.encode(jsonx)}');
      if (await DbHelper.instance.updateDataOrder(jsonx, order_id, new_total) >
          0) {
        await DbHelper.instance.upateProductOfflineStock(
            product_stock_update, "1"); // 1 return qty to stock
      }

      notifyListeners();
    }
  }

  Future<bool> addOrderoffline() async {
    String _user_id = "";
    String _route_id = "";
    String _car_id = "";
    String _company_id = "";
    String _branch_id = "";

    String customer_id;
    String pay_type;
    String discount;

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
      _car_id = prefs.getString('emp_car_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    List<Addorder> listdata;
    List<Addorder> _order_data = [];
    List<Map<String, dynamic>> queryRows;

    queryRows = await DbHelper.instance.readAllOrder();

    for (int i = 0; i <= queryRows.length - 1; i++) {
      //print(queryRows[i]['id']);
      customer_id = queryRows[i]['customer_id'];
      pay_type = queryRows[i]['payment_type_id'];
      discount = queryRows[i]['discount_amount'];
      var order_detail = queryRows[i]['data'];

      var order_data = json.decode(order_detail);
      List<Orderofflinedetail> newdata = List<Orderofflinedetail>.from(
          order_data.map((model) => Orderofflinedetail.fromJson(model)));

      var jsonx = newdata
          .map((e) => {
                'product_id': e.product_id,
                'qty': e.qty,
                'price': e.price,
                'price_group_id': e.price_group_id,
              })
          .toList();

      final Map<String, dynamic> orderData = {
        'payment_type_id': pay_type,
        'order_date': _order_date,
        'customer_id': customer_id,
        'user_id': _user_id,
        'route_id': _route_id,
        'car_id': _car_id,
        'company_id': _company_id,
        'branch_id': _branch_id,
        'data': jsonx,
        'discount': discount,
      };
      print('data will save order offline is ${orderData}');
      // if (customer_id != '' && newdata.length > 0) {
      //   try {
      //     http.Response response;
      //     response = await http.post(Uri.parse(url_to_add_order_new),
      //         headers: {'Content-Type': 'application/json'},
      //         body: json.encode(orderData));

      //     if (response.statusCode == 200) {
      //       Map<String, dynamic> res = json.decode(response.body);
      //       print('data added order is  ${res["data"]}');
      //       _iscomplated = true;
      //     }
      //   } catch (_) {
      //     _iscomplated = false;
      //     // print('cannot create order');
      //   }
      // }
    }
    if (_iscomplated == true) {
      await DbHelper.instance.deleteOrderAll();
    }
    return _iscomplated;
  }
}

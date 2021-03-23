import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/orders.dart';
import 'package:ice_app_new/models/order_detail.dart';
import 'package:ice_app_new/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderData with ChangeNotifier {
  final String server_api = "";
  final String url_to_order =
      "http://192.168.1.120/icesystem/frontend/web/api/order/list";
  //"http://192.168.60.118/icesystem/frontend/web/api/order/list";
  final String url_to_order_detail =
      "http://192.168.1.120/icesystem/frontend/web/api/order/listbycustomer";
  //"http://192.168.60.118/icesystem/frontend/web/api/order/listbycustomer";
  final String url_to_add_order =
      "http://192.168.1.120/icesystem/frontend/web/api/order/addorder";
  //  "http://192.168.1.120/icesystem/frontend/web/api/order/addorder";
  final String url_to_update_order =
      "http://192.168.1.120/icesystem/frontend/web/api/order/updateorder";
  final String url_to_delete_order =
      "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorder";
  final String url_to_update_order_detail =
      "http://192.168.1.120/icesystem/frontend/web/api/order/updateorderdetail";
  final String url_to_delete_order_detail =
      "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorderline";
  // "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorderline";

  ///// for common
  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;
  int _line_id = 0;

  ///// for order
  List<Orders> _order;
  List<Orders> get listorder => _order;

  int get idOrder => _id;

  set idOrder(int val) {
    _id = val;
    notifyListeners();
  }

  set listorder(List<Orders> val) {
    _order = val;
    notifyListeners();
  }

  ///// for order detail

  List<OrderDetail> _orderdetail;
  List<OrderDetail> get listorder_detail => _orderdetail;

  int get idOrderline => _line_id;

  set idOrderline(int val) {
    _line_id = val;
    notifyListeners();
  }

  set listorder_detail(List<OrderDetail> val) {
    _orderdetail = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_apicon {
    return _isApicon;
  }

  double get totalAmount {
    double total = 0.0;
    listorder.forEach((orderItem) {
      total += double.parse(orderItem.total_amount);
    });
    return total;
  }

  Orders findById(String id) {
    return listorder.firstWhere((order) => order.customer_id == id);
  }

  Future<dynamic> fetOrders() async {
    String _car_id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _car_id = prefs.getString('emp_car_id');
    }
    final Map<String, dynamic> filterData = {'car_id': _car_id};
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Orders> data = [];
        print('data length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final Orders orderresult = Orders(
            id: res['data'][i]['id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_code: res['data'][i]['customer_code'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            note: res['data'][i]['note'].toString(),
            total_amount: res['data'][i]['total_amount'].toString(),
            payment_method: res['data'][i]['payment_method'].toString(),
            payment_method_id: res['data'][i]['payment_method_id'].toString(),
          );

          data.add(orderresult);
        }

        listorder = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listorder;
      }
    } catch (_) {
      _isApicon = false;
      print('order cannot fetch data');
    }
  }

  Future<void> addOrder(
      String product_id, int qty, int price, int customer_id) async {
    String _user_id = "";
    String _route_id = "";
    String _car_id = "";

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
      _car_id = prefs.getString('emp_car_id');
    }

    final Map<String, dynamic> orderData = {
      'order_date': _order_date,
      'product_id': product_id,
      'customer_id': customer_id,
      'qty': qty,
      'user_id': _user_id,
      'issue_id': "0",
      'route_id': _route_id,
      'car_id': _car_id,
    };
    print(orderData);
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data add order is  ${res["data"]}');
      }
    } catch (_) {}
  }

  Future<dynamic> getCustomerDetails(String customer_id) async {
    _isLoading = true;
    notifyListeners();
    String _order_date = new DateTime.now().toString();
    final Map<String, dynamic> filterData = {
      'order_date': _order_date,
      'customer_id': customer_id
    };
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order_detail),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<OrderDetail> data = [];
        print('data order line length is ${res["data"].length}');
        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return null;
        }
        for (var i = 0; i < res['data'].length - 1; i++) {
          final OrderDetail orderlineresult = new OrderDetail(
            order_id: res['data'][i]['order_id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            line_id: res['data'][i]['line_id'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            qty: res['data'][i]['qty'].toString(),
            price: res['data'][i]['price'].toString(),
            price_group_id: res['data'][i]['price_group_id'].toString(),
          );

          data.add(orderlineresult);
        }

        listorder_detail = data;
        _isLoading = false;
        notifyListeners();
        return listorder_detail;
      }
    } catch (_) {}
  }

  void removeOrder(String id) {
    listorder.remove(id);
    print('remove order');
    notifyListeners();
  }

  void removeOrderDetail(String line_id) async {
    final Map<String, dynamic> delete_id = {
      'id': line_id,
    };

    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_delete_order_detail),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');
      }
    } catch (_) {}
    print('remove order line $line_id');
    notifyListeners();
  }
}

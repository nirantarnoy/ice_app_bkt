import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/orders.dart';
import 'package:ice_app_new/models/order_detail.dart';

class OrderData with ChangeNotifier {
  final String url_to_order =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/list";
      "http://192.168.60.118/icesystem/frontend/web/api/order/listbycustomer";
  final String url_to_order_detail =
      "http://192.168.60.118/icesystem/frontend/web/api/order/detail";
  final String url_to_add_order =
      "http://192.168.60.118/icesystem/frontend/web/api/order/addorder";
  final String url_to_update_order =
      "http://192.168.60.118/icesystem/frontend/web/api/order/updateorder";
  final String url_to_delete_order =
      "http://192.168.60.118/icesystem/frontend/web/api/order/deleteorder";
  final String url_to_update_order_detail =
      "http://192.168.60.118/icesystem/frontend/web/api/order/updateorderdetail";
  final String url_to_delete_order_detail =
      "http://192.168.60.118/icesystem/frontend/web/api/order/deleteorderdetail";

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

  Future<dynamic> fetOrders() async {
    final Map<String, dynamic> filterData = {'car_id': 0};
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
        print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          // print(product);
          // data.add(product);
          final Orders orderresult = Orders(
            id: res['data'][i]['id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
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
    final Map<String, dynamic> orderData = {
      'product_id': product_id,
      'qty': qty,
      'price': price,
      'customer_id': customer_id
    };
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {}
    } catch (_) {}
  }

  Future<dynamic> getDetails(String order_id) async {
    final Map<String, dynamic> filterData = {'order_id': order_id};
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
            order_no: res['data'][i]['order_id'].toString(),
            line_id: res['data'][i]['order_id'].toString(),
            customer_id: res['data'][i]['order_id'].toString(),
            customer_name: res['data'][i]['order_id'].toString(),
            product_id: res['data'][i]['order_id'].toString(),
            producnt_name: res['data'][i]['order_id'].toString(),
            qty: res['data'][i]['order_id'].toString(),
            price: res['data'][i]['order_id'].toString(),
            price_group_id: res['data'][i]['order_id'].toString(),
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

  void removeOrder() {
    print('remove order');
    notifyListeners();
  }
}

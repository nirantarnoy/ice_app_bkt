import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/orders.dart';

class OrderData with ChangeNotifier {
  final String url_to_order =
      "http://192.168.60.118/icesystem/frontend/web/api/order/list";
  final String url_to_order_detail =
      "http://203.203.1.224/icesystem/frontend/web/api/order/detail";

  List<Orders> _order;
  List<Orders> get listorder => _order;
  bool _isLoading = false;
  int _id = 0;
  int get idOrder => _id;

  set idOrder(int val) {
    _id = val;
    notifyListeners();
  }

  set listorder(List<Orders> val) {
    _order = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetOrders() async {
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.get(Uri.encodeFull(url_to_order),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Orders> data = [];
        print('data length is ${res["data"].length}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length - 1; i++) {
          // var product = Products.fromJson(res[i]);
          // print(product);
          // data.add(product);
          final Orders orderresult = Orders(
            id: res['data'][i]['id'],
            order_no: res['data'][i]['order_no'],
            order_date: res['data'][i]['order_date'],
            customer_name: res['data'][i]['customer_name'],
            note: res['data'][i]['note'],
          );

          data.add(orderresult);
        }

        listorder = data;
        _isLoading = false;
        notifyListeners();
        return listorder;
      }
    } catch (_) {}
  }

  Future<void> addOrder(String product_id, int qty, int customer_id) async {
    final Map<String, dynamic> orderData = {
      'product_id': product_id,
      'qty': qty,
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

  // Future<Orders> getDetails() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(Uri.encodeFull(url_to_order),
  //         headers: {'Content-Type': 'application/json'});

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       List<Orders> data = [];
  //       print('data length is ${res["data"].length}');
  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return null;
  //       }
  //       for (var i = 0; i < res['data'].length - 1; i++) {
  //         final Orders orderresult = Orders(
  //           id: res['data'][i]['id'],
  //           order_no: res['data'][i]['order_no'],
  //           order_date: res['data'][i]['order_date'],
  //           customer_name: res['data'][i]['customer_name'],
  //           note: res['data'][i]['note'],
  //         );

  //         data.add(orderresult);
  //       }

  //       listorder = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listorder;
  //     }
  //   } catch (_) {}
  // }
}

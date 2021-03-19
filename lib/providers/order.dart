import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/orders.dart';

class OrderData with ChangeNotifier {
  final String url_to_order =
      "http://192.168.1.120/icesystem/frontend/web/api/order/list";
  //  "http://192.168.60.118/icesystem/frontend/web/api/order/list";
  final String url_to_order_detail =
      "http://203.203.1.224/icesystem/frontend/web/api/order/detail";
  final String url_to_add_order =
      "http://192.168.60.118/icesystem/frontend/web/api/order/addorder";

  List<Orders> _order;
  List<Orders> get listorder => _order;
  bool _isLoading = false;
  bool _isApicon = true;
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
    //_isLoading = true;
    //notifyListeners();
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

        for (var i = 0; i < res['data'].length - 1; i++) {
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

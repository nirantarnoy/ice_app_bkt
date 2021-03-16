import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/customers.dart';

class CustomerData with ChangeNotifier {
  final String url_to_customer_list =
      "http://192.168.60.118/icesystem/frontend/web/api/customer/list";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";
  final String url_to_customer_detail =
      "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
  // "http://119.59.100.74/icesystem/frontend/web/api/customer/detail";

  List<Customers> _customer;
  List<Customers> get listcustomer => _customer;
  bool _isLoading = false;
  int _id = 0;
  int get idCustomer => _id;

  set idCustomer(int val) {
    _id = val;
    notifyListeners();
  }

  set listcustomer(List<Customers> val) {
    _customer = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetCustomers() async {
    final Map<String, dynamic> filterData = {'route_id': 5};
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_customer_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Customers> data = [];
        print('data customer length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length - 1; i++) {
          // var product = Customers.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Customers customerresult = Customers(
              id: res['data'][i]['id'].toString(),
              code: res['data'][i]['code'].toString(),
              name: res['data'][i]['name'].toString(),
              route_id: res['data'][i]['route_id'].toString(),
              route_name: '');

          //  print('data from server is ${customerresult}');
          data.add(customerresult);
        }

        listcustomer = data;
        _isLoading = false;
        notifyListeners();
        return listcustomer;
      }
    } catch (_) {}
  }

  // Future<void> addOrder(String product_id, int qty, int customer_id) async {
  //   final Map<String, dynamic> orderData = {
  //     'product_id': product_id,
  //     'qty': qty,
  //     'customer_id': customer_id
  //   };
  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.encodeFull(url_to_customer),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(orderData));

  //     if (response.statusCode == 200) {}
  //   } catch (_) {}
  // }

  // Future<Orders> getDetails() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(Uri.encodeFull(url_to_customer),
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

  //       listcustomer = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listcustomer;
  //     }
  //   } catch (_) {}
  // }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/products.dart';

class ProductData with ChangeNotifier {
  final String url_to_product_list =
      "http://192.168.1.120/icesystem/frontend/web/api/product/list";
  //   "http://192.168.60.118/icesystem/frontend/web/api/product/list";
  // "http://119.59.100.74/icesystem/frontend/web/api/product/list";
  final String url_to_product_detail =
      //    "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://119.59.100.74/icesystem/frontend/web/api/product/detail";

  List<Products> _product;
  List<Products> get listproduct => _product;
  bool _isLoading = false;
  int _id = 0;
  int get idProduct => _id;

  set idProduct(int val) {
    _id = val;
    notifyListeners();
  }

  set listproduct(List<Products> val) {
    _product = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetProducts() async {
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.get(Uri.encodeFull(url_to_product_list),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Products> data = [];
        // print('data length is ${res["data"].length}');
        // print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length - 1; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Products productresult = Products(
              id: res['data'][i]['id'].toString(),
              code: res['data'][i]['code'].toString(),
              name: res['data'][i]['name'].toString(),
              sale_price: res['data'][i]['sale_price'].toString(),
              image: res['data'][i]['image'].toString());

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listproduct = data;
        _isLoading = false;
        notifyListeners();
        return listproduct;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  // Future<void> addOrder(String product_id, int qty, int customer_id) async {
  //   final Map<String, dynamic> orderData = {
  //     'product_id': product_id,
  //     'qty': qty,
  //     'customer_id': customer_id
  //   };
  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.encodeFull(url_to_product),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(orderData));

  //     if (response.statusCode == 200) {}
  //   } catch (_) {}
  // }

  // Future<Orders> getDetails() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(Uri.encodeFull(url_to_product),
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

  //       listproduct = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listproduct;
  //     }
  //   } catch (_) {}
  // }
}

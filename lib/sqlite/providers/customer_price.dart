import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/sqlite/models/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerpriceData with ChangeNotifier {
  final String url_to_get_customer_price =
      "http://103.253.73.108/icesystem/frontend/web/api/product/findcustpriceoffline";

  bool _isLoading = false;

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetpriceonline() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {'route_id': _routeid};
    print(filterData);
    _isLoading = true;
    notifyListeners();

    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_get_customer_price),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data price length is ${res["data"].length}');
        // print('data price length is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          // return false;
        }

        List<CustomerPrice> data = [];

        for (var i = 0; i < res['data'].length; i++) {
          // print(res['data'][i]['cus_code']);
          final CustomerPrice price_result = CustomerPrice(
            id: res['data'][i]['cus_id'],
            route_id: res['data'][i]['route_id'],
            sale_price: res['data'][i]['sale_price'].toString(),
            code: res['data'][i]['cus_code'].toString(),
            name: res['data'][i]['cus_name'].toString(),
            createdTime: DateTime.now(),
            product_id: res['data'][i]['product_id'],
            price_group_id: res['data'][i]['price_group_id'],
            product_name: res['data'][i]['product_name'],

            //   id: int.parse(res['data'][i]['cus_id']),
            // route_id: int.parse(res['data'][i]['route_id']),
            // sale_price: double.parse(res['data'][i]['sale_price']),
            // code: res['data'][i]['cus_code'].toString(),
            // name: res['data'][i]['cus_name'].toString(),
            // createdTime: DateTime.now(),
            // product_id: int.parse(res['data'][i]['product_id']),
            // price_group_id: 0,
            //  price_group_id: res['data'][i]['price_group_id'],
          );

          //  data.add(price_result);

          if (price_result != null) {
            _addCustomerprice(price_result);
          }
        }

        // if (data != null) {
        //   //_addCustomerprice(price_result);
        // }

        _isLoading = false;
        notifyListeners();
        // return true;
      }
    } catch (_) {
      print('api error na ja');
      //return false;
    }
  }

  Future _addCustomerprice(CustomerPrice data) async {
    await DbHelper.instance.createCustomerPrice(data);
  }
}

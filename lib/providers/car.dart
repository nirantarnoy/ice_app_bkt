import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/car.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarData with ChangeNotifier {
  final String url_to_car_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/customer/list";
      "http://103.253.73.108/icesystem/frontend/web/api/car/list";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";

  List<Car> _car;
  List<Car> get listcar => _car;
  bool _isLoading = false;
  int _id = 0;

  int get idCar => _id;

  set idCar(int val) {
    _id = val;
    notifyListeners();
  }

  set listcar(List<Car> val) {
    _car = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fethCar() async {
    String _current_route_id = "";
    String _company_id = "";
    String _branch_id = "";
    String _car_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _current_route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _car_id = prefs.getString('emp_car_id');
    }

    final Map<String, dynamic> filterData = {
      'route_id': _current_route_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'car_id': _car_id,
    };
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_car_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Car> data = [];
        print('data customer length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Car.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Car customerresult = Car(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
            route_id: res['data'][i]['route_id'].toString(),
            route_name: res['data'][i]['route_name'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(customerresult);
        }

        listcar = data;
        _isLoading = false;
        notifyListeners();
        return listcar;
      }
    } catch (_) {}
  }

  Future<List> findCar(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listcar
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/findtransfer.dart';

import 'package:ice_app_new/models/transferin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferinData with ChangeNotifier {
  final String url_to_in_list =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/inlist";
  final String url_to_find_transfer =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/findtransfer";
  final String url_to_accept_transfer =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/accepttransfer";

  List<Transferin> _transferin;
  List<Transferin> get listtransferin => _transferin;
  List<FindTransfer> _findtransfer;
  List<FindTransfer> get findtransfer => _findtransfer;

  bool _isLoading = false;
  bool _isApicon = false;
  int _id = 0;

  int get idTransferin => _id;

  set idTransferin(int val) {
    _id = val;
    notifyListeners();
  }

  set listtransferin(List<Transferin> val) {
    _transferin = val;
    notifyListeners();
  }

  set findtransfer(List<FindTransfer> val) {
    _findtransfer = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_apicon {
    return _isApicon;
  }

  Future<dynamic> fetTransferincheck() async {
    String _company_id = "";
    String _branch_id = "";
    String _trans_date = new DateTime.now().toString();
    String _routeid = '';

    String _car_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _car_id = prefs.getString('emp_car_id');
      _routeid = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'trans_date': _trans_date,
      'company_id': _company_id,
      'branch_id': _branch_id,
    };
    // _isLoading = true;
    notifyListeners();
    print('transfer check is $filterData');
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_find_transfer),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<FindTransfer> data = [];
        print('data customer length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Transferin.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final FindTransfer _result = FindTransfer(
            id: res['data'][i]['transfer_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            trans_date: res['data'][i]['journal_date'].toString(),
            from_route_id: res['data'][i]['from_route_id'].toString(),
            from_route_name: res['data'][i]['from_route_name'].toString(),
            transfer_status: res['data'][i]['transfer_status'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(_result);
        }

        findtransfer = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listtransferin;
      }
    } catch (_) {
      _isApicon = false;
    }
  }

  Future<dynamic> fetTransferinnew(String transfer_id) async {
    String _car_id = "";
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('user_id') != null) {
    //   _car_id = prefs.getString('emp_car_id');
    // }

    final Map<String, dynamic> filterData = {'transfer_id': transfer_id};
    // _isLoading = true;
    notifyListeners();
    print('trasfer view is $filterData');
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_in_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Transferin> data = [];
        print('data transfer in length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Transferin.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Transferin _result = Transferin(
            transfer_id: res['data'][i]['transfer_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            from_route: res['data'][i]['from_route'].toString(),
            from_car_no: res['data'][i]['from_car_name'].toString(),
            from_order_no: res['data'][i]['to_order_no'].toString(),
            qty: res['data'][i]['qty'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            sale_price: res['data'][i]['sale_price'].toString(),
            transfer_status: res['data'][i]['transfer_status'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(_result);
        }

        listtransferin = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listtransferin;
      }
    } catch (_) {
      _isApicon = false;
    }
  }

  Future<bool> accepttransfer(String transfer_id) async {
    // _isLoading = true;

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'transfer_id': transfer_id,
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
    };

    notifyListeners();
    print('trasfer accept is $filterData');
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_accept_transfer),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Transferin> data = [];
        print('data accept is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        for (var i = 0; i < res['data'].length; i++) {}
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return true;
      }
    } catch (_) {
      _isApicon = false;
      return false;
    }
  }

  Future<dynamic> fetTransferin() async {
    String _car_id = "";
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('user_id') != null) {
    //   _car_id = prefs.getString('emp_car_id');
    // }

    final Map<String, dynamic> filterData = {'transfer_id': _car_id};
    // _isLoading = true;
    notifyListeners();
    print('car_id is $filterData');
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_in_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Transferin> data = [];
        print('data customer length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Transferin.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Transferin _result = Transferin(
            transfer_id: res['data'][i]['transfer_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            from_route: res['data'][i]['from_route'].toString(),
            from_car_no: res['data'][i]['from_car_name'].toString(),
            from_order_no: res['data'][i]['to_order_no'].toString(),
            qty: res['data'][i]['qty'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            sale_price: res['data'][i]['sale_price'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(_result);
        }

        listtransferin = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listtransferin;
      }
    } catch (_) {
      _isApicon = false;
    }
  }
}

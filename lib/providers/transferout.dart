import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/transferout.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferoutData with ChangeNotifier {
  final String url_to_out_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/transfer/outlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/outlistnew";
  final String url_to_in_list =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/inlist";
  //"http://103.253.73.108/icesystem/frontend/web/api/customer/list";
  final String url_to_add_transfer =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://103.253.73.108/icesystem/frontend/web/api/transfer/addtransfer";
  //"http://103.253.73.108/icesystem/frontend/web/api/customer/list";

  List<Transferout> _transferout;
  List<Transferout> get listtransferout => _transferout;
  List<Transferout> _transferoutnew;
  List<Transferout> get listtransferoutnew => _transferoutnew;
  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;

  int get idTransferout => _id;

  set idTransferout(int val) {
    _id = val;
    notifyListeners();
  }

  set listtransferout(List<Transferout> val) {
    _transferout = val;
    notifyListeners();
  }

  set listtransferoutnew(List<Transferout> val) {
    _transferoutnew = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_apicon {
    return _isApicon;
  }

  // double get totalAmount {
  //   double total = 0.0;
  //   if (listtransferout.isNotEmpty) {
  //     listtransferout.forEach((orderItem) {
  //       total += double.parse(orderItem.qty);
  //     });
  //   }
  //   return total;
  // }

  Future<dynamic> fetTransferout() async {
    String _current_car_id = "";
    String _route_id = "";
    String _company_id = "";
    String _branch_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _current_car_id = prefs.getString('emp_car_id');
      _route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'car_id': _current_car_id,
      'route_id': _route_id,
      'to_route_id': _route_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
    };
    print('transfer out filter is ${filterData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_out_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Transferout> data = [];
        print('data customer length is ${res["data"].length}');
        print('data transfer is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Transferout.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Transferout customerresult = Transferout(
            transfer_id: res['data'][i]['transfer_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            to_route_id: res['data'][i]['to_route_id'].toString(),
            to_route_name: res['data'][i]['to_route_name'].toString(),
            transfer_status: res['data'][i]['transfer_status'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(customerresult);
        }

        listtransferout = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listtransferout;
      }
    } catch (_) {
      _isApicon = false;
    }
  }

  Future<dynamic> fetTransferoutnew(String transfer_id) async {
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
        Uri.parse(url_to_in_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Transferout> data = [];
        // print('data transfer out length is ${res["data"].length}');
        print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Transferin.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Transferout _result = Transferout(
            transfer_id: res['data'][i]['transfer_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            to_route_id: res['data'][i]['to_route_id'].toString(),
            to_route_name: res['data'][i]['to_route_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            sale_price: res['data'][i]['sale_price'].toString(),
            transfer_status: res['data'][i]['transfer_status'].toString(),
          );

          print('data from server is ${_result}');
          data.add(_result);
        }

        listtransferoutnew = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listtransferoutnew;
      }
    } catch (_) {
      _isApicon = false;
    }
  }

  Future<bool> addTransfer(String to_route_id, String to_car_id,
      List<TransferProduct> transferdata) async {
    //Map<String, dynamic> addData = Map<String, dynamic>();

    // var map = Map.fromIterable(transferdata,
    //     key: (e) => e.code, value: (e) => e.sale_price);
    // print(map);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _from_car_id = '';
    String _route_id = '';
    String _company_id = "";
    String _branch_id = "";
    String _user_id = "";
    if (prefs.getString('user_id') != null) {
      _from_car_id = prefs.getString('emp_car_id');
      _route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _user_id = prefs.getString('user_id');
    }

    var jsonx = transferdata
        .map((e) => {
              'product_id': e.id,
              'qty': e.qty,
              'price': e.sale_price,
              'issue_id': e.issue_ref_id,
            })
        .toList();

    // print(jsonx);

    Map<String, dynamic> dataAdd = {
      'from_car_id': _from_car_id,
      'to_car_id': to_car_id,
      'route_id': _route_id,
      'to_route_id': to_route_id,
      'data': jsonx,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'user_id': _user_id,
    };
    print('data will save is ${dataAdd}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_transfer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dataAdd));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data add transfer is  ${res["data"]}');
      } else {
        print('rrror');
      }
    } catch (_) {
      print('cannot create order');
    }
    return true;
  }
}

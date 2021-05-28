import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/transferout.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferoutData with ChangeNotifier {
  final String url_to_out_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/transfer/outlist";
      "http://119.59.100.74/icesystem/frontend/web/api/transfer/outlist";
  final String url_to_in_list =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://119.59.100.74/icesystem/frontend/web/api/transfer/inlist";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";
  final String url_to_add_transfer =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://119.59.100.74/icesystem/frontend/web/api/transfer/addtransfer";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";

  List<Transferout> _transferout;
  List<Transferout> get listtransferout => _transferout;
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

  bool get is_loading {
    return _isLoading;
  }

  bool get is_apicon {
    return _isApicon;
  }

  double get totalAmount {
    double total = 0.0;
    if (listtransferout.isNotEmpty) {
      listtransferout.forEach((orderItem) {
        total += double.parse(orderItem.qty);
      });
    }
    return total;
  }

  Future<dynamic> fetTransferout() async {
    String _current_car_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _current_car_id = prefs.getString('emp_car_id');
    }

    final Map<String, dynamic> filterData = {'car_id': _current_car_id};
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_out_list),
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
            to_route: res['data'][i]['to_route'].toString(),
            to_car_no: res['data'][i]['to_car_no'].toString(),
            to_order_no: res['data'][i]['to_order_no'].toString(),
            qty: res['data'][i]['qty'].toString(),
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

  Future<bool> addTransfer(
      String car_id, List<TransferProduct> transferdata) async {
    //Map<String, dynamic> addData = Map<String, dynamic>();

    // var map = Map.fromIterable(transferdata,
    //     key: (e) => e.code, value: (e) => e.sale_price);
    // print(map);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _from_car_id = '';
    if (prefs.getString('user_id') != null) {
      _from_car_id = prefs.getString('emp_car_id');
    }

    var jsonx = transferdata
        .map((e) => {
              'product_id': e.id,
              'qty': e.qty,
              'price': e.sale_price,
              'issue_id': e.issue_ref_id
            })
        .toList();

    // print(jsonx);

    Map<String, dynamic> dataAdd = {
      'from_car_id': _from_car_id,
      'to_car_id': car_id,
      'data': jsonx,
    };
    print('data will save is ${dataAdd}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_transfer),
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

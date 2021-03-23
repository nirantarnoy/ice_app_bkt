import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/transferout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferoutData with ChangeNotifier {
  final String url_to_out_list =
      //     "http://192.168.1.120/icesystem/frontend/web/api/transfer/outlist";
      "http://192.168.60.118/icesystem/frontend/web/api/transfer/outlist";
  final String url_to_in_list =
      //   "http://192.168.1.120/icesystem/frontend/web/api/transfer/inlist";
      "http://192.168.60.118/icesystem/frontend/web/api/transfer/inlist";
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

  Future<dynamic> fetTransferout() async {
    String _current_route_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _current_route_id = prefs.getString('emp_route_id');
    }

    final Map<String, dynamic> filterData = {'route_id': _current_route_id};
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
              to_order_no: res['data'][i]['to_order_no'].toString());

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
}

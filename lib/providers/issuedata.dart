import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueData with ChangeNotifier {
  final String url_to_issue_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/journalissue/list";
      //  "http://119.59.100.74/icesystem/frontend/web/api/journalissue/list";
      "http://119.59.100.74/icesystem/frontend/web/api/journalissue/list";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";

  List<Issueitems> _issue;
  List<Issueitems> get listissue => _issue;
  bool _isLoading = false;
  bool _isApicon = false;

  List<TransferProduct> _transferProducts;
  List<TransferProduct> get transferproductitems => _transferProducts;

  int _avl_qty = 0;
  int _id = 0;
  int get idIssue => _id;

  set idIssue(int val) {
    _id = val;
    notifyListeners();
  }

  set listissue(List<Issueitems> val) {
    _issue = val;
    notifyListeners();
  }

  set transferproductitems(List<TransferProduct> val) {
    _transferProducts = val;
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
    listissue.forEach((paymentitem) {
      total += double.parse(paymentitem.avl_qty);
    });
    return total;
  }

  Future<dynamic> fetIssueitems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_issue_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data customer length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Issueitems.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Issueitems issueresult = Issueitems(
            line_issue_id: res['data'][i]['id'].toString(),
            issue_id: res['data'][i]['issue_id'].toString(),
            issue_no: res['data'][i]['issue_no'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            product_image: res['data'][i]['image'].toString(),
            qty: res['data'][i]['issue_qty'].toString(),
            price: res['data'][i]['price'].toString(),
            avl_qty: res['data'][i]['avl_qty'].toString(),
          );

          //  print('data from server is ${issueresult}');
          data.add(issueresult);
        }

        listissue = data;

        _isLoading = false;
        notifyListeners();
        return listissue;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<dynamic> fetTransferitems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_issue_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<TransferProduct> data = [];
        print('data transfer length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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

        for (var i = 0; i < res['data'].length; i++) {
          final TransferProduct transferitem = TransferProduct(
            id: res['data'][i]['product_id'].toString(),
            code: res['data'][i]['product_name'].toString(),
            name: res['data'][i]['product_name'].toString(),
            sale_price: res['data'][i]['price'].toString(),
          );
          data.add(transferitem);
        }

        transferproductitems = data;
        _isLoading = false;
        notifyListeners();
        return transferproductitems;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }
}

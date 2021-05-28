import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueData with ChangeNotifier {
  final String url_to_issue_list_open =
      "http://119.59.100.74/icesystem/frontend/web/api/journalissue/checkopen";

  final String url_to_issue_list =
      "http://119.59.100.74/icesystem/frontend/web/api/journalissue/list";
  final String url_to_user_confirm =
      "http://119.59.100.74/icesystem/frontend/web/api/journalissue/issueconfirm";

  List<Issueitems> _issue;
  List<Issueitems> get listissue => _issue;
  bool _isLoading = false;
  bool _isApicon = false;

  List<TransferProduct> _transferProducts;
  List<TransferProduct> get transferproductitems => _transferProducts;

  int _avl_qty = 0;
  int _id = 0;
  int _transferouttotal = 0;
  bool _hasissue_open = false;
  int _user_confirm = 0;

  bool get hasissue_open => _hasissue_open;
  int get idIssue => _id;

  int get userconfirm => _user_confirm;
  set userconfirm(int val) {
    _user_confirm = val;
    notifyListeners();
  }

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

  set hasissue_open(bool val) {
    _hasissue_open = val;
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

  Future<Null> resetqty() {
    _transferouttotal = 0;
  }

  double get transferouttotal {
    double total = 0;
    _transferProducts.forEach((item) {
      total += double.parse(item.qty);
    });
    return total;
  }

  // Future<bool> fetIssueitemopen() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String _issue_date = new DateTime.now().toString();
  //   String _routeid = '';
  //   if (prefs.getString('user_id') != null) {
  //     _routeid = prefs.getString('emp_route_id');
  //   }
  //   final Map<String, dynamic> filterData = {
  //     'route_id': _routeid,
  //     'issue_date': _issue_date
  //   };
  //   print(filterData);
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     http.Response response;
  //     response = await http.post(
  //       Uri.encodeFull(url_to_issue_list_open),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(filterData),
  //     );

  //     if (response.statusCode == 200) {
  //       _isApicon = true;
  //       Map<String, dynamic> res = json.decode(response.body);

  //       print('data customer length is ${res["data"].length}');
  //       print('data server is ${res["data"]}');

  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return false;
  //       }

  //       if (res['data'] == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return false;
  //       }

  //       String has_record = '';
  //       String has_status = '';
  //       for (var i = 0; i < res['data'].length; i++) {
  //         has_record = res['data'][i]['has_record'].toString();
  //         has_status = res['data'][i]['status'].toString();
  //       }

  //       if (has_record == "1" && has_status == "1") {
  //         hasissue_open = true;
  //       }
  //       _isLoading = false;
  //       notifyListeners();
  //       return hasissue_open;
  //     }
  //   } catch (_) {
  //     _isApicon = false;
  //     print('cannot connect api.');
  //   }
  // }

  Future<dynamic> fetIssueitems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date,
      'company_id': _company_id,
      'branch_id': _branch_id
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
          idIssue = int.parse(res['data'][i]['issue_id'].toString());

          if (res['data'][i]['status'].toString() == "1") {
            userconfirm = 0;
          } else if (res['data'][i]['status'].toString() == "2") {
            userconfirm = 1;
          }
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
            issue_status: res['data'][i]['status'].toString(),
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

  Future<bool> issueconfirm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _userid = '';
    if (prefs.getString('user_id') != null) {
      _userid = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> updateData = {
      'user_id': _userid,
      'issue_id': idIssue,
      'company_id': _company_id,
      'branch_id': _branch_id
    };

    print(updateData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.encodeFull(url_to_user_confirm),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data confirm length is ${res["data"].length}');
        print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        for (var i = 0; i < res['data'].length; i++) {
          if (res['data'][i]['id'].toString() == "1") {
            return true;
          } else {
            return false;
          }
        }
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
      return false;
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
            qty: '0',
            sale_price: res['data'][i]['price'].toString(),
            avl_qty: res['data'][i]['avl_qty'].toString(),
            issue_ref_id: res['data'][i]['issue_id'].toString(),
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

  Future<dynamic> updateTotalUp(String product_id, String qty) {
    _transferProducts.forEach((element) {
      if (product_id == element.id) {
        element.qty = qty;
      }
    });
    notifyListeners();
  }

  Future<dynamic> updateTotalDown(String product_id, String qty) {
    _transferProducts.forEach((element) {
      if (product_id == element.id) {
        element.qty = qty;
      }
    });
    notifyListeners();
  }
}

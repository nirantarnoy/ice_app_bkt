import 'dart:convert';
import 'dart:io';
import "package:async/async.dart";
import 'package:ice_app_new/models/addchecklist.dart';
import 'package:ice_app_new/models/checklist.dart';
import 'package:ice_app_new/models/customer_boot.dart';

import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/customer_asset.dart';

import 'package:ice_app_new/models/customers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerData with ChangeNotifier {
  final String url_to_customer_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/customer/list";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/list";
  //"http://103.253.73.108/icesystem/frontend/web/api/customer/list";
  final String url_to_customer_boot_list =
      //  "http://192.168.1.120/icesystem/frontend/web/api/customer/list";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/bootlist";
  //"http://103.253.73.108/icesystem/frontend/web/api/customer/list";
  final String url_to_customer_detail =
      // "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/detail";

  final String url_to_customer_asset =
      // "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/assetlist";
  final String url_to_asset_change_photo =
      // "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/updatephoto";
  final String url_to_asset_checklist_save =
      // "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/assetchecklist";
  final String url_to_asset_checklist =
      // "http://203.203.1.224/icesystem/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystem/frontend/web/api/customer/checklist";

  List<Customers> _customer;
  List<CustomerAsset> _customer_asset;
  List<Checklist> _assetchecklist;
  List<Customers> get listcustomer => _customer;
  List<CustomerAsset> get listcustomerasset => _customer_asset;
  List<Checklist> get listassetchecklist => _assetchecklist;

  List<Customerboot> _customer_boot;
  List<Customerboot> get listcustomer_boot => _customer_boot;

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

  set listcustomerboot(List<Customerboot> val) {
    _customer_boot = val;
    notifyListeners();
  }

  set listcustomerasset(List<CustomerAsset> val) {
    _customer_asset = val;
    notifyListeners();
  }

  set listassetchecklist(List<Checklist> val) {
    _assetchecklist = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetCustomers() async {
    String _current_route_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _current_route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'route_id': _current_route_id,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_customer_list),
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

        for (var i = 0; i < res['data'].length; i++) {
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

  Future<List> findCustomer(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listcustomer
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<List> findCustomerboot(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listcustomer_boot
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<dynamic> fetCustomerAsset(String customer_id) async {
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'customer_id': customer_id,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    // _isLoading = true;
    print('data to find asset is ${filterData}');
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_customer_asset),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<CustomerAsset> data = [];
        print('data customer length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Customers.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final CustomerAsset assetresult = CustomerAsset(
            id: res['data'][i]['id'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            status: res['data'][i]['status'].toString(),
            photo: res['data'][i]['photo'].toString(),
          );

          print('data asset from server is ${assetresult.product_id}');
          data.add(assetresult);
        }

        listcustomerasset = data;
        _isLoading = false;
        notifyListeners();
        return listcustomerasset;
      }
    } catch (_) {}
  }

  Future<dynamic> fetCustomerboot() async {
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_customer_boot_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Customerboot> data = [];
        print('data customer boot length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Customers.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Customerboot customerresult = Customerboot(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
          );

          //  print('data from server is ${customerresult}');
          data.add(customerresult);
        }

        listcustomerboot = data;
        _isLoading = false;
        notifyListeners();
        return listcustomer_boot;
      }
    } catch (_) {}
  }

  Future<dynamic> addChecklist(List<String> image, List<Addchecklist> listcheck,
      String _customer_id, String _product_id, String _location) async {
    String _company_id = "";
    String _branch_id = "";
    String _route_id = "";
    String _user_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
    }

    // var stream =
    //     new http.ByteStream(DelegatingStream.typed(imagefile.openRead()));
    // var length = await imagefile.length();

    var jsonx = listcheck
        .map((e) => {
              'id': e.id,
              'is_check': e.is_check,
            })
        .toList();

    // var imagelist = image.map((e) => {

    // }).toList();

    final Map<String, dynamic> filterData = {
      'company_id': _company_id,
      'branch_id': _branch_id,
      'customer_id': _customer_id,
      'product_id': _product_id,
      'image': image,
      'name': '',
      'route_id': _route_id,
      'user_id': _user_id,
      'datalist': jsonx,
      'location': _location,
    };
    // _isLoading = true;
    print('data to save checklist is ${image.length}');
    //  notifyListeners();
    //print('image path is ${imagefile.path}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_asset_checklist_save),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<CustomerAsset> data = [];
        print('data checklist save length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  Future<dynamic> fetChecklist() async {
    // String _current_route_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      // _current_route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      //'route_id': _current_route_id,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_asset_checklist),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Checklist> data = [];
        print('data checklist length is ${res["data"].length}');
        //    print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final Checklist checklistresult = Checklist(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
          );
          data.add(checklistresult);
        }

        listassetchecklist = data;
        _isLoading = false;
        notifyListeners();
        return listassetchecklist;
      }
    } catch (_) {}
  }
}

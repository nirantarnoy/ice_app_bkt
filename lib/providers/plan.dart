import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/addorder.dart';

import 'package:ice_app_new/models/plan.dart';
import 'package:ice_app_new/models/plan_detail.dart';
import 'package:ice_app_new/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanData with ChangeNotifier {
  final String server_api = "";
  final String url_to_plan =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/list";
      "http://119.59.100.74/icesystem/frontend/web/api/plan/listplan";
  final String url_to_add_plan =
      "http://119.59.100.74/icesystem/frontend/web/api/plan/addplan";
  final String url_to_delete_plan =
      "http://119.59.100.74/icesystem/frontend/web/api/plan/deleteplan";
  //  "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorderline";
  final String url_to_plan_by_customer =
      "http://119.59.100.74/icesystem/frontend/web/api/plan/listplanbycustomer";

  ///// for common
  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;
  int _line_id = 0;

  String _planCustomerId = "0";
  String _searchbycustomer = '';

  ///// for order
  List<Plan> _plan;
  List<Plan> get listplan => _plan;

  int get idPlan => _id;

  set idPlan(int val) {
    _id = val;
    notifyListeners();
  }

  String get planCustomerId => _planCustomerId;
  String get searchBycustomer => _searchbycustomer;

  set planCustomerId(String val) {
    _planCustomerId = val;
    notifyListeners();
  }

  set searchBycustomer(String val) {
    _searchbycustomer = val;
    notifyListeners();
  }

  set listplan(List<Plan> val) {
    _plan = val;
    notifyListeners();
  }

  ///// for order detail

  List<PlanDetail> _plandetail;
  List<PlanDetail> get listplan_detail => _plandetail;

  int get idOrderline => _line_id;

  set idOrderline(int val) {
    _line_id = val;
    notifyListeners();
  }

  set listplan_detail(List<PlanDetail> val) {
    _plandetail = val;
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
    if (listplan_detail.isNotEmpty) {
      listplan_detail.forEach((planItem) {
        if (planItem.status != '500') {
          total += double.parse(planItem.qty);
        }
      });
    }
    return total;
  }

  double get sumqtydetail {
    double total = 0.0;
    listplan_detail.forEach((detailitem) {
      if (detailitem.status != '500') {
        total += double.parse(detailitem.qty);
      }
    });
    return total;
  }

  Plan findById(String id) {
    return listplan.firstWhere((order) => order.route_id == id);
  }

  Future<dynamic> fetPlan() async {
    String _car_id;
    String _route_id;
    String _plan_date = new DateTime.now().toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _car_id = prefs.getString('emp_car_id');
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'car_id': _car_id,
      'plan_date': _plan_date,
      'searchcustomer': _searchbycustomer,
    };
    print('data fetch plan is ${filterData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_plan),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Plan> data = [];
        print('data length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          idPlan = int.parse(res['data'][i]['id'].toString());
          final Plan orderresult = Plan(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['trans_no'].toString(),
            route_id: res['data'][i]['route_id'].toString(),
            route_name: res['data'][i]['route_name'].toString(),
            trans_date: res['data'][i]['trans_date'].toString(),
            status: res['data'][i]['status'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
          );

          data.add(orderresult);
        }

        listplan = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listplan;
      }
    } catch (_) {
      _isApicon = false;
      print('order cannot fetch data');
    }
  }

  Future<bool> addPlan(
    String product_id,
    String qty,
    String price,
    String customer_id,
    String issue_id,
    String payment_type_id,
  ) async {
    String _user_id = "";
    String _route_id = "";
    String _car_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
      _car_id = prefs.getString('emp_car_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> orderData = {
      'payment_type_id': payment_type_id,
      'order_date': _order_date,
      'product_id': product_id,
      'customer_id': customer_id,
      'qty': qty,
      'price': price,
      'user_id': _user_id,
      'issue_id': issue_id,
      'route_id': _route_id,
      'car_id': _car_id,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    print('data will save is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_plan),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added order is  ${res["data"]}');
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      print('cannot create order');
    }
    return _iscomplated;
  }

  Future<dynamic> getCustomerDetails() async {
    _isLoading = true;
    notifyListeners();
    // String _order_date = new DateTime.now().toString();
    final Map<String, dynamic> filterData = {
      'plan_id': idPlan.toString(),
      'customer_id': planCustomerId
    };
    print('plan customer data ${filterData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_plan_by_customer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<PlanDetail> data = [];
        print('data order by customer is ${res["data"]}');
        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return null;
        }
        for (var i = 0; i < res['data'].length; i++) {
          final PlanDetail orderlineresult = new PlanDetail(
            id: res['data'][i]['id'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            status: res['data'][i]['status'].toString(),
          );

          data.add(orderlineresult);
        }

        listplan_detail = data;
        _isLoading = false;
        notifyListeners();
        return listplan_detail;
      }
    } catch (_) {}
  }

  // void removeOrderCustomer(String order_id, String customer_id) async {
  //   // listorder.remove(id);
  //   // print('remove order');
  //   final Map<String, dynamic> delete_id = {
  //     'order_id': order_id,
  //     'customer_id': customer_id
  //   };

  //   print('remove data is ${delete_id}');

  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.encodeFull(url_to_delete_order_customer),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(delete_id));

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       print('data delete length is ${res["data"]}');
  //     }
  //   } catch (_) {
  //     print('cannot remove order');
  //   }
  //   print('remove order customer $customer_id');
  //   notifyListeners();
  // }

  // void removeOrderDetail(String line_id) async {
  //   final Map<String, dynamic> delete_id = {'id': line_id};

  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.encodeFull(url_to_delete_order_detail),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(delete_id));

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       print('data delete length is ${res["data"]}');
  //     }
  //   } catch (_) {}
  //   print('remove order line $line_id');
  //   notifyListeners();
  // }
}

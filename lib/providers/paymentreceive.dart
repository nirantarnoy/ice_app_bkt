import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/customerpaymentlist.dart';
import 'package:ice_app_new/models/paymentdaily.dart';
import 'package:ice_app_new/models/paymenthistory.dart';
import 'package:ice_app_new/models/paymentselected.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ice_app_new/models/paymentreceive.dart';

class PaymentreceiveData with ChangeNotifier {
  final String url_to_payment_list =
      //   "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/list";
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/list";
  // "http://103.13.28.31/icesystem/frontend/web/api/product/list";
  // final String url_to_add_payment =
  //     //    "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/addpay";
  //     "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/addpay";
  final String url_to_add_payment2 =
      //    "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/addpay";
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/addpay2";
  final String url_to_delete_payment_line =
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/deletepay";
  //  "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/deletepay";
  //
  //
  //
  final String url_to_payment_daily =
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/paymentdaily";
  final String url_to_payment_history =
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/paymenthistory";
  final String url_to_payment_history_cancel =
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/paymentcancel";
  final String url_to_customer_payment_list =
      "http://103.13.28.31/icesystem/frontend/web/api/paymentreceive/paymentcustomerlist";

  List<Paymentreceive> _paymentreceive;
  List<Paymentreceive> get listpaymentreceive => _paymentreceive;

  List<Paymentdaily> _paymentreceivedaily;
  List<Paymentdaily> get listpaymentreceivedaily => _paymentreceivedaily;

  List<Paymenthistory> _paymenthistory;
  List<Paymenthistory> get listpaymenthistory => _paymenthistory;

  List<CustomerPaymentList> _customerpaymentlist;
  List<CustomerPaymentList> get listcustomerpayment => _customerpaymentlist;

  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;
  int _datalength = 0;

  double _daiylypaytotal;
  double get dailypaytotal => _daiylypaytotal;

  int get datalength => _datalength;

  set datalength(int val) {
    _datalength = val;
  }

  int get idPaymentreceive => _id;

  set idPaymentreceive(int val) {
    _id = val;
    notifyListeners();
  }

  set listpaymentreceive(List<Paymentreceive> val) {
    _paymentreceive = val;
    notifyListeners();
  }

  set listpaymentreceivedaily(List<Paymentdaily> val) {
    _paymentreceivedaily = val;
    notifyListeners();
  }

  set listpaymenthistory(List<Paymenthistory> val) {
    _paymenthistory = val;
    notifyListeners();
  }

  set listcustomerpayment(List<CustomerPaymentList> val) {
    _customerpaymentlist = val;
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
    listpaymentreceive.forEach((paymentitem) {
      total += double.parse(paymentitem.remain_amount);
    });
    return total;
  }

  double get totalPayment {
    double total = 0.0;
    listpaymentreceivedaily.forEach((paymentitem) {
      total += double.parse(paymentitem.payment_amount);
    });
    return total;
  }

  int get orderStatus {
    int status_order = 0;
    listpaymentreceivedaily.forEach((paymentitem) {
      status_order += int.parse(paymentitem.order_status);
    });
    return status_order;
  }

  set dailypaytotal(double val) {
    _daiylypaytotal = val;
    notifyListeners();
  }

  double get sumPayment {
    double total = 0.0;
    listpaymenthistory.forEach((element) {
      total += double.parse(element.payment_amount);
    });
    return total;
  }

  Future<dynamic> fetPaymentreceive(String customer_id) async {
    final Map<String, dynamic> filterData = {'customer_id': customer_id};
    print("find by customer is ${customer_id}");
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_payment_list),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Paymentreceive> data = [];
        // print('data length is ${res["data"].length}');
        print('data payment is ${res["data"]}');

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

        datalength = res['data'].length;
        for (var i = 0; i < res['data'].length; i++) {
          // var product = Paymentreceive.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Paymentreceive productresult = Paymentreceive(
            order_id: res['data'][i]['order_id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            customer_code: res['data'][i]['customer_code'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            line_total: res['data'][i]['line_total'].toString(),
            remain_amount: res['data'][i]['remain_amount'].toString(),
          );

          print('data from server is ${productresult}');
          data.add(productresult);
        }

        listpaymentreceive = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listpaymentreceive;
      } else {
        print('not status 200');
      }
    } catch (_) {
      _isApicon = false;
      print('call api error');
    }
  }

  // Future<bool> addPayment(String order_id, String customer_id,
  //     String pay_channel_id, String pay_amount, String pay_date) async {
  //   String _company_id = "";
  //   String _branch_id = "";
  //   String _user_id = "";
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('user_id') != null) {
  //     _company_id = prefs.getString('company_id');
  //     _branch_id = prefs.getString('branch_id');
  //     _user_id = prefs.getString('user_id');
  //   }
  //   final Map<String, dynamic> payData = {
  //     'order_id': order_id,
  //     'payment_channel_id': pay_channel_id,
  //     'customer_id': customer_id,
  //     'pay_amount': pay_amount,
  //     'pay_date': pay_date,
  //     'company_id': _company_id,
  //     'branch_id': _branch_id,
  //     'user_id': _user_id
  //   };

  //   print('save payment is $payData');

  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.parse(url_to_add_payment),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(payData));
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       print('data add order is  ${res["data"]}');
  //     }
  //   } catch (_) {}
  // }

  Future<bool> addPayment2(String pay_channel_id, String pay_date,
      List<Paymentselected> paymentlist) async {
    String _company_id = "";
    String _branch_id = "";
    String _user_id = "1";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _user_id = prefs.getString('user_id');
    }
    var jsonx = paymentlist
        .map((e) => {
              'order_id': e.order_id,
              'customer_id': e.customer_id,
              'pay_amount': e.order_amount
            })
        .toList();
    final Map<String, dynamic> payData = {
      'payment_channel_id': pay_channel_id,
      'pay_date': pay_date,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'user_id': _user_id,
      'data': jsonx
    };

    print('save payment is $payData');

    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_payment2),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payData));
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data add payment is  ${res["data"]}');
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  void removePayline(String line_id) async {
    final Map<String, dynamic> delete_id = {
      'id': line_id,
    };

    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_delete_payment_line),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');
      }
    } catch (_) {}
    print('remove order line');
    notifyListeners();
  }

  Future<dynamic> fetPaymentdaily() async {
    String route_id = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('emp_route_id') != null) {
      route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> payData = {
      'route_id': route_id,
    };
    print("find by route is ${route_id}");
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_payment_daily),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payData));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Paymentdaily> data = [];
        // print('data length is ${res["data"].length}');
        print('data payment is ${res["data"]}');

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

        datalength = res['data'].length;
        for (var i = 0; i < res['data'].length; i++) {
          // var product = Paymentreceive.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Paymentdaily productresult = Paymentdaily(
            payment_amount: res['data'][i]['payment_amount'].toString(),
            order_status: res['data'][i]['order_close_status'].toString(),
          );

          print('data from server is ${productresult}');
          data.add(productresult);
        }

        listpaymentreceivedaily = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listpaymentreceivedaily;
      } else {
        print('not status 200');
      }
    } catch (_) {
      _isApicon = false;
      print('call api error');
    }
  }

  Future<dynamic> fetPaymenthistory() async {
    String _route_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {'route_id': _route_id};
    //  print("find by customer is ${customer_id}");
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_payment_history),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Paymenthistory> data = [];
        // print('data length is ${res["data"].length}');
        print('data payment is ${res["data"]}');

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

        datalength = res['data'].length;
        for (var i = 0; i < res['data'].length; i++) {
          // var product = Paymentreceive.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Paymenthistory productresult = Paymenthistory(
            payment_id: res['data'][i]['payment_id'].toString(),
            payment_date: res['data'][i]['journal_date'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            order_id: res['data'][i]['order_id'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            payment_amount: res['data'][i]['amount'].toString(),
            status: res['data'][i]['status'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
          );

          print('data from server is ${productresult}');
          data.add(productresult);
        }

        listpaymenthistory = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listpaymenthistory;
      } else {
        print('not status 200');
      }
    } catch (_) {
      _isApicon = false;
      print('call api error');
    }
  }

  Future<bool> paymentcancel(
      String payment_id, String order_id, String amount) async {
    final Map<String, dynamic> filterdata = {
      'payment_id': payment_id,
      'order_id': order_id,
      'amount': amount,
    };
    print('data cancel is ${filterdata}');
    //  return false;
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_payment_history_cancel),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterdata));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data cancel length is ${res["data"]}');
        return true;
      }
    } catch (_) {
      return false;
    }

    notifyListeners();
  }

  Future<dynamic> fetchCustomerpaymentlist() async {
    String route_id = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('emp_route_id') != null) {
      route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> payData = {
      'route_id': route_id,
    };
    print("find customer payment by route is ${route_id}");
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_customer_payment_list),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payData));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<CustomerPaymentList> data = [];
        // print('data length is ${res["data"].length}');
        print('data customer payment is ${res["data"]}');

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

        datalength = res['data'].length;
        for (var i = 0; i < res['data'].length; i++) {
          final CustomerPaymentList productresult = CustomerPaymentList(
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            remain_amt: res['data'][i]['remain'].toString(),
          );

          print('data from server is ${productresult}');
          data.add(productresult);
        }

        listcustomerpayment = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listcustomerpayment;
      } else {
        print('not status 200');
      }
    } catch (_) {
      _isApicon = false;
      print('call api error');
    }
  }
}

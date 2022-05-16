import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/order_discount.dart';

import 'package:ice_app_new/models/orders.dart';
import 'package:ice_app_new/models/order_detail.dart';
import 'package:ice_app_new/models/orders_new.dart';
import 'package:ice_app_new/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderData with ChangeNotifier {
  final String server_api = "";
  final String url_to_order =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/list";
      "http://103.253.73.108/icesystem/frontend/web/api/order/listnew";
  final String url_to_order_detail =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/listbycustomer";
      "http://103.253.73.108/icesystem/frontend/web/api/order/listbycustomer";
  final String url_to_order_discount =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/listbycustomer";
      "http://103.253.73.108/icesystem/frontend/web/api/order/orderdiscount";
  final String url_to_add_order =
      "http://103.253.73.108/icesystem/frontend/web/api/order/addorder";
  final String url_to_add_order_new =
      "http://103.253.73.108/icesystem/frontend/web/api/order/addordernew";
  // "http://192.168.1.120/icesystem/frontend/web/api/order/addorder";
  final String url_to_add_order_transfer =
      "http://103.253.73.108/icesystem/frontend/web/api/order/addordertransfer";
  // "http://192.168.1.120/icesystem/frontend/web/api/order/addorder";
  final String url_to_update_order =
      "http://103.253.73.108/icesystem/frontend/web/api/order/updateorder";
  //   "http://192.168.1.120/icesystem/frontend/web/api/order/updateorder";
  final String url_to_delete_order_customer =
      //    "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorder";
      "http://103.253.73.108/icesystem/frontend/web/api/order/deleteordercustomer";
  final String url_to_update_order_detail =
      //   "http://192.168.1.120/icesystem/frontend/web/api/order/updateorderdetail";
      "http://103.253.73.108/icesystem/frontend/web/api/order/updateorderdetail";
  final String url_to_delete_order_detail =
      "http://103.253.73.108/icesystem/frontend/web/api/order/deleteorderline";
  final String url_to_close_order =
      "http://103.253.73.108/icesystem/frontend/web/api/order/closeorder";
  final String url_to_cancel_order =
      "http://103.253.73.108/icesystem/frontend/web/api/order/cancelorder";
  //  "http://192.168.1.120/icesystem/frontend/web/api/order/deleteorderline";

  ///// for common
  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;
  int _line_id = 0;
  String _order_status = '1';

  String _orderCustomerId = "0";
  String _searchbycustomer = '';

  ///// for order
  List<OrdersNew> _order;
  List<OrdersNew> get listorder => _order;

  List<OrderDiscount> _order_discount;
  List<OrderDiscount> get listorder_discount => _order_discount;

  int get idOrder => _id;

  set idOrder(int val) {
    _id = val;
    notifyListeners();
  }

  String get orderCustomerId => _orderCustomerId;
  String get searchBycustomer => _searchbycustomer;

  set orderCustomerId(String val) {
    _orderCustomerId = val;
    notifyListeners();
  }

  set searchBycustomer(String val) {
    _searchbycustomer = val;
    notifyListeners();
  }

  set listorder(List<OrdersNew> val) {
    _order = val;
    notifyListeners();
  }

  set listorder_discount(List<OrderDiscount> val) {
    _order_discount = val;
    notifyListeners();
  }

  ///// for order detail

  List<OrderDetail> _orderdetail;
  List<OrderDetail> get listorder_detail => _orderdetail;

  int get idOrderline => _line_id;

  set idOrderline(int val) {
    _line_id = val;
    notifyListeners();
  }

  set listorder_detail(List<OrderDetail> val) {
    _orderdetail = val;
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
    if (listorder.isNotEmpty) {
      listorder.forEach((orderItem) {
        if (orderItem.order_line_status != '500') {
          total += double.parse(orderItem.line_total);
        }
      });
    }
    return total;
  }

  double get cashTotalAmount {
    double total = 0.0;
    if (listorder.isNotEmpty) {
      listorder
          .where((items) => items.payment_method_id == "1")
          .forEach((orderItem) {
        if (orderItem.order_line_status != '500') {
          total += double.parse(orderItem.line_total);
        }
      });
    }
    return (total - sumcashdiscount);
  }

  double get creditTotalAmount {
    double total = 0.0;
    if (listorder.isNotEmpty) {
      listorder
          .where((items) => items.payment_method_id == "2")
          .forEach((orderItem) {
        if (orderItem.order_line_status != '500') {
          total += double.parse(orderItem.line_total);
        }
      });
    }
    return (total - sumcreditdiscount);
  }

  double get cashTotalQty {
    double total = 0.0;
    if (listorder.isNotEmpty) {
      listorder
          .where((items) => items.payment_method_id == "1")
          .forEach((orderItem) {
        if (orderItem.order_line_status != '500') {
          total += double.parse(orderItem.qty);
        }
      });
    }
    return total;
  }

  double get creditTotalQty {
    double total = 0.0;
    if (listorder.isNotEmpty) {
      listorder
          .where((items) => items.payment_method_id == "2")
          .forEach((orderItem) {
        if (orderItem.order_line_status != '500') {
          total += double.parse(orderItem.qty);
        }
      });
    }
    return total;
  }

  double get sumqtydetail {
    double total = 0.0;
    listorder_detail.forEach((detailitem) {
      if (detailitem.order_line_status != '500') {
        total += double.parse(detailitem.qty);
      }
    });
    return total;
  }

  double get sumamoutdetail {
    double total = 0.0;
    listorder_detail.forEach((detailitem) {
      if (detailitem.order_line_status != '500') {
        total += double.parse(detailitem.price) * double.parse(detailitem.qty);
      }
    });
    return total;
  }

  double get sumcashdiscount {
    double total = 0;
    listorder_discount.forEach((discount) {
      total = double.parse(discount.discount_cash_amount);
    });
    return total;
  }

  double get sumcreditdiscount {
    double total = 0;
    listorder_discount.forEach((discount) {
      total = double.parse(discount.discount_credit_amount);
    });
    return total;
  }

  OrdersNew findById(String id) {
    return listorder.firstWhere((order) => order.customer_id == id);
  }

  Future<dynamic> fetOrders() async {
    String _car_id;
    String _order_date = new DateTime.now().toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _car_id = prefs.getString('emp_car_id');
    }
    final Map<String, dynamic> filterData = {
      'car_id': _car_id,
      'order_date': _order_date,
      'searchcustomer': _searchbycustomer,
    };
    print('data fetch order is ${filterData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<OrdersNew> data = [];
        print('data length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          idOrder = int.parse(res['data'][i]['id'].toString());
          final OrdersNew orderresult = OrdersNew(
            id: res['data'][i]['id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_code: res['data'][i]['customer_code'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            price: res['data'][i]['price'].toString(),
            qty: res['data'][i]['qty'].toString(),
            line_total: res['data'][i]['line_total'].toString(),
            payment_method_id:
                res['data'][i]['sale_payment_method_id'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            order_line_id: res['data'][i]['order_line_id'].toString(),
            order_line_date: res['data'][i]['order_line_date'].toString(),
            order_line_status: res['data'][i]['order_line_status'].toString(),
            // discount_amount: res['data'][i]['discount_amount'].toString(),
          );

          data.add(orderresult);
        }

        listorder = data;
        _isLoading = false;
        _isApicon = true;
        notifyListeners();
        return listorder;
      }
    } catch (_) {
      _isApicon = false;
      print('order cannot fetch data');
    }
  }

  Future<dynamic> fetOrderDiscount() async {
    String _route_id;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _route_id,
    };
    print('data fetch order discount is ${filterData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order_discount),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<OrderDiscount> data = [];
        print('data discount length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final OrderDiscount orderresult = OrderDiscount(
            discount_cash_amount:
                res['data'][i]['discount_cash_amount'].toString(),
            discount_credit_amount:
                res['data'][i]['discount_credit_amount'].toString(),
          );

          data.add(orderresult);
        }

        listorder_discount = data;
        _isLoading = false;
        notifyListeners();
        return listorder_discount;
      }
    } catch (_) {
      _isApicon = false;
      print('order cannot fetch data');
    }
  }
  // Future<dynamic> fetOrders() async {
  //   String _car_id;
  //   String _order_date = new DateTime.now().toString();
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('user_id') != null) {
  //     _car_id = prefs.getString('emp_car_id');
  //   }
  //   final Map<String, dynamic> filterData = {
  //     'car_id': _car_id,
  //     'order_date': _order_date
  //   };
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.encodeFull(url_to_order),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(filterData));

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       List<Orders> data = [];
  //       print('data length is ${res["data"].length}');
  //       //  print('data is ${res["data"]}');

  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return;
  //       }

  //       for (var i = 0; i < res['data'].length; i++) {
  //         idOrder = int.parse(res['data'][i]['id'].toString());
  //         final Orders orderresult = Orders(
  //           id: res['data'][i]['id'].toString(),
  //           order_no: res['data'][i]['order_no'].toString(),
  //           order_date: res['data'][i]['order_date'].toString(),
  //           customer_id: res['data'][i]['customer_id'].toString(),
  //           customer_code: res['data'][i]['customer_code'].toString(),
  //           customer_name: res['data'][i]['customer_name'].toString(),
  //           total_amount: res['data'][i]['total_amount'].toString(),
  //           payment_method: res['data'][i]['payment_method'].toString(),
  //           payment_method_id:
  //               res['data'][i]['sale_payment_method_id'].toString(),
  //           total_qty: res['data'][i]['total_qty'].toString(),
  //         );

  //         data.add(orderresult);
  //       }

  //       listorder = data;
  //       _isLoading = false;
  //       _isApicon = true;
  //       notifyListeners();
  //       return listorder;
  //     }
  //   } catch (_) {
  //     _isApicon = false;
  //     print('order cannot fetch data');
  //   }
  // }

  Future<bool> addOrder(
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
    //  print('data will save is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        //   print('data added order is  ${res["data"]}');
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<bool> addOrderNew(
    String customer_id,
    List<Addorder> listdata,
    String pay_type,
    String discount,
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

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
              'price': e.sale_price,
              'price_group_id': e.price_group_id,
            })
        .toList();

    final Map<String, dynamic> orderData = {
      'payment_type_id': pay_type,
      'order_date': _order_date,
      'customer_id': customer_id,
      'user_id': _user_id,
      'route_id': _route_id,
      'car_id': _car_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
      'discount': discount,
    };
    print('data will save order new is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_order_new),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added order is  ${res["data"]}');
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<void> addOrderFromtransfer(
    String product_id,
    String qty,
    String price,
    String customer_id,
    String transfer_id,
  ) async {
    String _user_id = "";
    String _route_id = "";
    String _car_id = "";

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
      _car_id = prefs.getString('emp_car_id');
    }

    final Map<String, dynamic> orderData = {
      'order_date': _order_date,
      'product_id': product_id,
      'customer_id': customer_id,
      'qty': qty,
      'price': price,
      'user_id': _user_id,
      'transfer_id': transfer_id,
      'route_id': _route_id,
      'car_id': _car_id,
      'issue_id': '',
      'transfer_id': transfer_id,
    };
    print(orderData);
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_order_transfer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data add order is  ${res["data"]}');
      }
    } catch (_) {
      print('cannot create order');
    }
  }

  Future<dynamic> getCustomerDetails() async {
    _isLoading = true;
    notifyListeners();
    // String _order_date = new DateTime.now().toString();
    final Map<String, dynamic> filterData = {
      'order_id': idOrder.toString(),
      'customer_id': orderCustomerId
    };
    print('order customer data ${filterData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_order_detail),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<OrderDetail> data = [];
        print('data order by customer is ${res["data"]}');
        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return null;
        }
        for (var i = 0; i < res['data'].length; i++) {
          final OrderDetail orderlineresult = new OrderDetail(
            order_id: res['data'][i]['order_id'].toString(),
            order_no: res['data'][i]['order_no'].toString(),
            order_date: res['data'][i]['order_date'].toString(),
            line_id: res['data'][i]['line_id'].toString(),
            customer_id: res['data'][i]['customer_id'].toString(),
            customer_code: res['data'][i]['customer_code'].toString(),
            customer_name: res['data'][i]['customer_name'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            qty: res['data'][i]['qty'].toString(),
            price: res['data'][i]['price'].toString(),
            price_group_id: res['data'][i]['price_group_id'].toString(),
            order_line_status: res['data'][i]['order_line_status'].toString(),
            discount_amount: res['data'][i]['order_discount_amt'].toString(),
          );

          data.add(orderlineresult);
        }

        listorder_detail = data;
        _isLoading = false;
        notifyListeners();
        return listorder_detail;
      }
    } catch (_) {}
  }

  void removeOrderCustomer(String order_id, String customer_id) async {
    // listorder.remove(id);
    // print('remove order');
    final Map<String, dynamic> delete_id = {
      'order_id': order_id,
      'customer_id': customer_id
    };

    print('remove data is ${delete_id}');

    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_delete_order_customer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');
      }
    } catch (_) {
      print('cannot remove order');
    }
    print('remove order customer $customer_id');
    notifyListeners();
  }

  void removeOrderDetail(String line_id) async {
    final Map<String, dynamic> delete_id = {'id': line_id};

    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_delete_order_detail),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');
      }
    } catch (_) {}
    print('remove order line $line_id');
    notifyListeners();
  }

  Future<bool> closeOrder(String is_return_stock) async {
    bool completed = false;
    //String _order_date = new DateTime.now().toString();
    String _company_id = "";
    String _branch_id = "";
    String _user_id = "";
    String _route_id = "";
    String _return_stock = is_return_stock;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> orderData = {
      'order_id': idOrder,
      'route_id': _route_id,
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'return_stock': _return_stock
    };
    print('data will save close order is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_close_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data close order is  ${res["data"]}');
        completed = true;
      }
    } catch (_) {
      print('cannot close order');
    }
    print(completed);
    return completed;
  }

  Future<bool> cancelOrder(
      String line_id,
      String customer_id,
      String customer_code,
      String order_no,
      String product_code,
      String reanson) async {
    bool completed = false;
    //String _order_date = new DateTime.now().toString();
    String _company_id = "";
    String _branch_id = "";
    String _route_name = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _route_name = prefs.getString('emp_route_name');
    }
    final Map<String, dynamic> orderData = {
      'line_id': line_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'customer_id': customer_id,
      'customer_code': customer_code,
      'order_no': order_no,
      'product_code': product_code,
      'route_name': _route_name,
      'reason': reanson
    };
    print('data will cancel order is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_cancel_order),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data cancel order is  ${res["data"]}');
        completed = true;
      }
    } catch (_) {
      print('cannot cancel order');
    }
    print(completed);
    return completed;
  }
}

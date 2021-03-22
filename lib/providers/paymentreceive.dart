import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/paymentreceive.dart';

class PaymentreceiveData with ChangeNotifier {
  final String url_to_payment_list =
      "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/list";
  //   "http://192.168.60.118/icesystem/frontend/web/api/product/list";
  // "http://119.59.100.74/icesystem/frontend/web/api/product/list";
  final String url_to_add_payment =
      "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/addpay";
  final String url_to_delete_payment_line =
      "http://192.168.1.120/icesystem/frontend/web/api/paymentreceive/deletepay";

  List<Paymentreceive> _paymentreceive;
  List<Paymentreceive> get listpaymentreceive => _paymentreceive;
  bool _isLoading = false;
  bool _isApicon = true;
  int _id = 0;
  int get idPaymentreceive => _id;

  set idPaymentreceive(int val) {
    _id = val;
    notifyListeners();
  }

  set listpaymentreceive(List<Paymentreceive> val) {
    _paymentreceive = val;
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

  Future<dynamic> fetPaymentreceive() async {
    final Map<String, dynamic> filterData = {'customer_id': 1};
    // _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_payment_list),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(filterData));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Paymentreceive> data = [];
        // print('data length is ${res["data"].length}');
        // print('data server is ${res["data"]}');

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

        for (var i = 0; i < res['data'].length - 1; i++) {
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

          //print('data from server is ${productresult}');
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

  Future<bool> _addPayment(String order_id, String customer_id,
      String pay_channel_id, String pay_amount) async {
    final Map<String, dynamic> payData = {
      'order_id': order_id,
      'payment_channel_id': pay_channel_id,
      'customer_id': customer_id,
      'pay_amount': pay_amount
    };

    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_add_payment),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payData));
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data add order is  ${res["data"]}');
      }
    } catch (_) {}
  }

  void removePayline(String line_id) async {
    final Map<String, dynamic> delete_id = {
      'id': line_id,
    };

    try {
      http.Response response;
      response = await http.post(Uri.encodeFull(url_to_delete_payment_line),
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
}

import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/orders.dart';

mixin ConnectedOrdersModel on Model {
  String _selOrderId;
  List<Orders> _orders = [];
  Orders _dataOrders;
  bool _isLoading = false;
  // final url = "http://192.168.1.103/school/backend/web/index.php?r=site/apilogin";http://localhost/testapi/login.php
  //final url_orders = "http://192.168.1.103/school/frontend/web/api/user/exam";
  // final url_orders = "http://192.168.1.103/school/frontend/web/api/user/news";
  final url_product =
      "http://192.168.1.101/icesystem/backend/web/index.php?r=member/get-order";
}

mixin OrdersModel on ConnectedOrdersModel {
  Orders get orders {
    return _dataOrders;
  }

  List<Orders> get allorders {
    return List.from(_orders);
  }

  List<Orders> get displayedOrders {
    return List.from(_orders);
  }

  int get selectedOrderIndex {
    return _orders.indexWhere((Orders orders) {
      return orders.id == _selOrderId;
    });
  }

  String get selectedOrderId {
    return _selOrderId;
  }

  Orders get selectedOrders {
    if (selectedOrderId == null) {
      return null;
    }

    return _orders.firstWhere((Orders Orders) {
      return Orders.id == _selOrderId;
    });
  }

  bool get is_order_load {
    return _isLoading;
  }

  Future<Null> fetchOrders({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> currStudent = {'student_id': "1"};

    http.Response response;
    if (1 > 0) {
      response = await http.post(
        Uri.encodeFull(url_product),
        body: json.encode(currStudent),
        headers: {'Content-Type': 'application/json'},
      );
    }
    print("api status: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("api status: ${response.body}");

      final List<Orders> fetchedOrderList = [];
      final Map<String, dynamic> orderListData = json.decode(response.body);
      print("data news: ${orderListData['data'][0]}");
      if (orderListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      for (int i = 0; i <= orderListData['data'].length - 1; i++) {
        //print(newstListData['data'][i]['subject_code']);
        final Orders orderresult = Orders(
          id: orderListData['data'][i]['id'],
          order_no: orderListData['data'][i]['order_no'],
          customer_name: orderListData['data'][i]['customer_name'],
          order_date: orderListData['data'][i]['order_date'],
          note: orderListData['data'][i]['note'],
        );
        fetchedOrderList.add(orderresult);
      }
      // newstListData['data'][0].forEach((String id, dynamic examData) {
      // print(examData);
      // final Examresult examresult = Examresult(
      //     id: '1',
      //     subject_code: examData[i]['subject_code'],
      //     subject_name: examData[i]['subject_name'],
      //     score: examData[i]['score'],
      //     grade: examData[i]['grade'],
      //     max_score: '100');
      //     i+=1;
      // fetchedNewsList.add(examresult);
      //});
      _orders = fetchedOrderList;
      print(_orders.length);
      _isLoading = false;
      notifyListeners();
    }

    // return http.post(Uri.encodeFull(urls),body: json.encode(currStudent), headers: {'Content-Type': 'application/json'}).then<Null>((http.Response response) {
    //   print(response.statusCode);

    // }).catchError((error) {
    //   print(error);
    //   _isLoading = false;
    //   notifyListeners();
    //   return;
    // });
  }

  void selectOrder(String orderId) {
    _selOrderId = orderId;
    notifyListeners();
  }
}

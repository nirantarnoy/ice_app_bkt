import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/widgets/error/err_api.dart';

class OrderPage extends StatefulWidget {
  static const routeName = '/order';
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _isInit = true;
  var _isLoading = false;

  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<OrderData>(context, listen: false).fetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('No intenet', 'You are no internet connect');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  Widget _buildOrdersList() {
    return Consumer(builder: (context, OrderData orders, Widget child) {
      // orders.fetOrders();
      Widget content = Center(
          child: Text(
        'ไม่พบข้อมูล!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
      ));
      // print("data length = " + products.listproduct.toString());
      if (orders.is_apicon) {
        if (!orders.is_loading) {
          content = Container(child: OrderItem());
        } else if (orders.is_loading) {
          content = Center(child: CircularProgressIndicator());
        }
      } else {
        content = ErrorApi();
      }
      return RefreshIndicator(
        onRefresh: orders.fetOrders,
        child: Container(child: OrderItem()),
      );
    });
  }

  // Widget _openPopup(context) {
  //   Alert(
  //       context: context,
  //       title: "บันทึกรายการขาย",
  //       content: Column(
  //         children: <Widget>[
  //           TextField(
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.account_circle),
  //               labelText: 'Username',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //         ],
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             "บันทึก",
  //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //         )
  //       ]).show();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // persistentFooterButtons: <Widget>[
        //   new Text(
        //     'ยอดรวม',
        //     style: TextStyle(fontSize: 20),
        //   ),
        //   new Text(
        //     '25,000',
        //     style: TextStyle(fontSize: 20, color: Colors.orange),
        //   ),
        //   new Text(
        //     'บาท',
        //     style: TextStyle(fontSize: 20),
        //   ),
        // ],
        body: _buildOrdersList(),
      ),
    );
  }
}

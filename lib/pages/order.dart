import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }

    super.initState();
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
    final OrderData orders = Provider.of<OrderData>(context);
    orders.fetOrders();
    Widget content = Center(
        child: Text(
      'ไม่พบข้อมูล!',
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
    ));
    print("data length = " + orders.listorder.length.toString());
    if (orders.listorder.length > 0 && !orders.is_loading) {
      content = Container(child: OrderItem());
    } else if (orders.is_loading) {
      content = Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: orders.fetOrders,
      child: content,
    );
  }

  Widget _openPopup(context) {
    Alert(
        context: context,
        title: "บันทึกรายการขาย",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                // icon: Icon(Icons.account_circle),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "บันทึก",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:ice_app/helpers/activity_connection.dart';
import 'package:ice_app/widgets/order/order_item.dart';
import 'package:ice_app/widgets/order/order_product_item.dart';
import '../scoped-models/main.dart';

class OrderPage extends StatefulWidget {
  final MainModel model;

  OrderPage(this.model);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  initState() {
    _checkinternet();
    try{
       widget.model.fetchOrders();
    } on TimeoutException catch(_){
        _showdialog('Noity', 'Connection time out!');
    }
   
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
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
            child: Text(
          'ไม่พบข้อมูล!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
        ));
        print("data length = " + model.displayedOrders.length.toString());
        if (model.displayedOrders.length > 0 && !model.is_order_load) {
          content = OrderItem();
        } else if (model.is_order_load) {
          content = Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: model.fetchOrders,
          child: content,
        );
      },
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
      // appBar: AppBar(
      //     title: Text(
      //   'ตรวจสอบผลการเรียน',
      //   style: TextStyle(fontWeight: FontWeight.bold),
      // )),
      // persistentTopButtons: <Widget>[
      //   new IconButton(icon: new Icon(Icons.timer), onPressed: () => ''),
      //   new IconButton(icon: new Icon(Icons.people), onPressed: () => ''),
      //   new IconButton(icon: new Icon(Icons.map), onPressed: () => ''),
      // ],
      persistentFooterButtons: <Widget>[
        new Text(
          'ยอดรวม',
          style: TextStyle(fontSize: 20),
        ),
        new Text(
          '25,000',
          style: TextStyle(fontSize: 20, color: Colors.orange),
        ),
        new Text(
          'บาท',
          style: TextStyle(fontSize: 20),
        ),
      ],

      body: _buildOrdersList(),
    );
  }
}

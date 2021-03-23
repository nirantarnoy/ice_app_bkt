import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/widgets/payment/payment_item.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/models/paymentreceive.dart';
import 'package:ice_app_new/widgets/error/err_api.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = '/payment';
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var _isInit = true;
  var _isLoading = false;

  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchpayments();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetpayments();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PaymentreceiveData>(context, listen: false)
          .fetPaymentreceive()
          .then((_) {
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

  Widget _buildpaymentsList() {
    return Consumer(
        builder: (context, PaymentreceiveData orders, Widget child) {
      //orders.fetPaymentreceive("1");
      Widget content = Center(
          child: Text(
        'ไม่พบข้อมูล!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
      ));
      // print("data length = " + products.listproduct.toString());
      if (orders.is_apicon) {
        if (!orders.is_loading) {
          content = Container(child: PaymentItem());
        } else if (orders.is_loading) {
          content = Center(child: CircularProgressIndicator());
        }
      } else {
        content = ErrorApi();
      }
      return RefreshIndicator(
        onRefresh: orders.fetPaymentreceive,
        child: Container(child: PaymentItem()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.white),
        //   // title: Text(
        //   //   "รับชำระเงิน",
        //   //   style: TextStyle(color: Colors.white),
        //   // ),
        // ),
        body: _buildpaymentsList(),
      ),
    );
  }
}

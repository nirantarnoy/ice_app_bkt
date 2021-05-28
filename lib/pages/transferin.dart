import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/transferout.dart';
import 'package:ice_app_new/providers/transferin.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:ice_app_new/widgets/transferin/transferin_item.dart';
import 'package:ice_app_new/widgets/error/err_api.dart';
import 'package:ice_app_new/widgets/error/err_internet_con.dart';
import '../pages/error.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';

class TransferinPage extends StatefulWidget {
  @override
  _JournalissuePageState createState() => _JournalissuePageState();
}

class _JournalissuePageState extends State<TransferinPage> {
  var _isInit = true;
  var _isLoading = false;

  Future _transferinFuture;
  Future _obtainTransferinFuture() {
    return Provider.of<TransferinData>(context, listen: false).fetTransferin();
  }

  @override
  initState() {
    ActivityCon();
    _transferinFuture = _obtainTransferinFuture();
    //_checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TransferinData>(context, listen: false)
          .fetTransferin()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _buildProductList() {
    return Consumer(
        builder: (context, TransferinData transferinitems, Widget child) {
      //transferinitems.fetTransferinitems();
      Widget content = Center(
          child: Text(
        'ไม่พบข้อมูล!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
      ));
      // print("data length = " + products.listproduct.toString());
      if (transferinitems.is_apicon) {
        if (transferinitems.listtransferin.length > 0 &&
            !transferinitems.is_loading) {
          content = Container(child: Transferinitem());
        } else if (transferinitems.is_loading) {
          content = Center(child: CircularProgressIndicator());
        }
      } else {
        content = ErrorApi();
      }

      return RefreshIndicator(
        onRefresh: transferinitems.fetTransferin,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildProductList(),
      ),
    );
  }
}

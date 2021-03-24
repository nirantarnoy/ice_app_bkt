import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitems.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:ice_app_new/widgets/transferout/transferout_item.dart';
import 'package:ice_app_new/widgets/error/err_api.dart';
import 'package:ice_app_new/widgets/error/err_internet_con.dart';
import '../pages/error.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';

class TransferoutPage extends StatefulWidget {
  @override
  _JournalissuePageState createState() => _JournalissuePageState();
}

class _JournalissuePageState extends State<TransferoutPage> {
  var _isInit = true;
  var _isLoading = false;
  @override
  initState() {
    ActivityCon();
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
      Provider.of<TransferoutData>(context, listen: false)
          .fetTransferout()
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
        builder: (context, TransferoutData issueitems, Widget child) {
      //issueitems.fetIssueitems();
      Widget content = Center(
          child: Text(
        'ไม่พบข้อมูล!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
      ));
      // print("data length = " + products.listproduct.toString());
      if (issueitems.is_apicon) {
        if (issueitems.listtransferout.length > 0 && !issueitems.is_loading) {
          content = Container(child: Transferoutitem());
        } else if (issueitems.is_loading) {
          content = Center(child: CircularProgressIndicator());
        }
      } else {
        content = ErrorApi();
      }

      return RefreshIndicator(
        onRefresh: issueitems.fetTransferout,
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
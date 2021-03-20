import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitems.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/widgets/journalissue/journalissue_item.dart';
import 'package:ice_app_new/widgets/error/err_api.dart';
import 'package:ice_app_new/widgets/error/err_internet_con.dart';
import '../pages/error.dart';

import 'package:ice_app_new/helpers/activity_connection.dart';

class JournalissuePage extends StatefulWidget {
  @override
  _JournalissuePageState createState() => _JournalissuePageState();
}

class _JournalissuePageState extends State<JournalissuePage> {
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
      Provider.of<IssueData>(context, listen: false).fetIssueitems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // Future<void> _checkinternet() async {
  //   var result = await Connectivity().checkConnectivity();

  //   if (result == ConnectivityResult.none) {
  //     _showdialog('พบข้อผิดพลาด!',
  //         'กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตของคุณแล้วลองอีกครั้ง');
  //   } else if (result == ConnectivityResult.mobile) {
  //     //_showdialog('Intenet access', 'You are connect mobile data');
  //   }
  //   if (result == ConnectivityResult.wifi) {
  //     //_showdialog('Intenet access', 'You are connect wifi');
  //   }
  // }

  // _showdialog(title, text) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(title),
  //           content: Text(text),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('ok'))
  //           ],
  //         );
  //       });
  // }

  // Widget _buildProductList() {
  //   final IssueData issueitems = Provider.of<IssueData>(context, listen: false);
  //   issueitems.fetIssueitems();
  //   Widget content = Center(
  //       child: Text(
  //     'ไม่พบข้อมูล!',
  //     style: TextStyle(
  //         fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //   ));
  //   // print("data length = " + products.listproduct.toString());
  //   if (issueitems.listissue.length > 0 && !issueitems.is_loading) {
  //     content = Container(child: Journalissueitem());
  //   } else if (issueitems.is_loading) {
  //     content = Center(child: CircularProgressIndicator());
  //   }

  //   return RefreshIndicator(
  //     onRefresh: issueitems.fetIssueitems,
  //     child: content,
  //   );
  // }

  Widget _buildProductList() {
    return Consumer(builder: (context, IssueData issueitems, Widget child) {
      //issueitems.fetIssueitems();
      Widget content = Center(
          child: Text(
        'ไม่พบข้อมูล!',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
      ));
      // print("data length = " + products.listproduct.toString());
      if (issueitems.is_apicon) {
        if (issueitems.listissue.length > 0 && !issueitems.is_loading) {
          content = Container(child: Journalissueitem());
        } else if (issueitems.is_loading) {
          content = Center(child: CircularProgressIndicator());
        }
      } else {
        content = ErrorApi();
      }

      return RefreshIndicator(
        onRefresh: issueitems.fetIssueitems,
        child: content,
      );
    });
  }

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
        body: _buildProductList(),
        // body: Text('Product Data'),
      ),
    );
  }
}

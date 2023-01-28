import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:ice_app_new/pages/createorder.dart';
// import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/createplan.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/providers/plan.dart';
import 'package:ice_app_new/widgets/plan/plan_item.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

//import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

//import 'package:ice_app_new/widgets/error/err_api.dart';

class PlanPage extends StatefulWidget {
  static const routeName = '/plan';
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  var _isInit = true;
  var _isLoading = false;

  Future _orderFuture;

  Future _obtainOrderFuture() {
    Provider.of<PlanData>(context, listen: false).searchBycustomer = '';
    return Provider.of<PlanData>(context, listen: false).fetPlan();
  }

  @override
  initState() {
    _checkinternet();

    _orderFuture = _obtainOrderFuture();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('order didCangeDependencies');

    super.didChangeDependencies();
  }

  void refreshData() {
    setState(() {
      _orderFuture = _obtainOrderFuture();
    });
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('พบปัญหา', 'ไม่สามารถเชื่อมต่ออินเตอร์เน็ตได้');
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ตกลง'))
            ],
          );
        });
  }

  Widget _buidorderlist() {
    PlanData plans = Provider.of<PlanData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _orderFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: PlanItem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: plans.fetPlan,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('build context created');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'รายการสั่งซื้อวัดถัดไป',
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(MainTest());
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(CreateplanPage.routeName);
                },
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: _buidorderlist(),
      ),
    );
  }
}

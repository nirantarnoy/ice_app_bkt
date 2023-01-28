import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/page_offline/createorder_new_offline.dart';
//import 'package:ice_app_new/pages/createorder.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:ice_app_new/sqlite/widgets/orders/order_item_offline_new.dart';
//import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:ice_app_new/widgets/order/order_item_new.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

//import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';
//import 'package:ice_app_new/widgets/error/err_api.dart';

class OrderofflinePage extends StatefulWidget {
  static const routeName = '/orderoffline';
  @override
  _OrderofflinePageState createState() => _OrderofflinePageState();
}

class _OrderofflinePageState extends State<OrderofflinePage>
    with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;

  bool _networkisok = false;

  bool _showBackToTopButton = false;
  ScrollController _scrollController;

  Future _orderFuture;

  Future _obtainOrderFuture() {
    Provider.of<OrderData>(context, listen: false).searchBycustomer = '';
    return Provider.of<OrderData>(context, listen: false).fetOrders();
  }

  @override
  initState() {
    // _checkinternet();
    showalltable();
    _orderFuture = _obtainOrderFuture();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            print('offset is ${_scrollController.offset}');
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
            print('offset is ${_scrollController.offset}');
          }
        });
      });
    // setState(() {
    //   _isLoading = true;
    // });
    // Future.delayed(Duration.zero).then((_) async {
    //   await Provider.of<OrderData>(context, listen: false)
    //       .fetOrders()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // });
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetOrders();
    super.initState();
  }

  Future showalltable() async {
    List<String> tables = await DbHelper.instance.getAllTableNames();

    print('table all are ${tables}');
  }

  @override
  void didChangeDependencies() {
    print('order didCangeDependencies');
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
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
      setState(() {
        _networkisok = false;
      });
      _showdialog('พบปัญหา', 'กรุณาตรวจสอบการเชื่อมต่อ หรือ ใช้งานโหมดออฟไลน์');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
      setState(() {
        _networkisok = true;
      });
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
      setState(() {
        _networkisok = true;
      });
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

  // Widget _buildOrdersList() {
  //   return Consumer(builder: (context, OrderData orders, Widget child) {
  //     // orders.fetOrders();
  //     Widget content = Center(
  //         child: Text(
  //       'ไม่พบข้อมูล!',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //     ));
  //     // print("data length = " + products.listproduct.toString());
  //     if (orders.is_apicon) {
  //       content = FutureBuilder(
  //           future: ,
  //           builder: (context, dataSnapshort) => {
  //                 if (dataSnapshort.connectionState == ConnectionState.waiting)
  //                   {
  //                     Center(child: CircularProgressIndicator()),
  //                   }else{

  //                   }
  //               });

  //       // if (_isLoading == true) {
  //       //   print("Page is loading");
  //       //   content = Center(child: CircularProgressIndicator());
  //       // } else {
  //       //   // content = Center(child: CircularProgressIndicator());
  //       //   content = Container(child: OrderItem());
  //       // }
  //     } else {
  //       content = ErrorApi();
  //     }
  //     //return content;
  //     return RefreshIndicator(
  //       onRefresh: orders.fetOrders,
  //       child: content,
  //     );
  //   });
  // }

  Widget _buidorderlist() {
    OrderData orders = Provider.of<OrderData>(context, listen: false);
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
            return Container(child: OrderOfflineItemNew());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: orders.fetOrders,
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
              'รายการขายสินค้า [OFFLINE]',
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
                    //  Navigator.of(context).pushNamed(CreateorderNewOfflinePage.routeName);
                    Navigator.of(context)
                        .pushNamed(CreateorderNewOfflinePage.routeName);
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
          body: _buidorderlist()),
    );
  }
}

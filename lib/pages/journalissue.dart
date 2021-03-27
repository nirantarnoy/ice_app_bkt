import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/home.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/transfer.dart';
import 'package:ice_app_new/pages/transferin.dart';
import 'package:ice_app_new/pages/transferout.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:ice_app_new/widgets/transferout/transferout_item.dart';
import 'package:intl/intl.dart';
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

  Future _issueFuture;
  Future _transferoutFuture;

  Future _obtainIssueFuture() {
    return Provider.of<IssueData>(context, listen: false).fetIssueitems();
  }

  Future _obtaintransferoutFuture() {
    return Provider.of<TransferoutData>(context, listen: false)
        .fetTransferout();
  }

  @override
  initState() {
    _issueFuture = _obtainIssueFuture();
    _transferoutFuture = _obtaintransferoutFuture();
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
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<IssueData>(context, listen: false).fetIssueitems().then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(JournalissuePage oldWidget) {
    print('didUpdate()');
    super.didUpdateWidget(oldWidget);
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
    IssueData issues = Provider.of<IssueData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _issueFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: Journalissueitem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: issues.fetIssueitems,
    );
  }

  Widget _buildProductinList() {
    IssueData issues = Provider.of<IssueData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _issueFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: Journalissueitem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: issues.fetIssueitems,
    );
  }

  Widget _buildProductoutList() {
    TransferoutData transferout =
        Provider.of<TransferoutData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _transferoutFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: Transferoutitem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: transferout.fetTransferout,
    );
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              title: Text(
                'รายการสินค้า',
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
              bottom: TabBar(
                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.move_to_inbox),
                    text: 'สินค้าเบิก',
                  ),
                  Tab(
                    icon: Icon(Icons.arrow_circle_down_rounded),
                    text: 'รับโอนสินค้า',
                  ),
                  Tab(
                    icon: Icon(Icons.arrow_circle_up_rounded),
                    text: 'โอนสินค้า',
                  ),
                ],
              )),
          body: TabBarView(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildProductList()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildProductinList()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildProductoutList()),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

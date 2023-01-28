import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitems.dart';
// import 'package:ice_app_new/pages/home.dart';
import 'package:ice_app_new/pages/main_test.dart';
// import 'package:ice_app_new/pages/transfer.dart';
// import 'package:ice_app_new/pages/transferin.dart';
import 'package:ice_app_new/pages/transferinpage.dart';
// import 'package:ice_app_new/pages/transferout.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:ice_app_new/sqlite/models/product.dart';
import 'package:ice_app_new/sqlite/providers/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
// import 'package:ice_app_new/widgets/transferin/transferin_item.dart';
import 'package:ice_app_new/widgets/transferout/transferout_item.dart';
import 'package:intl/intl.dart';
// import 'package:ice_app_new/models/issueitems.dart';

// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/widgets/journalissue/journalissue_item.dart';
// import 'package:ice_app_new/widgets/error/err_api.dart';
// import 'package:ice_app_new/widgets/error/err_internet_con.dart';
// import '../pages/error.dart';

// import 'package:ice_app_new/helpers/activity_connection.dart';

class JournalissuePage extends StatefulWidget {
  static const routeName = '/journalissue';
  @override
  _JournalissuePageState createState() => _JournalissuePageState();
}

class _JournalissuePageState extends State<JournalissuePage> {
  var _isInit = true;
  var _isLoading = false;

  bool _networkisok = false;

  // Future _hasopenFuture;
  Future _ishasissue;
  Future _issueFuture;
  Future _transferoutFuture;
  Future _transferinFuture;
  Future _oldstockroutefuture;

  // Future _obtainHasopenFuture() {
  //   return Provider.of<IssueData>(context, listen: false).fetIssueitemopen();
  // }

  Future _obtainHasIssueFuture() {
    return Provider.of<IssueData>(context, listen: false).fetIssueitemopen();
  }

  Future _obtainIssueFuture() {
    return Provider.of<IssueData>(context, listen: false).fetIssueitems();
  }

  Future _obtaintransferoutFuture() {
    return Provider.of<TransferoutData>(context, listen: false)
        .fetTransferout();
  }

  Future _obtaintransferinFuture() {
    return Provider.of<TransferinData>(context, listen: false)
        .fetTransferincheck();
  }

  Future _obtainoldstockrouteFuture() {
    return Provider.of<IssueData>(context, listen: false).fetoldstockroute();
  }

  @override
  initState() {
    _checkinternet();
    // _hasopenFuture = _obtainHasopenFuture();
    _ishasissue = _obtainHasIssueFuture();
    _issueFuture = _obtainIssueFuture();
    _transferoutFuture = _obtaintransferoutFuture();
    _transferinFuture = _obtaintransferinFuture();

    _callapiissuedata(); //call for offline stock

    //  _oldstockroutefuture = _obtainoldstockrouteFuture();

    //_callDb();

    super.initState();
  }

  Future _callapiissuedata() async {
    print("hello niran");
    List<Issueitems> issue_daily =
        await Provider.of<IssueData>(context, listen: false).listissue;
    print('issue daily is ${issue_daily.length}');
    if (issue_daily != null) {
      issue_daily.forEach((element) async {
        int checkhasitem = await DbHelper.instance.checkhasproductinissuedata(
            element.product_id); // check already product in sqlite
        if (checkhasitem <= 0) {
          final Product product_data = Product(
            id: element.product_id,
            code: element.product_name,
            name: element.product_name,
            qty: element.avl_qty,
            issue_id: int.parse(element.issue_id),
            createdTime: DateTime.now(),
            price_group_id: 0,
            route_id: 0,
          );
          if (product_data != null) {
            print("data will save for offline");
            await DbHelper.instance.createProduct(product_data);
          }
        } else {
          await DbHelper.instance.upateProductStock(element.product_id, "10");
          print("has already product offlne");
        }
      });
    } else {
      print("no data in product offline");
    }
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
      _networkisok = true;
    }
  }

  // Future _callDb() async {
  //   int chk_db = await DbHelper.instance.checkDB();
  //   print(chk_db);
  // }

  // Future deleteData() async {
  //   await DbHelper.instance.deleteProductAll();
  // }

  // Future callapidata() async {
  //   await Provider.of<CustomerpriceData>(context, listen: false)
  //       .fetpriceonline();
  //   // List<Issueitems> issue_daily =
  //   //     await Provider.of<IssueData>(context, listen: false).listissue;
  //   // print('issue daily is ${issue_daily.length}');
  //   // if (issue_daily != null) {
  //   //   issue_daily.forEach((element) async {
  //   //     final Product product_data = Product(
  //   //       id: element.product_id,
  //   //       code: element.product_name,
  //   //       name: element.product_name,
  //   //       qty: element.avl_qty,
  //   //       issue_id: int.parse(element.issue_id),
  //   //       createdTime: DateTime.now(),
  //   //       price_group_id: 0,
  //   //       route_id: 0,
  //   //     );

  //   //     if (product_data != null) {
  //   //       await DbHelper.instance.createProduct(product_data);
  //   //     }
  //   //   });
  //   // }
  // }

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
    // print('didUpdate()');
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
    TransferinData issues = Provider.of<TransferinData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _transferinFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: TransferinNewPage());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: issues.fetTransferincheck,
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
            ),
          ),
          body: _networkisok == true
              ? TabBarView(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
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
                ])
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                    ),
                    Icon(
                      Icons.wifi_off_outlined,
                      size: 100,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(child: Text('ไม่พบสัญญาณอินเตอร์เน็ต'))
                  ],
                ),
        ),
      ),
    );
  }
}

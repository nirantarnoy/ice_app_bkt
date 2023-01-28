import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:ice_app_new/widgets/transferin/findtransferin_item.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
//import 'package:ice_app_new/widgets/error/err_api.dart';

class TransferinNewPage extends StatefulWidget {
  static const routeName = '/transferinpage';
  @override
  _TransferinPageState createState() => _TransferinPageState();
}

class _TransferinPageState extends State<TransferinNewPage> {
  var _isInit = true;
  var _isLoading = false;

  Future _transferFuture;

  Future _obtainTransferinFuture() {
    return Provider.of<TransferinData>(context, listen: false)
        .fetTransferincheck();
  }

  @override
  initState() {
    _checkinternet();
    _transferFuture = _obtainTransferinFuture();
    super.initState();
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

  void refreshData() {
    setState(() {
      _transferFuture = _obtainTransferinFuture();
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

  // Widget _buildfindtransfersList() {
  //   return Consumer(builder: (context, TransferinData findtransfers, Widget child) {
  //     // findtransfers.fetfindtransfers();
  //     Widget content = Center(
  //         child: Text(
  //       'ไม่พบข้อมูล!',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //     ));
  //     // print("data length = " + products.listproduct.toString());
  //     if (findtransfers.is_apicon) {
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
  //       onRefresh: findtransfers.fetfindtransfers,
  //       child: content,
  //     );
  //   });
  // }

  Widget _buidorderlist() {
    TransferinData findtransfers =
        Provider.of<TransferinData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _transferFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: FindtransferinItem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: findtransfers.fetTransferincheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('build context created');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buidorderlist(),
      ),
    );
  }
}

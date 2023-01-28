import 'dart:async';

import 'package:flutter/material.dart';

//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

// import 'package:provider/provider.dart';
// import 'package:ice_app_new/providers/product.dart';
// import 'package:ice_app_new/widgets/product/product_item.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }

    super.initState();
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('พบข้อผิดพลาด!',
          'กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตของคุณแล้วลองอีกครั้ง');
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
                  child: Text('ok'))
            ],
          );
        });
  }

  // Widget _buildProductList() {
  //   final ProductData products =
  //       Provider.of<ProductData>(context, listen: false);
  //   products.fetProducts();
  //   Widget content = Center(
  //       child: Text(
  //     'ไม่พบข้อมูล!',
  //     style: TextStyle(
  //         fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //   ));
  //   // print("data length = " + products.listproduct.toString());
  //   if (products.listproduct.length > 0 && !products.is_loading) {
  //     content = Container(child: ProductItem());
  //   } else if (products.is_loading) {
  //     content = Center(child: CircularProgressIndicator());
  //   }

  //   return RefreshIndicator(
  //     onRefresh: products.fetProducts,
  //     child: content,
  //   );
  // }

  // Widget _buildlistFromconsumer() {
  //   return Consumer(builder: (context, ProductData products, Widget child) {
  //     Widget content = Center(
  //         child: Text(
  //       'ไม่พบข้อมูล!',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //     ));
  //     print("data length = " + products.listproduct.toString());
  //     if (products != null) {
  //       if (products.listproduct.length > 0 && !products.is_loading) {
  //         content = Container(child: ProductItem());
  //       } else if (products.is_loading) {
  //         content = Center(child: CircularProgressIndicator());
  //       }
  //     }

  //     return RefreshIndicator(
  //       onRefresh: products.fetProducts,
  //       child: content,
  //     );
  //   });
  // }

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
        //  body: _buildlistFromconsumer(),
        // body: Text('Product Data'),
      ),
    );
  }
}

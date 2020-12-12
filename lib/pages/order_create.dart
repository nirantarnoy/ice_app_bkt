import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:ice_app/widgets/order/order_product_item.dart';
import '../scoped-models/main.dart';

class OrderCreatePage extends StatefulWidget {
  final MainModel model;

  OrderCreatePage(this.model);
  @override
  _OrderCreatePageState createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildOrderProductList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
            child: Text(
          'ไม่พบข้อมูล!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
        ));
        //  print("data length = " + model.displayedProducts.length.toString());
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = OrderProductItem();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: content,
        );
      },
    );
  }

  // Widget _openPopup(context) {
  //   Alert(
  //       context: context,
  //       title: "บันทึกรายการขาย",
  //       content: Column(
  //         children: <Widget>[
  //           TextField(
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.account_circle),
  //               labelText: 'Username',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //           TextField(
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               // icon: Icon(Icons.lock),
  //               labelText: 'Password',
  //             ),
  //           ),
  //         ],
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             "บันทึก",
  //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //         )
  //       ]).show();
  // }

  @override
  Widget build(BuildContext context) {
    print('Order product item create');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'เลือกสินค้าที่ต้องการขาย',
          style: TextStyle(fontFamily: 'Cloud-Bold', color: Colors.white),
        ),
      ),
      // persistentFooterButtons: <Widget>[
      //   new IconButton(icon: new Icon(Icons.timer), onPressed: () => ''),
      //   new IconButton(icon: new Icon(Icons.people), onPressed: () => ''),
      //   new IconButton(icon: new Icon(Icons.map), onPressed: () => ''),
      // ],

      body: _buildOrderProductList(),
    );
  }
}

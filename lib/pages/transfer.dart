import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/order.dart';
import 'package:ice_app_new/pages/payment.dart';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // title: Text('รับโอนสินค้า'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.move_to_inbox),
                  text: 'โอนสินค้า',
                ),
                Tab(
                  icon: Icon(Icons.transit_enterexit_sharp),
                  text: 'รับโอนสินค้า',
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[OrderPage(), PaymentPage()]),
        ));
  }
}

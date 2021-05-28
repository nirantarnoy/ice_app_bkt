import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/transferout.dart';
import 'package:ice_app_new/pages/transferin.dart';

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
            iconTheme: IconThemeData(color: Colors.white),
            // title: Text('รับโอนสินค้า'),
            bottom: TabBar(
              labelColor: Colors.white,
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
          body: TabBarView(children: <Widget>[
            TransferinPage(),
            TransferoutPage(),
          ]),
        ));
  }
}

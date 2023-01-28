import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/models/offlineitem.dart';
import 'package:ice_app_new/sqlite/db_helper.dart';
import 'package:ice_app_new/sqlite/providers/Offlineitem.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class OfflinePage extends StatefulWidget {
  static const routeName = '/offlinepage';

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  List<Map<String, dynamic>> queryRows;
  List<Map<String, dynamic>> queryModel;

  @override
  void initState() {
    super.initState();
    // print('hello');
    readSQLite();
  }

  Future<dynamic> readSQLite() async {
    var obj = await DatabaseHelper.instance.queryAll();
    setState(() {});
    queryModel = obj;
    print('data is ${queryModel}');
  }

  Widget _buildlist() {
    Widget listcard;
    listcard = new ListView.builder(
        itemCount: queryModel.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {},
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "${queryModel[index]['id'].toString()}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text("${queryModel[index]['name'].toString()}"),
                ),
                Divider(),
              ],
            ),
          );
        });
    return listcard;
  }

  // Widget _buildlist(List<Offlineitem> items) {
  //   Widget productCards;
  //   if (items.isNotEmpty) {
  //     if (items.length > 0) {
  //       print("has list");
  //       productCards = new ListView.builder(
  //         itemCount: items.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           print(items[index].id.toString());
  //           return Text('niran');
  //           // return new GestureDetector(
  //           //   onTap: () {},
  //           //   child: Column(
  //           //     children: <Widget>[
  //           //       ListTile(
  //           //         title: Text(
  //           //           "${items[index].id.toString()}",
  //           //           style: TextStyle(
  //           //             fontSize: 16,
  //           //           ),
  //           //         ),
  //           //         subtitle: Text("${items[index].name.toString()}"),
  //           //       ),
  //           //       Divider(),
  //           //     ],
  //           //   ),
  //           // );
  //         },
  //       );
  //       return productCards;
  //     } else {
  //       return Center(
  //         child: Text(
  //           "ไม่พบข้อมูล",
  //           style: TextStyle(fontSize: 20, color: Colors.grey),
  //         ),
  //       );
  //     }
  //   } else {
  //     return Center(
  //       child: Text(
  //         "ไม่พบข้อมูล",
  //         style: TextStyle(fontSize: 20, color: Colors.grey),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline sale'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  int i = await DatabaseHelper.instance.insert(
                    {DatabaseHelper.columnName: 'niranxxx'},
                  );

                  print('the inserted id is');
                },
                child: Text('insert')),
            ElevatedButton(
                onPressed: () {
                  Provider.of<OfflineitemData>(context, listen: false)
                      .showItemlist();
                  setState(() async {
                    queryRows = await DatabaseHelper.instance.queryAll();

                    print(queryRows);
                  });
                },
                child: Text('query')),
            ElevatedButton(
                onPressed: () async {
                  int updatedId = await DatabaseHelper.instance.update(
                    {
                      DatabaseHelper.columnId: 3,
                      DatabaseHelper.columnName: 'Mark',
                    },
                  );
                  print(updatedId);
                },
                child: Text('update')),
            ElevatedButton(
              onPressed: () async {
                int updatedId = await DatabaseHelper.instance.delete(2);
                print(updatedId);
              },
              child: Text('delete'),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: _buildlist()),
            // Expanded(
            //   child: Consumer<OfflineitemData>(
            //     builder: (context, offlineitems, _) {
            //       _buildlist(offlineitems.itemlist);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

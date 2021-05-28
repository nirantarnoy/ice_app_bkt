import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:ice_app_new/sqlite/providers/Offlineitem.dart';
import 'package:ice_app_new/models/offlineitem.dart';

import '../db_helper.dart';

class OfflineitemData extends ChangeNotifier {
  List<Offlineitem> _itemlist;
  List<Offlineitem> get itemlist => _itemlist;

  set itemlist(List<Offlineitem> val) {
    _itemlist = val;
  }

  Future<dynamic> showItemlist() async {
    List<Offlineitem> data = [];
    List<Map<String, dynamic>> queryRows;

    queryRows = await DatabaseHelper.instance.queryAll();

    for (int i = 0; i <= queryRows.length - 1; i++) {
      //print(queryRows[i]['id']);
      final Offlineitem items = Offlineitem(
        id: queryRows[i]['id'].toString(),
        name: queryRows[i]['name'].toString(),
      );
      // print(items.id);
      data.add(items);
    }

    // queryRows.forEach((element) {
    //   final Offlineitem items = Offlineitem(
    //     id: '1',
    //     name: 'niran',
    //   );
    //   // print(items.id);
    //   data.add(items);
    // });

    itemlist = data;
    return itemlist;
    //print(queryRows);
  }
}

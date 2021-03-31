import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/Transferin.dart';
import 'package:provider/provider.dart';

import '../../models/Transferin.dart';

class Transferinitem extends StatelessWidget {
  List<Transferin> _orders = [];
  Widget _buildissueitemList(List<Transferin> _items) {
    Widget productCards;
    if (_items != null) {
      if (_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              _items[index].transfer_id.toString(),
              _items[index].journal_no.toString(),
              _items[index].from_route.toString(),
              _items[index].from_order_no.toString(),
              _items[index].from_car_no.toString(),
              _items[index].qty.toString(),
            );
          },
        );
      }

      return productCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TransferinData _transferin =
        Provider.of<TransferinData>(context, listen: false);
    // item_issues.fetIssueitems();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "รายการรับโอนสินค้า",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: _buildissueitemList(_transferin.listtransferin),
      ],
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _transfer_id;
  final String _journal_no;
  final String _from_route;
  final String _from_order_no;
  final String _from_car_no;
  final String _qty;

  Items(
    this._transfer_id,
    this._journal_no,
    this._from_route,
    this._from_order_no,
    this._from_car_no,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, '/ordersdetail/' + this._transfer_id.toString()),
      child: Column(
        children: <Widget>[
          ListTile(
            // leading: ConstrainedBox(
            //   constraints: BoxConstraints(minHeight: 100, minWidth: 100),
            //   child: Text("$_journal_no"),
            // ),
            title: Text(
              "$_journal_no",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Text("${_from_car_no}"),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            trailing: Text('$_qty',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800])),
          ),
          Divider(),
        ],
      ),
    );
  }
}

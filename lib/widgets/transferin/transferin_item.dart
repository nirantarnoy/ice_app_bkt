import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:provider/provider.dart';

import '../../models/transferout.dart';

class Transferinitem extends StatelessWidget {
  List<Transferout> _orders = [];
  Widget _buildissueitemList(List<Transferout> transferout_items) {
    Widget productCards;
    if (transferout_items != null) {
      if (transferout_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: transferout_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              transferout_items[index].transfer_id.toString(),
              transferout_items[index].journal_no.toString(),
              transferout_items[index].to_route.toString(),
              transferout_items[index].to_order_no.toString(),
              transferout_items[index].to_car_no.toString(),
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
    final TransferoutData item_transferout =
        Provider.of<TransferoutData>(context, listen: false);
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
                  "รายการโอนสินค้าหน่วยรถ",
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
        Expanded(child: _buildissueitemList(item_transferout.listtransferout)),
      ],
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _transfer_id;
  final String _journal_no;
  final String _to_route;
  final String _to_order_no;
  final String _to_car_no;

  Items(this._transfer_id, this._journal_no, this._to_route, this._to_order_no,
      this._to_car_no);
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
                Icon(Icons.directions_car),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.double_arrow,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("${_to_car_no}"),
                SizedBox(
                  width: 10,
                ),
                Text("รถ"),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${_to_car_no}",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            // trailing: Text('$_qty',
            //     style: TextStyle(
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.orange[800])
            //         ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/pages/createtransfer.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:provider/provider.dart';

import '../../models/transferout.dart';

class Transferoutitem extends StatelessWidget {
  // List<Transferout> _orders = [];
  Widget _buildissueitemList(List<Transferout> transferout_items) {
    Widget productCards;
    if (transferout_items.isNotEmpty) {
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
                transferout_items[index].qty.toString());
          },
        );
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return productCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
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
                  "โอนสินค้าออก",
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
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                margin: EdgeInsets.only(left: 15, right: 20),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "จำนวน",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.purple),
                            ),
                            SizedBox(width: 10),
                            Chip(
                              label: Consumer<TransferoutData>(
                                builder: (context, transferouts, _) => Text(
                                  transferouts.totalAmount == null
                                      ? 0
                                      : transferouts.totalAmount.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.green[400],
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatetransferPage()));
                  }),
            ),
            // Expanded(
            //   child: Card(
            //     margin: EdgeInsets.only(left: 15),
            //     child: Padding(
            //       padding: EdgeInsets.all(8),
            //       child: Column(
            //         children: <Widget>[

            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
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
  final String _qty;

  Items(
    this._transfer_id,
    this._journal_no,
    this._to_route,
    this._to_order_no,
    this._to_car_no,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
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
                Text("ทะเบียน"),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${_to_car_no}",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            trailing: Text('${formatter.format(double.parse(_qty))}',
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

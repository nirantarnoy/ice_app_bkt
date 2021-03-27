import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

import '../../models/issueitems.dart';

class Journalissueitem extends StatelessWidget {
  List<Issueitems> _orders = [];
  Widget _buildissueitemList(List<Issueitems> issue_items) {
    Widget productCards;
    if (issue_items.isNotEmpty) {
      if (issue_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: issue_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
                issue_items[index].line_issue_id.toString(),
                issue_items[index].issue_id,
                issue_items[index].product_id,
                issue_items[index].product_name.toString(),
                issue_items[index].qty,
                issue_items[index].price,
                issue_items[index].product_image,
                issue_items[index].avl_qty);
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
    final IssueData item_issues =
        Provider.of<IssueData>(context, listen: false);
    var formatter = NumberFormat('#,##,##0');
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
                Text("รายการสินค้าประจำวัน",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                // Chip(
                //   label: Text("อ้างอิง ${item_issues.listissue[0].issue_no}",
                //       style: TextStyle(color: Colors.white)),
                //   backgroundColor: Colors.purple,
                // )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Consumer<IssueData>(
            builder: (context, issues, _) => issues.listissue.isNotEmpty
                ? _buildissueitemList(issues.listissue)
                : Center(
                    child: Text(
                      "ไม่พบข้อมูล",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(15),
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
                        "สินค้าคงเหลือ",
                        style: TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                      SizedBox(width: 10),
                      Chip(
                        label: Consumer<IssueData>(
                            builder: (context, payments, _) => Text(
                                  payments.totalAmount == null
                                      ? 0
                                      : "${formatter.format(item_issues.totalAmount)}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ]),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _line_issue_id;
  final String _issue_id;
  final String _product_id;
  final String _product_name;
  final String _qty;
  final String _price;
  final String _product_image;
  final String _avl_qty;

  Items(
    this._line_issue_id,
    this._issue_id,
    this._product_id,
    this._product_name,
    this._qty,
    this._price,
    this._product_image,
    this._avl_qty,
  );
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "$_product_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Text("ราคาขาย $_price บาท"),
            trailing: Text("$_avl_qty",
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

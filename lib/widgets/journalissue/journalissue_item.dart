import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

import '../../models/issueitems.dart';

class Journalissueitem extends StatelessWidget {
  List<Issueitems> _orders = [];
  Widget _buildissueitemList(List<Issueitems> issue_items) {
    Widget productCards;
    if (issue_items != null) {
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
                issue_items[index].product_image);
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
    final IssueData item_issues =
        Provider.of<IssueData>(context, listen: false);
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
                Text("รายการสินค้าประจำวัน",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text("อ้างอิง ${item_issues.listissue[0].issue_no}",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.purple,
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: _buildissueitemList(item_issues.listissue)),
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

  Items(this._line_issue_id, this._issue_id, this._product_id,
      this._product_name, this._qty, this._price, this._product_image);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, '/ordersdetail/' + this._line_issue_id.toString()),
      child: Card(
          child: ListTile(
        leading: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100, minWidth: 100),
          child: FadeInImage.assetNetwork(
            width: 100,
            height: 100,
            placeholder: '',
            image: "$_product_image",
          ),
        ),
        title: Text(
          "$_product_name",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text("ราคาขาย $_price บาท"),
        trailing: Text('$_qty',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800])),
      )),
    );
  }
}

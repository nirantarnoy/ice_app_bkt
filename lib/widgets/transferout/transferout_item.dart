import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:provider/provider.dart';

import '../../models/transferout.dart';

class Journalissueitem extends StatelessWidget {
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
              transferout_items[index].journal_no,
              transferout_items[index].to_route,
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
                Text("รายการโอนสินค้าหน่วยรถ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

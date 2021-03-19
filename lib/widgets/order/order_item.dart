import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';

class OrderItem extends StatelessWidget {
  List<Orders> _orders = [];
  Widget _buildordersList(List<Orders> orders) {
    Widget orderCards;
    if (orders.length > 0) {
      print("has list");
      orderCards = new ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
            orders[index].id,
            orders[index].order_no,
            orders[index].customer_name,
            orders[index].order_date,
            orders[index].note,
            orders[index].total_amount,
            orders[index].payment_method_id,
            orders[index].payment_method,
          );
        },
      );
      return orderCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderData orders = Provider.of<OrderData>(context, listen: false);
    orders.fetOrders();
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "ยอดขายรวม",
                style: TextStyle(fontSize: 18, color: Colors.blue[700]),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "รายการขาย",
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Expanded(child: _buildordersList(orders.listorder)),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _id;
  final String _order_no;
  final String _customer_name;
  final String _order_date;
  final String _note;
  final String _total_amount;
  final String _payment_method;
  final String _payment_method_id;

  Items(
      this._id,
      this._order_no,
      this._customer_name,
      this._order_date,
      this._note,
      this._total_amount,
      this._payment_method_id,
      this._payment_method);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
      child: Card(
          child: ListTile(
        leading: RaisedButton(
            color: _payment_method_id == "1" ? Colors.green : Colors.blue,
            onPressed: () => {},
            child: Text(
              "$_payment_method",
              style: TextStyle(color: Colors.white),
            )),
        title: Text(
          "$_order_no $_note",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text("$_order_date ($_customer_name)"),
      )),
    );
  }
}

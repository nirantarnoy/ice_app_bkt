import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

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
              orders[index].note);
        },
      );
      return orderCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderData orders = Provider.of<OrderData>(context);
    orders.fetOrders();
    return _buildordersList(orders.listorder);
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final int _id;
  final String _order_no;
  final String _customer_name;
  final String _order_date;
  final String _note;

  Items(this._id, this._order_no, this._customer_name, this._order_date,
      this._note);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
      child: Card(
          child: ListTile(
        leading: RaisedButton(
            color: Colors.green,
            onPressed: () => {},
            child: Text(
              "เงินสด",
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

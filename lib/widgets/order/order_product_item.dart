import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/orders.dart';

class OrderProductItem extends StatelessWidget {
  List<Orders> _orders = [];
  Widget _buildordersList(List<Orders> orders) {
    Widget orderCards;
    if (orders.length > 0) {
      print("has list");
      // orderCards = GridView.count(
      //     crossAxisCount: 4,
      //     scrollDirection: Axis.horizontal,
      //     children: List.generate(orders.length, (index) {
      //       return Items(
      //           orders[index].id,
      //           orders[index].order_no,
      //           orders[index].customer_name,
      //           orders[index].order_date,
      //           orders[index].note);
      //     }));
      orderCards = new GridView.builder(
          itemCount: orders.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Items(
                orders[index].id,
                orders[index].order_no,
                orders[index].customer_name,
                orders[index].order_date,
                orders[index].note);
          });
      return orderCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[orders Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildordersList(model.allorders);
      },
    );
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
    return Container(
      child: Card(
          color: Colors.amberAccent,
          child: ListTile(
            // leading: Icon(
            //   Icons.shopping_cart_outlined,
            //   color: Colors.blueAccent,
            //   size: 50.0,
            // ),
            leading: Text(
              "$_id",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            title: Text(
              "$_order_no $_note",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text("น้ำแข็งหลอดเล็ก"),
          )),
    );
    // return new GestureDetector(
    //   onTap: () =>
    //       Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
    //   child: Card(
    //       child: ListTile(
    //     leading: Icon(
    //       Icons.shopping_cart_outlined,
    //       color: Colors.blueAccent,
    //       size: 50.0,
    //     ),
    //     title: Text(
    //       "$_order_no $_note",
    //       style: TextStyle(
    //         fontSize: 16,
    //       ),
    //     ),
    //     subtitle: Text("$_order_date ($_customer_name)"),
    //   )),
    // );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../pages/orderdetail.dart';
import '../../pages/createorder.dart';

class OrderItem extends StatelessWidget {
  List<Orders> _orders = [];

  Widget _buildordersList(List<Orders> orders) {
    Widget orderCards;
    if (orders.isNotEmpty) {
      if (orders.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) => Items(
                orders[index].id,
                orders[index].order_no,
                orders[index].customer_name,
                orders[index].order_date,
                orders[index].total_amount,
                orders[index].payment_method_id,
                orders[index].payment_method,
                orders[index].customer_id,
                orders[index].customer_code,
                orders,
                index));
        return orderCards;
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }
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
    final OrderData orders = Provider.of<OrderData>(context);
    // orders.fetOrders();
    var formatter = NumberFormat('#,##,##0.#');
    return Column(
      children: <Widget>[
        Column(children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "ยอดขาย",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    SizedBox(width: 5),
                    Chip(
                      label: Text(
                        "${formatter.format(orders.totalAmount)}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Text("บาท",
                        style: TextStyle(fontSize: 20, color: Colors.black87)),
                    FloatingActionButton(
                        backgroundColor: Colors.green[500],
                        onPressed: () => Navigator.of(context)
                            .pushNamed(CreateorderPage.routeName),
                        child: Icon(Icons.add, color: Colors.white)
                        //   ElevatedButton(onPressed: () {}, child: Text("เพิ่มรายการขาย")),
                        ),
                  ]),
            ),
          )
        ]),
        SizedBox(height: 5),
        Expanded(
          child: orders.listorder.isNotEmpty
              ? _buildordersList(null)
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _order_no;
  final String _customer_name;
  final String _customer_id;
  final String _customer_code;
  final String _order_date;
  final String _total_amount;
  final String _payment_method;
  final String _payment_method_id;
  final List<Orders> _orders;
  final int _index;

  Items(
      this._id,
      this._order_no,
      this._customer_name,
      this._order_date,
      this._total_amount,
      this._payment_method_id,
      this._payment_method,
      this._customer_id,
      this._customer_code,
      this._orders,
      this._index);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var formatter = NumberFormat('#,##,##0');

  DateFormat dateformatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget._orders[widget._index]),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('ยืนยัน'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('ไม่'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        print(widget._orders[widget._index].id);
        setState(() {
          Provider.of<OrderData>(context, listen: false)
              .removeOrderCustomer(widget._id, widget._customer_id);
          widget._orders.removeAt(widget._index);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "ทำรายการสำเร็จ",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ));
      },
      child: GestureDetector(
        onTap: () {
          var setData = Provider.of<OrderData>(context, listen: false);
          setData.idOrder = int.parse(widget._id);
          setData.orderCustomerId = widget._customer_id;
          Navigator.of(context).pushNamed(OrderDetailPage.routeName,
              arguments: {
                'customer_id': widget._customer_id,
                'order_id': widget._id
              });
        }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              // leading: RaisedButton(
              //     color:
              //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
              //     onPressed: () {},
              //     child: Text(
              //       "$_payment_method",
              //       style: TextStyle(color: Colors.white),
              //     )),
              // leading: Chip(
              //   label:
              //       Text("${_order_no}", style: TextStyle(color: Colors.white)),
              //   backgroundColor: Colors.green[500],
              // ),
              title: Text(
                "${widget._customer_name}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              subtitle: Text(
                "${widget._order_date}",
                style: TextStyle(color: Colors.cyan[700]),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${formatter.format(double.parse(widget._total_amount))}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

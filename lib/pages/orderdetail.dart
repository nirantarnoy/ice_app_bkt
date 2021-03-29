import 'package:currencies/currencies.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/models/order_detail.dart';

import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/models/orders.dart';

class OrderDetailPage extends StatefulWidget {
  static const routeName = '/orderdetail';

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  var _isInit = true;
  var _isLoading = false;

  Future _orderFuture;

  Future _obtainOrderFuture() {
    return Provider.of<OrderData>(context, listen: false).getCustomerDetails();
  }

  @override
  initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<OrderData>(context, listen: false)
    //       .getCustomerDetails()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  Widget _buildordersList(List<OrderDetail> orders) {
    var formatter2 = NumberFormat('#,##,##0');
    Widget orderCards;
    if (orders.length > 0) {
      // print("has list");
      orderCards = new ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(orders[index]),
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
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ยืนยัน'),
                    ),
                    FlatButton(
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
              print(orders[index].line_id);
              setState(() {
                Provider.of<OrderData>(context, listen: false)
                    .removeOrderDetail(orders[index].line_id);
                orders.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
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
              onTap: () {},
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Chip(
                      label: Text("${orders[index].product_code}",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange[700],
                    ),
                    title: Text(
                      "${orders[index].product_name}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "วันที่ ${orders[index].order_date}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.cyan[700]),
                            ),
                            Text(
                              "ราคาขาย ${orders[index].price}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "x${orders[index].qty}",
                          style: TextStyle(
                              color: Colors.green[500],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${formatter2.format(double.parse(orders[index].qty) * double.parse(orders[index].price))}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                                fontSize: 16)),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
      return orderCards;
    } else {
      return Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
    // final customer_order_id =
    //     ModalRoute.of(context).settings.arguments as String; // is id
    final order_data =
        ModalRoute.of(context).settings.arguments as Map; // is id

    final loadCustomerorder = Provider.of<OrderData>(context, listen: false)
        .findById(order_data['customer_id']);

    final loadordertotal = Provider.of<OrderData>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "รายละเอียด",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (context, dataSnapshort) {
          if (dataSnapshort.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshort.error != null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 80,
                              color: Theme.of(context).accentColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                loadCustomerorder.customer_code,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                  loadCustomerorder
                                                      .customer_name,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: 80,
                              color: Colors.green[500],
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'จำนวน',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${formatter.format(loadordertotal.sumqtydetail)}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 80,
                              color: Colors.purple[400],
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'จำนวนเงิน',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${formatter.format(loadordertotal.sumamoutdetail)}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "รายการขาย",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Consumer<OrderData>(
                          builder: (context, orderdetails, _) =>
                              _buildordersList(orderdetails.listorder_detail),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _order_id;
  final String _order_no;
  final String _order_date;
  final String _customer_name;
  final String _line_id;
  final String _product_id;
  final String _product_code;
  final String _product_name;
  final String _price_group_id;
  final String _qty;
  final String _price;
  Items(
      this._order_id,
      this._order_no,
      this._order_date,
      this._customer_name,
      this._line_id,
      this._product_id,
      this._product_code,
      this._product_name,
      this._price_group_id,
      this._qty,
      this._price);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderData>(
      builder: (BuildContext context, orders, Widget child) => Dismissible(
        key: ValueKey(_line_id),
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
        onDismissed: (direction) {
          setState() {
            orders.removeOrderDetail(_line_id);
          }
        },
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(OrderDetailPage.routeName),
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
                leading: Chip(
                  label: Text("${_product_code}",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.purple[700],
                ),
                title: Text(
                  "$_product_name",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                subtitle: Text(
                  "วันที่ ${_order_date}",
                  style: TextStyle(fontSize: 12, color: Colors.cyan[700]),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_qty x $_price = $_qty * $_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<OrderData>(context, listen: false)
          .getCustomerDetails("2850")
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _buildordersList(List<OrderDetail> orders) {
    Widget orderCards;
    if (orders.length > 0) {
      // print("has list");
      orderCards = new ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          // return Items(
          //   orders[index].order_id,
          //   orders[index].order_no,
          //   orders[index].order_date,
          //   orders[index].customer_name,
          //   orders[index].line_id,
          //   orders[index].product_id,
          //   orders[index].product_code,
          //   orders[index].product_name,
          //   orders[index].price_group_id,
          //   orders[index].qty,
          //   orders[index].price,
          // );
          final item = orders[index];
          return Dismissible(
            key: ValueKey(item),
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
              setState(() {
                Provider.of<OrderData>(context).removeOrderDetail(item.line_id);
                orders.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'ลบข้อมูลเรียบร้อย',
                      style: TextStyle(fontFamily: "Kanit-Regular"),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ));
            },
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(OrderDetailPage.routeName),
              child: Card(
                  child: ListTile(
                // leading: RaisedButton(
                //     color:
                //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
                //     onPressed: () {},
                //     child: Text(
                //       "$_payment_method",
                //       style: TextStyle(color: Colors.white),
                //     )),
                leading: Chip(
                  label: Text("${item.product_code}",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.purple[700],
                ),
                title: Text(
                  "${item.product_name}",
                  style: TextStyle(fontSize: 16, color: Colors.cyan),
                ),
                subtitle: Text(
                  "ราคาขาย ${item.price} วันที่ ${item.order_date}",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${item.qty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              )),
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
    final customer_order_id =
        ModalRoute.of(context).settings.arguments as String; // is id

    final loadCustomerorder = Provider.of<OrderData>(context, listen: false)
        .findById(customer_order_id);

    final OrderData orders = Provider.of<OrderData>(context, listen: false);
    //orders.getCustomerDetails(widget.customer_id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียด",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
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
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(loadCustomerorder.customer_name,
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "150",
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "150",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
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
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: _buildordersList(orders.listorder_detail))
            ],
          ),
        ),
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
          child: Card(
              child: ListTile(
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
              style: TextStyle(fontSize: 16, color: Colors.cyan),
            ),
            subtitle: Text(
              "ราคาขาย ${_price} วันที่ ${_order_date}",
              style: TextStyle(fontSize: 12),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$_qty",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

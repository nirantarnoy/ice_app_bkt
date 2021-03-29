import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<OrderData>(context, listen: false).fetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
    DateFormat dateformatter = DateFormat('dd-MM-yyyy');
    return SafeArea(
        child: Scaffold(
      body: Container(
        //  color: Theme.of(context).accentColor,
        color: Colors.lightBlue,
        child: FutureBuilder(
            future: _orderFuture,
            builder: (context, dataSnapshort) {
              if (dataSnapshort.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                if (dataSnapshort.error != null) {
                  return Center(
                    child: Text('Data is error'),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "สรุปรายการขาย",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'ขายสด',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 1.0,
                                        dashLength: 4.0,
                                        dashColor: Colors.grey,
                                        dashRadius: 0.0,
                                        dashGapLength: 4.0,
                                        dashGapColor: Colors.transparent,
                                        dashGapRadius: 0.0,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Consumer<OrderData>(
                                            builder: (context, orders, _) =>
                                                Column(
                                              children: <Widget>[
                                                Text('จำนวน'),
                                                Text(
                                                  '${formatter.format(orders.cashTotalQty)}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                VerticalDivider(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Consumer<OrderData>(
                                            builder: (context, orders, _) =>
                                                Column(
                                              children: <Widget>[
                                                Text('ยอดขาย'),
                                                Text(
                                                  '${formatter.format(orders.cashTotalAmount)}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'ขายเชื่อ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      lineLength: double.infinity,
                                      lineThickness: 1.0,
                                      dashLength: 4.0,
                                      dashColor: Colors.grey,
                                      dashRadius: 0.0,
                                      dashGapLength: 4.0,
                                      dashGapColor: Colors.transparent,
                                      dashGapRadius: 0.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Consumer<OrderData>(
                                          builder: (context, orders, _) =>
                                              Column(
                                            children: <Widget>[
                                              Text('จำนวน'),
                                              Text(
                                                '${formatter.format(orders.creditTotalQty)}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Consumer<OrderData>(
                                          builder: (context, orders, _) =>
                                              Column(
                                            children: <Widget>[
                                              Text('ยอดขาย'),
                                              Text(
                                                '${formatter.format(orders.creditTotalAmount)}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'รับชำระ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      lineLength: double.infinity,
                                      lineThickness: 1.0,
                                      dashLength: 4.0,
                                      dashColor: Colors.grey,
                                      dashRadius: 0.0,
                                      dashGapLength: 4.0,
                                      dashGapColor: Colors.transparent,
                                      dashGapRadius: 0.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text('ยอดรับชำระ'),
                                            Text(
                                              '1,240',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ข้อมูลวันที่ ${dateformatter.format(DateTime.now())}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                }
              }
            }),
      ),
    ));
  }
}

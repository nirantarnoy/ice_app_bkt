import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/providers/product.dart';

import 'package:fluttertoast/fluttertoast.dart';

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
    _checkinternet();
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('พบปัญหา', 'ไม่สามารถเชื่อมต่ออินเตอร์เน็ตได้');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ตกลง'))
            ],
          );
        });
  }

  Widget _buildclosebutton() {
    return RaisedButton(
        elevation: 5,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0)),
        color: Colors.white,
        child: new Text('จบการขาย',
            style: new TextStyle(fontSize: 20.0, color: Colors.blue[700])),
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('ยืนยัน'),
              content: Text('ต้องการส่งข้อมูลการขายประจำวันใช่หรือไม่'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    bool res =
                        await Provider.of<OrderData>(context, listen: false)
                            .closeOrder();
                    print(res);
                    if (res == true) {
                      Fluttertoast.showToast(
                          msg: "ทำรายการสำเร็จ",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "ทำรายการไม่สำเร็จ",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    //Navigator.of(context).pop(true);
                    // Navigator.pushNamed(context, '/home');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainTest()));
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
        });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
    DateFormat dateformatter = DateFormat('dd-MM-yyyy');
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //  color: Theme.of(context).accentColor,
          color: Colors.lightBlue,
          child: FutureBuilder(
              future: _orderFuture,
              builder: (context, dataSnapshort) {
                if (dataSnapshort.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
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
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                'ข้อมูลวันที่ ${dateformatter.format(DateTime.now())}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
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
                                                        color: Colors.black54,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  VerticalDivider(
                                                    width: 2.0,
                                                  ),
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
                                                        color: Colors.black54,
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
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            //color: Colors.transparent,
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
                                                      color: Colors.black54,
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
                                                      color: Colors.black54,
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
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'รวมทั้งสิ้น',
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
                                              children: [
                                                Text('ยอดขายรวม'),
                                                Text(
                                                  '${formatter.format(orders.creditTotalAmount + orders.cashTotalAmount)}',
                                                  style: TextStyle(
                                                      color: Colors.black54,
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
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 35.0, 10.0, 0.0),
                          child: SizedBox(
                            height: 50.0,
                            //   width: targetWidth,
                            child: Consumer<OrderData>(
                              builder: (context, orders, _) =>
                                  orders.listorder.length > 0
                                      ? _buildclosebutton()
                                      : Text(''),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    ));
  }
}

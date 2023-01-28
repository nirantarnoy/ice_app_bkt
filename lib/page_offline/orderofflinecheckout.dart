import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
import 'package:ice_app_new/page_offline/orderofflinesuccess.dart';
//import 'package:ice_app_new/models/paymentselected.dart';
//import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/ordersuccess.dart';
//import 'package:ice_app_new/pages/payment.dart';
//import 'package:ice_app_new/pages/paymentsuccess.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/providers/user.dart';
import 'package:ice_app_new/sqlite/models/order.dart';
import 'package:ice_app_new/sqlite/models/product_stock_update.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
//import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderofflinecheckoutPage extends StatefulWidget {
  static const routeName = '/orderofflinecheckout';
  @override
  _OrderofflinecheckoutPageState createState() =>
      _OrderofflinecheckoutPageState();
}

class _OrderofflinecheckoutPageState extends State<OrderofflinecheckoutPage> {
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  var formatter = NumberFormat('#,##,##0');
  Paytype _paytype = Paytype.Cash;
  DateTime _date = DateTime.now();
  int _discount_amt = 0;

  Widget _buildList(List<Addorder> itemlist) {
    Widget orderCards;
    if (itemlist != null) {
      if (itemlist?.isNotEmpty) {
        if (itemlist?.length > 0) {
          // print("has list");
          orderCards = new ListView.builder(
              // itemCount: itemlist.length.compareTo(0),
              itemCount: itemlist?.length ?? [],
              itemBuilder: (BuildContext context, int index) {
                // total_amount =
                //     total_amount + int.parse(paymentlist[index].order_amount);

                return Dismissible(
                  key: ValueKey(itemlist[index]),
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
                    setState(() {
                      // Provider.of<OrderData>(context, listen: false)
                      //     .removeOrderDetail(orders[index].line_id);
                      itemlist.forEach((element) {
                        if (element.product_id == itemlist[index].product_id) {
                          itemlist.removeWhere((item) =>
                              item.product_id == itemlist[index].product_id);
                        }
                      });
                      itemlist.removeAt(index);
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
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Chip(
                            label: Text('${itemlist[index].product_code}'),
                          ),
                          title: Text(
                            "${itemlist[index].product_name}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "ราคาขาย ${itemlist[index].sale_price}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.cyan[700]),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "x${itemlist[index].qty}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${formatter.format(double.parse(itemlist[index].qty) * double.parse(itemlist[index].sale_price))}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
                // return ListTile(
                //   title: Text('${paymentlist[index].order_no}'),
                //   subtitle: Text('${paymentlist[index].order_date}'),
                //   trailing: Text('${paymentlist[index].order_amount}'),
                // );
              });
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
  }

  void _editBottomSheet(context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    TextEditingController _discountAmtTextController = TextEditingController();
    // _discountAmtTextController.text = '0';
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              //  height: MediaQuery.of(context).size.height * 0.9,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Icon(
                        //   Icons.check,
                        //   color: Colors.green,
                        // ),
                        Text(
                          "ระบุส่วนลด",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.cancel,
                                color: Colors.orange, size: 25),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(2.0)),
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          controller: _discountAmtTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(
                              fontSize: 40, color: Colors.deepPurple[400]),
                          onChanged: (String value) {
                            // _discountAmtTextController.text = value;
                          },
                        )),
                      ],
                    ),
                    SizedBox(height: 10),
                    // SizedBox(height: 90),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                      child: SizedBox(
                        height: 55.0,
                        width: targetWidth,
                        child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                              elevation: 5,
                              backgroundColor: Colors.blue[500],
                            ),
                            child: new Text('ตกลง',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                _discount_amt =
                                    int.parse(_discountAmtTextController.text);
                              });
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _submitForm(String _customer_id, String _customer_name,
      List<Addorder> listitems, String pay_type, String discount) async {
    // Provider.of<OrderData>(context, listen: false)
    //     .addOrderNew(_customer_id, listitems, pay_type)
    //     .then(
    //   (_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => OrdersuccessPage(),
    //       ),
    //     );
    //   },
    // );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                new Text("กำลังบันทึกข้อมูล"),
              ],
            ),
          ),
        );
      },
    );

    String _order_date = new DateTime.now().toString();
    String _user_id = "";
    String _route_id = "";
    String _car_id = "";
    String _company_id = "";
    String _branch_id = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _route_id = prefs.getString('emp_route_id');
      _car_id = prefs.getString('emp_car_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    double total_amt = 0;
    List<ProductStockUpdate> product_stock_update = [];
    listitems.forEach((element) {
      total_amt = total_amt +
          (double.parse(element.qty) * double.parse(element.sale_price));

      ProductStockUpdate forupdate = ProductStockUpdate(
        product_id: element.product_id,
        qty: element.qty,
      );

      product_stock_update.add(forupdate);
    });

    var jsonx = listitems
        .map((e) => {
              'order_id': '1',
              'product_id': e.product_id,
              'qty': e.qty,
              'price': e.sale_price,
              'price_group_id': e.price_group_id,
              'product_code': e.product_code,
              'product_name': e.product_name,
              'order_line_status': '0',
              'discount_amount': discount,
            })
        .toList();

    // final Map<String, dynamic> orderData = {
    //   'id': "1",
    //   'payment_type_id': pay_type,
    //   'order_date': _order_date,
    //   'customer_id': _customer_id,
    //   'user_id': _user_id,
    //   'route_id': _route_id,
    //   'car_id': _car_id,
    //   'company_id': _company_id,
    //   'branch_id': _branch_id,
    //   'data': jsonx,
    //   'discount': discount,
    //   'sync_status': "0",
    // };
    final Order order_data = Order(
      //  id: 1,
      payment_type_id: pay_type.toString(),
      order_date: DateTime.parse(_order_date),
      customer_id: _customer_id,
      user_id: _user_id,
      route_id: _route_id,
      car_id: _car_id,
      company_id: _company_id,
      branch_id: _branch_id,
      data: json.encode(jsonx),
      discount: discount,
      sync_status: "0",
      customer_name: _customer_name,
      total_amt: total_amt.toString(),
    );

    // final Order orderlist = Order.fromJson(orderData);
    bool issave = await DbHelper.instance.createOrder(order_data);
    if (issave == true) {
      bool isupdateofflinestock = await DbHelper.instance
          .upateProductOfflineStock(product_stock_update, "2"); // deduct stock
      if (isupdateofflinestock == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderofflinesuccessPage(),
          ),
        );
      }
    }
  }

  // void _submitForm(List<PaymentreceiveData> transferdata, String car_id) {
  //   print('transferdata is ${transferdata[0].qty}');
  //   if (transferdata.isNotEmpty) {
  //     Future<bool> res = Provider.of<TransferoutData>(context, listen: false)
  //         .addTransfer(car_id, transferdata);
  //     Navigator.of(context).pop();
  //     if (res == true) {
  //       Scaffold.of(context).showSnackBar(
  //         SnackBar(
  //           content: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.check_circle,
  //                 color: Colors.white,
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(
  //                 "ทำรายการสำเร็จ",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double total_amount = 0;
    double total_qty = 0;
    final payment_data = ModalRoute.of(context).settings.arguments as Map; //
    List<Addorder> order_items = payment_data['orderitemlist'];
    //print('list length = ${paymentselected.length.toString()}');
    //paymentselected[0].order_amount
    order_items.forEach((elm) {
      total_qty = (total_qty + double.parse(elm.qty));
      total_amount = (total_amount +
          (double.parse(elm.qty) * double.parse(elm.sale_price)));
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'ยืนยันรายการขาย',
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "${order_items[0].customer_name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "รายการสินค้า",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: order_items.isNotEmpty
                      ? _buildList(order_items)
                      : Center(
                          child: Text('no'),
                        )),
              Consumer(
                builder: (context, UserData users, _) {
                  if (users.routeType == "2") {
                    // is market route
                    return GestureDetector(
                      onTap: () => _editBottomSheet(context),
                      child: Container(
                        color: Colors.white,
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('ส่วนลด',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          '${formatter.format(_discount_amt)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('จำนวนสินค้า',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text('${total_qty}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child:
                              Text('จำนวนเงิน', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                    '${formatter.format(total_amount - _discount_amt)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.green[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ขายสด',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if (order_items.length <= 0) {
                          return false;
                        } else {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการทำรายการ'),
                              content:
                                  Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop(true);
                                    _submitForm(
                                        order_items[0].customer_id,
                                        order_items[0].customer_name,
                                        order_items,
                                        "1",
                                        _discount_amt.toString());
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
                          // Fluttertoast.showToast(
                          //     msg: "ok",
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);

                          // Navigator.of(context).pushNamed(
                          //     PaymentcheckoutPage.routeName,
                          //     arguments: {
                          //       'paymentlist': paymentselected,
                          //     });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.orange[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ขายเชื่อ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if (order_items.length <= 0) {
                          return false;
                        } else {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการทำรายการ'),
                              content:
                                  Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop(true);
                                    _submitForm(
                                        order_items[0].customer_id,
                                        order_items[0].customer_name,
                                        order_items,
                                        "2",
                                        _discount_amt.toString());
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
                          // Fluttertoast.showToast(
                          //     msg: "ok",
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);

                          // Navigator.of(context).pushNamed(
                          //     PaymentcheckoutPage.routeName,
                          //     arguments: {
                          //       'paymentlist': paymentselected,
                          //     });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.blue[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ฟรี',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if (order_items.length <= 0) {
                          return false;
                        } else {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการทำรายการ'),
                              content:
                                  Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop(true);
                                    _submitForm(
                                        order_items[0].customer_id,
                                        order_items[0].customer_name,
                                        order_items,
                                        "3",
                                        _discount_amt.toString());
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
                          // Fluttertoast.showToast(
                          //     msg: "ok",
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);

                          // Navigator.of(context).pushNamed(
                          //     PaymentcheckoutPage.routeName,
                          //     arguments: {
                          //       'paymentlist': paymentselected,
                          //     });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}

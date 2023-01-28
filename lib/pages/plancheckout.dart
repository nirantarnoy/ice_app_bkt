import 'package:flutter/material.dart';
import 'package:ice_app_new/models/Addplan.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
import 'package:ice_app_new/pages/plansuccess.dart';
import 'package:ice_app_new/providers/plan.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PlancheckoutPage extends StatefulWidget {
  static const routeName = '/plancheckout';
  @override
  _PlancheckoutPageState createState() => _PlancheckoutPageState();
}

class _PlancheckoutPageState extends State<PlancheckoutPage> {
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  var formatter = NumberFormat('#,##,##0');
  Paytype _paytype = Paytype.Cash;
  DateTime _date = DateTime.now();

  Widget _buildList(List<Addplan> itemlist) {
    Widget orderCards;
    if (itemlist != null) {
      if (itemlist?.isNotEmpty) {
        if (itemlist?.length > 0) {
          print("has list");
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
                      // Provider.of<PlanData>(context, listen: false)
                      //     .removePlanCustomer(itemlist[index].id, "0");
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
                          // subtitle: Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: <Widget>[
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Text(
                          //           "ราคาขาย ${itemlist[index].sale_price}",
                          //           style: TextStyle(
                          //               fontSize: 12, color: Colors.cyan[700]),
                          //         ),
                          //       ],
                          //     )
                          //   ],
                          // ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "x${itemlist[index].qty}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
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

  void _submitForm(
      String _customer_id, List<Addplan> listitems, String pay_type) async {
    Provider.of<PlanData>(context, listen: false)
        .addPlan(_customer_id, listitems, pay_type)
        .then(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlansuccessPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double total_amount = 0;
    double total_qty = 0;
    final payment_data = ModalRoute.of(context).settings.arguments as Map; //
    List<Addplan> order_items = payment_data['orderitemlist'];
    //print('list length = ${paymentselected.length.toString()}');
    //paymentselected[0].order_amount
    order_items.forEach((elm) {
      total_qty = (total_qty + double.parse(elm.qty));
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'ยืนยันการสั่งซื้อ',
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Expanded(
              //       child: Container(
              //         color: Colors.green[700],
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Center(
              //             child: Text(
              //               "${order_items[0].customer_name}",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 15,
              //                   color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
              // Container(
              //   color: Colors.grey[300],
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Row(
              //       children: <Widget>[
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 8.0),
              //             child:
              //                 Text('จำนวนเงิน', style: TextStyle(fontSize: 16)),
              //           ),
              //         ),
              //         Expanded(
              //           child: Container(
              //             color: Colors.grey[300],
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsets.only(right: 15.0),
              //                   child: Text('${formatter.format(total_amount)}',
              //                       style: TextStyle(
              //                           fontSize: 16,
              //                           color: Colors.red,
              //                           fontWeight: FontWeight.bold)),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Row(
                children: [
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
                                'ยืนยัน',
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
                                    _submitForm(order_items[0].customer_id,
                                        order_items, "1");
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

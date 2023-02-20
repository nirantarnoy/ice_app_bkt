import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
import 'package:ice_app_new/models/paymentselected.dart';
// import 'package:ice_app_new/pages/main_test.dart';
// import 'package:ice_app_new/pages/payment.dart';
import 'package:ice_app_new/pages/paymentsuccess.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PaymentcheckoutPage extends StatefulWidget {
  static const routeName = '/paymentcheckout';
  @override
  _PaymentcheckoutPageState createState() => _PaymentcheckoutPageState();
}

class _PaymentcheckoutPageState extends State<PaymentcheckoutPage> {
  final Map<String, dynamic> _formData = {'pay_date': null, 'pay_type': "1"};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _paydateTextController = TextEditingController();
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  Paytype _paytype = Paytype.Cash;
  DateTime _date = DateTime.now();

  @override
  initState() {
    setState(() {
      _formData['pay_date'] = dateformatter.format(_date).toString();
    });

    super.initState();
  }

  Widget _buildList(List<Paymentselected> paymentlist) {
    Widget orderCards;
    var formatter = NumberFormat('#,##,##0.0#');

    if (paymentlist.isNotEmpty) {
      if (paymentlist.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            // itemCount: paymentlist.length.compareTo(0),
            itemCount: paymentlist.length,
            itemBuilder: (BuildContext context, int index) {
              // total_amount =
              //     total_amount + int.parse(paymentlist[index].order_amount);

              return Dismissible(
                key: ValueKey(paymentlist[index]),
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
                  // return showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: Text('แจ้งเตือน'),
                  //     content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
                  //     actions: <Widget>[
                  //       FlatButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop(true);
                  //         },
                  //         child: Text('ยืนยัน'),
                  //       ),
                  //       FlatButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pop(false);
                  //         },
                  //         child: Text('ไม่'),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
                onDismissed: (direction) {
                  print(paymentlist[index].order_id);
                  setState(() {
                    // Provider.of<OrderData>(context, listen: false)
                    //     .removeOrderDetail(orders[index].line_id);
                    paymentlist.forEach((element) {
                      if (element.order_id == paymentlist[index].order_id) {
                        paymentlist.removeWhere((item) =>
                            item.order_id == paymentlist[index].order_id);
                      }
                    });
                    // paymentlist.removeAt(index);
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
                        title: Text(
                          "${paymentlist[index].order_no}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "วันที่ ${paymentlist[index].order_date}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.cyan[700]),
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${formatter.format(double.parse(paymentlist[index].order_amount))}",
                              style: TextStyle(
                                  color: Colors.green[500],
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

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(2030));

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        _paydateTextController.text = dateformatter.format(_date).toString();
        _formData['pay_date'] = dateformatter.format(_date).toString();
      });
    }
  }

  Widget _builddatepicker() {
    _paydateTextController.text = dateformatter.format(_date).toString();

    return TextFormField(
      cursorColor: Colors.blue,
      textAlign: TextAlign.left,
      controller: _paydateTextController,
      readOnly: true,
      //initialValue: dateformatter.format(_date).toString(),
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
        //  labelText: 'เลือกวันที่',
        hintText: dateformatter.format(_date).toString(),
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณาเลือกวันที่';
        }
      },
      onSaved: (String value) {
        _formData['pay_date'] = value;
        print('select date is ${_formData['pay_date']}');
      },
    );
  }

  void _submitForm(List<Paymentselected> listitems) async {
    // if (!_formKey.currentState.validate()) {
    //   return;
    // }

    // _formKey.currentState.save();
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
    bool res = await Provider.of<PaymentreceiveData>(context, listen: false)
        .addPayment2(_formData['pay_type'], _formData['pay_date'], listitems);

    if (res == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentsuccessPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "ทำรายการไม่สำเร็จ ลองใหม่อีกครั้ง",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ));
    }

    // Provider.of<PaymentreceiveData>(context, listen: false)
    //     .addPayment2(_formData['pay_type'], _formData['pay_date'], listitems)
    //     .then(
    //   (_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => PaymentsuccessPage(),
    //       ),
    //     );
    //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     //   content: Row(
    //     //     children: <Widget>[
    //     //       Icon(
    //     //         Icons.check_circle,
    //     //         color: Colors.white,
    //     //       ),
    //     //       SizedBox(
    //     //         width: 10,
    //     //       ),
    //     //       Text(
    //     //         "ทำรายการสำเร็จ",
    //     //         style: TextStyle(color: Colors.white),
    //     //       ),
    //     //     ],
    //     //   ),
    //     //   backgroundColor: Colors.green,
    //     // ));

    //     //Navigator.of(context).pop();
    //   },
    // );
    // setState(() {
    //   Provider.of<PaymentreceiveData>(context, listen: false)
    //       .fetPaymentreceive(widget._customer_id);
    // });
  }

  // void _submitForm(List<PaymentreceiveData> transferdata, String car_id) {
  //   print('transferdata is ${transferdata[0].qty}');
  //   if (transferdata.isNotEmpty) {
  //     Future<bool> res = Provider.of<TransferoutData>(context, listen: false)
  //         .addTransfer(car_id, transferdata);
  //     Navigator.of(context).pop();
  //     if (res == true) {
  //       ScaffoldMessenger.of(context).showSnackBar(
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
    var formatter = NumberFormat('#,##,##0.0#');
    final payment_data = ModalRoute.of(context).settings.arguments as Map; //
    List<Paymentselected> paymentselected = payment_data['paymentlist'];
    //print('list length = ${paymentselected.length.toString()}');
    //paymentselected[0].order_amount
    paymentselected.forEach((elm) {
      total_amount = (total_amount + double.parse(elm.order_amount));
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'รับชำระเงิน',
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
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "ยืนยันรายการที่เลือกรับชำระ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.cyan),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "ลูกค้า",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${paymentselected[0].customer_name}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "ยอดชำระ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${formatter.format(total_amount)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "วันที่รับชำระ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: _builddatepicker(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("เงินสด"),
                          leading: Radio<Paytype>(
                            value: Paytype.Cash,
                            groupValue: _paytype,
                            onChanged: (value) {
                              // print('ss = $value');
                              setState(() {
                                _paytype = value;
                                _formData['pay_type'] = '1';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("โอนธนาคาร"),
                          leading: Radio<Paytype>(
                            value: Paytype.Transfer,
                            groupValue: _paytype,
                            onChanged: (value) {
                              setState(() {
                                _paytype = value;
                                _formData['pay_type'] = '2';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "เลขที่บิล",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.cyan),
                  ),
                ],
              ),
              Expanded(child: _buildList(paymentselected)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: paymentselected.length > 0
                            ? Colors.orange[700]
                            : Colors.orange[200],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'บันทึกรับชำระ',
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
                        if (paymentselected.length <= 0) {
                          return false;
                        } else {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการทำรายการ'),
                              content:
                                  Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop(true);
                                    _submitForm(paymentselected);
                                  },
                                  child: Text('ยืนยัน'),
                                ),
                                TextButton(
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
              )
            ],
          ),
        )),
      ),
    );
  }
}

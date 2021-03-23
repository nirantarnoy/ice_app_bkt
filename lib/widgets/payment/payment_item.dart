import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/paymentreceive.dart';

class PaymentItem extends StatefulWidget {
  @override
  _PaymentItemState createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  List<Paymentreceive> _payments = [];
  String selectedValue;
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
      Provider.of<PaymentreceiveData>(context, listen: false)
          .fetPaymentreceive()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<CustomerData>(context, listen: false)
          .fetCustomers()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _buildpaymentsList(List<Paymentreceive> payments) {
    Widget orderCards;
    if (payments.length > 0) {
      // print("has list");
      orderCards = new ListView.builder(
        itemCount: payments.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
            payments[index].order_id,
            payments[index].order_no,
            payments[index].order_date,
            payments[index].customer_id,
            payments[index].customer_code,
            payments[index].line_total,
            payments[index].remain_amount,
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
    final PaymentreceiveData payments =
        Provider.of<PaymentreceiveData>(context, listen: false);
    final CustomerData customers =
        Provider.of<CustomerData>(context, listen: false);
    //customers.fetCustomers();
    //payments.fetPaymentreceive();
    var formatter = NumberFormat('#,##,##0');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.purple,
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.only(left: 1, right: 1),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.purple, width: 0.1),
                            borderRadius: BorderRadius.circular(1)),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: selectedValue,
                            iconSize: 30,
                            icon: Icon(Icons.find_in_page, color: Colors.white),
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            hint: Text(
                              'เลือกลูกค้า',
                              style: TextStyle(
                                  fontFamily: 'Kanit-Regular',
                                  color: Colors.white),
                            ),
                            dropdownColor: Colors.purple,
                            items: customers.listcustomer
                                .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Kanit-Regular'),
                                    )))
                                .toList(),
                            onChanged: (String value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "ยอดค้างชำระ",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                          SizedBox(width: 10),
                          Chip(
                            label: Text(
                              "${formatter.format(payments.totalAmount)}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          Text("บาท",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87))
                        ]),
                  ],
                ),
              ),
            )
          ]),
          SizedBox(height: 5),
          Expanded(child: _buildpaymentsList(payments.listpaymentreceive)),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  GlobalKey<FormState> _formkey;
  //payments _payments;
  final String _id;
  final String _order_no;
  final String _order_date;
  final String _customer_id;
  final String _customer_code;
  final String _line_total;
  final String _remain_amount;

  Items(
    this._id,
    this._order_no,
    this._order_date,
    this._customer_id,
    this._customer_code,
    this._line_total,
    this._remain_amount,
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return showDialog(
            context: context,
            builder: (context) {
              final TextEditingController _textEditingController =
                  TextEditingController();
              bool isChecked = false;
              return Material(
                shadowColor: Colors.grey,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Center(
                          child: Text(
                        "บันทึกชำระเงิน",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 10),
                      Form(
                        key: _formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _textEditingController,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Fields";
                              },
                              decoration:
                                  InputDecoration(hintText: "Enter some text"),
                            ),
                            Row(
                              children: <Widget>[
                                Text("check"),
                                Checkbox(
                                  value: false,
                                  onChanged: (checked) {},
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                color: Colors.green,
                                onPressed: () {},
                                child: Text("บันทีก"),
                              ),
                              FlatButton(
                                onPressed: () {},
                                child: Text("บันทีก"),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
        // return showDialog(
        //     context: context,
        //     builder: (context) {
        //       final TextEditingController _textEditingController =
        //           TextEditingController();
        //       bool isChecked = false;
        //       return AlertDialog(
        //         content: Form(
        //           key: _formkey,
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: <Widget>[
        //               TextFormField(
        //                 controller: _textEditingController,
        //                 validator: (value) {
        //                   return value.isNotEmpty ? null : "Invalid Fields";
        //                 },
        //                 decoration:
        //                     InputDecoration(hintText: "Enter some text"),
        //               ),
        //               Row(
        //                 children: <Widget>[
        //                   Text("check"),
        //                   Checkbox(
        //                     value: false,
        //                     onChanged: (checked) {},
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     });
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
            //   label: Text("${_order_no}", style: TextStyle(color: Colors.white)),
            //   backgroundColor: Colors.green[500],
            // ),
            title: Text(
              "${_order_no}",
              style: TextStyle(fontSize: 16, color: Colors.cyan),
            ),
            subtitle: Text("${_order_date}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${_remain_amount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

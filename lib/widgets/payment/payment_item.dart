import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/paymentreceive.dart';
import '../../models/enum_paytype.dart';

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
          .fetPaymentreceive("")
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
    if (payments.isNotEmpty) {
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
          // SizedBox(
          //   height: 10,
          // )
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Consumer<PaymentreceiveData>(
                            builder: (context, totals, _) => Row(
                              children: <Widget>[
                                Text(
                                  'รวม ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatter.format(0)}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: Colors.green[700],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text(
                            'ตกลง',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Items extends StatefulWidget {
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
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  GlobalKey<FormState> _formkey;

  Paytype _paytype = Paytype.Cash;

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
              // return Material( // fullscreen
              //   shadowColor: Colors.grey,
              //   child: Container(
              //     padding: EdgeInsets.all(16),
              //     // width: double.infinity,
              //     // height: double.infinity,
              //     width: MediaQuery.of(context).size.width - 100,
              //     height: MediaQuery.of(context).size.height - 10,

              //   ),
              // );

              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  // width: MediaQuery.of(context).size.width - 10,
                  // height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
                  height: double.infinity,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Center(
                            child: Text(
                          "บันทึกชำระเงิน",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        SizedBox(height: 20),
                        ListTile(
                          title: Text("เงินสด"),
                          leading: Radio<Paytype>(
                            value: Paytype.Cash,
                            groupValue: _paytype,
                            onChanged: (Paytype value) {
                              setState(() {
                                _paytype = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("โอนธนาคาร"),
                          leading: Radio<Paytype>(
                            value: Paytype.Transfer,
                            groupValue: _paytype,
                            onChanged: (Paytype value) {
                              setState(() {
                                _paytype = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: TextFormField(
                                  controller: _textEditingController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return value.isNotEmpty
                                        ? null
                                        : "Invalid Fields";
                                  },
                                  decoration:
                                      InputDecoration(hintText: "จำนวนเงิน"),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        //  Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[500],
                                textStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.only(
                                  right: 8,
                                ),
                                elevation: 0.2,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                              ),
                              onPressed: () {},
                              child: Text("บันทีก"),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     ElevatedButton(
                        //       padding: EdgeInsets.only(left: 8),
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(15)),
                        //       color: Colors.orange,
                        //       textColor: Colors.white,
                        //       onPressed: () {
                        //         Navigator.pop(context);
                        //       },
                        //       child: Text("ยกเลิก"),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
      child: Column(
        children: <Widget>[
          ListTile(
            // leading: ElevatedButton(
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
            leading: Checkbox(
              activeColor: Colors.red,
              value: true,
              onChanged: (value) => value,
            ),
            title: Text(
              "${widget._order_no}",
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
            subtitle: Text("${widget._order_date}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget._remain_amount}",
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
    );
  }
}

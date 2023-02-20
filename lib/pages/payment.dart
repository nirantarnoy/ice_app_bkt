import 'dart:async';
//import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/paymentselected.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/paymentcheckout.dart';
import 'package:ice_app_new/pages/paymenthistory.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:ice_app_new/widgets/payment/payment_item.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';

//import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/models/paymentreceive.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
//import 'package:ice_app_new/widgets/error/err_api.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = '/payment';
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  final Map<String, dynamic> _formData = {
    'pay_amount': null,
    'pay_date': null,
    'pay_type': "1"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _paydateTextController = TextEditingController();
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');

  bool _networkisok = false;

  final Paymentreceive all_pay_checked = Paymentreceive(
    order_id: '0',
    order_no: '',
    order_date: '',
    customer_code: '',
    customer_id: '',
    line_total: '',
    remain_amount: '',
    value: false,
  );

  Paytype _paytype = Paytype.Cash;
  DateTime _date = DateTime.now();

  bool pay_all_selected = false;
  bool pay_selected = false;
  List<Paymentselected> paymentselected = [];
  List<bool> _isChecked;

  String selectedPaytype = "1";
  // var _isInit = true;
  // var _isLoading = false;
  String selectedValue;

  Future _customerFuture;
  Future _paymentlistFuture;

  Future _obtaincustomerFuture() {
    return Provider.of<CustomerData>(context, listen: false).fetCustomers();
  }

  Future _obtainpaymentlistFuture() {
    return Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentreceive("");
  }

  @override
  initState() {
    _checkinternet();

    _customerFuture = _obtaincustomerFuture();
    _paymentlistFuture = _obtainpaymentlistFuture();
    // try {
    //   widget.model.fetchpayments();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetpayments();
    // _isChecked = List<bool>.filled(2, false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // print('didChange()');
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<PaymentreceiveData>(context, listen: false)
    //       .fetPaymentreceive("")
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // Provider.of<CustomerData>(context, listen: false)
    //     .fetCustomers()
    //     .then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    // }
    //_isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PaymentPage oldWidget) {
    //  print('didUpdate()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    //  print('dispose()');
    super.dispose();
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      setState(() {
        _networkisok = false;
      });
      _showdialog('พบปัญหา', 'ไม่สามารถเชื่อมต่ออินเตอร์เน็ตได้');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
      setState(() {
        _networkisok = true;
      });
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
      setState(() {
        _networkisok = true;
      });
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
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ตกลง'))
            ],
          );
        });
  }

  // Widget _buildpaymentsList() {
  //   return Consumer(
  //       builder: (context, PaymentreceiveData payments, Widget child) {
  //     //orders.fetPaymentreceive("1");
  //     Widget content = Center(
  //         child: Text(
  //       'ไม่พบข้อมูล!',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //     ));
  //     // print("data length = " + products.listproduct.toString());
  //     if (payments.is_apicon) {
  //       if (!payments.is_loading) {
  //         content = Container(child: PaymentItem());
  //       } else if (payments.is_loading) {
  //         content = Center(child: CircularProgressIndicator());
  //       }
  //     } else {
  //       content = ErrorApi();
  //     }
  //     return RefreshIndicator(
  //       onRefresh: ,
  //       child: Container(child: PaymentItem()),
  //     );
  //   });
  // }

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
      });
    }
  }

  Widget _builpayamount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'ระบุจำนวนเงิน', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณากรอกจำนวนเงิน';
        }
      },
      onSaved: (String value) {
        _formData['pay_amount'] = value;
      },
    );
  }

  Widget _builddatepicker() {
    _paydateTextController.text = dateformatter.format(_date).toString();

    return TextFormField(
      cursorColor: Colors.blue,
      textAlign: TextAlign.center,
      controller: _paydateTextController,
      readOnly: true,
      //  initialValue: dateformatter.format(_date).toString(),
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
        labelText: 'เลือกวันที่',
        hintText: dateformatter.format(_date).toString(),
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณาเลือกวันที่';
        }
      },
      onSaved: (String value) {
        _formData['pay_date'] = value;
      },
    );
  }

  // void _submitForm(String order_id, String customer_id) async {
  //   if (!_formKey.currentState.validate()) {
  //     return;
  //   }

  //   _formKey.currentState.save();

  //   Provider.of<PaymentreceiveData>(context, listen: false)
  //       .addPayment(order_id, customer_id, _formData['pay_type'],
  //           _formData['pay_amount'], _formData['pay_date'])
  //       .then(
  //     (_) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Row(
  //           children: <Widget>[
  //             Icon(
  //               Icons.check_circle,
  //               color: Colors.white,
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             Text(
  //               "ทำรายการสำเร็จ",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ],
  //         ),
  //         backgroundColor: Colors.green,
  //       ));

  //       Navigator.of(context).pop();
  //     },
  //   );
  //   setState(() {
  //     Provider.of<PaymentreceiveData>(context, listen: false)
  //         .fetPaymentreceive(customer_id);
  //   });
  // }

  Widget _buildpaymentsList(List<Paymentreceive> payments) {
    Widget orderCards;
    var formatter = NumberFormat('#,##,##0.0#');
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    if (payments != null) {
      if (payments.length > 0) {
        // print("has list");

        //  print('${_isChecked.length}');

        orderCards = ListView.builder(
          //scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: payments.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap:
                  () {}, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    secondary: Text(
                        "${formatter.format(double.parse(payments[index].remain_amount))}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 20)),
                    title: Text('${payments[index].order_no}'),
                    subtitle: Text(
                        '${dateformatter.format(DateTime.parse(payments[index].order_date))}'),
                    value: _isChecked[index],
                    selected: _isChecked[index],
                    //  value: payments[index].value,
                    activeColor: Colors.red,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        _isChecked[index] = value;
                        // payments[index].value = value;
                        print("checkbox is ${_isChecked[index]}");

                        if (value == true) {
                          print('select true');
                          Paymentselected select_data = new Paymentselected(
                            payments[index].order_id,
                            payments[index].order_no,
                            payments[index].customer_id,
                            payments[index].customer_code,
                            payments[index].order_date,
                            payments[index].remain_amount,
                          );
                          paymentselected.add(select_data);
                        } else {
                          print('select false');
                          all_pay_checked.value = false;
                          paymentselected.forEach((element) {
                            if (element.order_id == payments[index].order_id) {
                              paymentselected.removeWhere((item) =>
                                  item.order_id == payments[index].order_id);
                            }
                          });
                        }
                      });

                      paymentselected.forEach((element) {
                        print(element.order_no);
                      });
                    },
                  ),
                  Divider(),
                ],
              ),
            );
          },
        );
        //print('{orderCards.}');
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

  Future<dynamic> _pagerefresh() {
    Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentreceive("2850");
  }

  Widget _buildGroupList(List<Paymentreceive> payments) {
    int x = 0;
    return CheckboxListTile(
      value: all_pay_checked.value,
      title: Text('เลือกทั้งหมด'),
      activeColor: Colors.red,
      onChanged: (bool value) {
        if (value == false) {
          paymentselected.clear();
          all_pay_checked.value = value;
          payments.forEach((element) {
            _isChecked[x] = value;
            x += 1;
          });
          return;
        } else {
          setState(() {
            all_pay_checked.value = value;
            paymentselected.clear();
            payments.forEach((element) {
              _isChecked[x] = value;
              Paymentselected select_data = new Paymentselected(
                payments[x].order_id,
                payments[x].order_no,
                payments[x].customer_id,
                payments[x].customer_code,
                payments[x].order_date,
                payments[x].remain_amount,
              );
              paymentselected.add(select_data);
              x += 1;
            });
          });
          print(pay_all_selected);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //CustomerData _customer = Provider.of<CustomerData>(context, listen: false);
    var formatter = NumberFormat('#,##,##0.0#');

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
              Navigator.of(context).pop(MainTest());
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.alarm,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymenthistoryPage())),
            ),
          ],
        ),
        body: _networkisok == true
            ? Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          FutureBuilder(builder: (context, dataSapshort) {
                            if (dataSapshort.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (dataSapshort.error != null) {
                                return Center(child: Text('Data Error'));
                              } else {
                                return Expanded(
                                  child: Consumer<CustomerData>(
                                    builder: (context, _customer, _) =>
                                        TypeAheadField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              controller: _typeAheadController,
                                              autofocus: false,
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .copyWith(
                                                          fontStyle:
                                                              FontStyle.normal),
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'เลือกลูกค้า')),
                                      // suggestionsCallback: (pattern) async {
                                      //   return await BackendService.getSuggestions(pattern);
                                      // },
                                      suggestionsCallback: (pattern) async {
                                        return await _customer
                                            .findCustomer(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          // leading: Icon(Icons.shopping_cart),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(suggestion.name),
                                              Divider(
                                                color: Colors.cyan,
                                              ),
                                            ],
                                          ),
                                          // subtitle: Text('\$${suggestion['price']}'),
                                        );
                                      },
                                      onSuggestionSelected: (items) {
                                        //print("niran");
                                        //print(items.id);
                                        setState(() {
                                          selectedValue = items.id;
                                          Provider.of<PaymentreceiveData>(
                                                  context,
                                                  listen: false)
                                              .fetPaymentreceive(selectedValue);
                                          this._typeAheadController.text =
                                              items.name;
                                          _isChecked =
                                              List<bool>.filled(200, false);
                                        });
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'ไม่พบข้อมูล',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                            }
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: _paymentlistFuture,
                        builder: (context, dataSnapshort) {
                          if (dataSnapshort.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (dataSnapshort.error != null) {
                              return Center(child: Text('Data Error'));
                            } else {
                              return Card(
                                margin: EdgeInsets.all(3),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "ยอดค้างชำระ",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87),
                                            ),
                                            SizedBox(width: 10),
                                            Chip(
                                              label:
                                                  Consumer<PaymentreceiveData>(
                                                      builder: (context,
                                                              payments, _) =>
                                                          Text(
                                                            payments.totalAmount ==
                                                                    null
                                                                ? 0
                                                                : "${formatter.format(payments.totalAmount)}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          )),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Text("บาท",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black87))
                                          ]),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 5),
                    Expanded(
                      flex: 0,
                      child: Consumer<PaymentreceiveData>(
                        builder: (context, payments, _) =>
                            _buildGroupList(payments.listpaymentreceive),
                      ),
                    ),
                    Expanded(
                      child: Consumer<PaymentreceiveData>(
                        builder: (context, payments, _) =>
                            _buildpaymentsList(payments.listpaymentreceive),
                      ),
                    ),
                    Container(
                      child: Row(
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
                                              '${paymentselected.length}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            Text(
                                              ' รายการ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
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
                          ),
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
                                        'ถัดไป',
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
                                  // Fluttertoast.showToast(
                                  //     msg: "ok",
                                  //     toastLength: Toast.LENGTH_LONG,
                                  //     gravity: ToastGravity.BOTTOM,
                                  //     timeInSecForIosWeb: 1,
                                  //     backgroundColor: Colors.green,
                                  //     textColor: Colors.white,
                                  //     fontSize: 16.0);

                                  Navigator.of(context).pushNamed(
                                      PaymentcheckoutPage.routeName,
                                      arguments: {
                                        'paymentlist': paymentselected,
                                      });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )

                    // RefreshIndicator(
                    //   onRefresh: _pagerefresh,
                    //   child: Consumer<PaymentreceiveData>(
                    //     builder: (context, payments, _) =>
                    //         _buildpaymentsList(payments.listpaymentreceive),
                    //   ),
                    // ),

                    // FutureBuilder(
                    //   future: _paymentlistFuture,
                    //   builder: (context, dataSnapshort) {
                    //     if (dataSnapshort.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     } else {
                    //       if (dataSnapshort.error != null) {
                    //         return Center(child: Text('Data Error'));
                    //       } else {
                    //         return Expanded(
                    //           child: Consumer<PaymentreceiveData>(
                    //             builder: (context, payments, _) =>
                    //                 _buildpaymentsList(payments.listpaymentreceive),
                    //           ),
                    //         );
                    //       }
                    //     }
                    //   },
                    // ),
                  ],
                ),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Icon(
                    Icons.wifi_off_outlined,
                    size: 100,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(child: Text('ไม่พบสัญญาณอินเตอร์เน็ต'))
                ],
              ),
      ),
    );
  }
}






// class Items extends StatefulWidget {
//   final String _id;
//   final String _order_no;
//   final String _order_date;
//   final String _customer_id;
//   final String _customer_code;
//   final String _line_total;
//   final String _remain_amount;

//   Items(
//     this._id,
//     this._order_no,
//     this._order_date,
//     this._customer_id,
//     this._customer_code,
//     this._line_total,
//     this._remain_amount,
//   );

//   @override
//   _ItemsState createState() => _ItemsState();
// }

// class _ItemsState extends State<Items> {
//   final Map<String, dynamic> _formData = {
//     'pay_amount': null,
//     'pay_date': null,
//     'pay_type': "1"
//   };
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _paydateTextController = TextEditingController();
//   final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
//   Paytype _paytype = Paytype.Cash;
//   DateTime _date = DateTime.now();

//   bool pay_selected = false;
//   List<Paymentselected> paymentselected = [];

//   String selectedPaytype = "1";

//   Future<Null> _selectDate(BuildContext context) async {
//     DateTime _datePicker = await showDatePicker(
//         context: context,
//         initialDate: _date,
//         firstDate: DateTime(1947),
//         lastDate: DateTime(2030));

//     if (_datePicker != null && _datePicker != _date) {
//       setState(() {
//         _date = _datePicker;
//         _paydateTextController.text = dateformatter.format(_date).toString();
//       });
//     }
//   }

//   Widget _builpayamount() {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       style: TextStyle(fontSize: 16),
//       textAlign: TextAlign.center,
//       decoration: InputDecoration(
//           labelText: 'ระบุจำนวนเงิน', filled: true, fillColor: Colors.white),
//       validator: (String value) {
//         if (value.isEmpty || value.length < 1) {
//           return 'กรุณากรอกจำนวนเงิน';
//         }
//       },
//       onSaved: (String value) {
//         _formData['pay_amount'] = value;
//       },
//     );
//   }

//   Widget _builddatepicker() {
//     _paydateTextController.text = dateformatter.format(_date).toString();

//     return TextFormField(
//       cursorColor: Colors.blue,
//       textAlign: TextAlign.center,
//       controller: _paydateTextController,
//       readOnly: true,
//       //  initialValue: dateformatter.format(_date).toString(),
//       onTap: () {
//         _selectDate(context);
//       },
//       decoration: InputDecoration(
//         labelText: 'เลือกวันที่',
//         hintText: dateformatter.format(_date).toString(),
//       ),
//       validator: (String value) {
//         if (value.isEmpty || value.length < 1) {
//           return 'กรุณาเลือกวันที่';
//         }
//       },
//       onSaved: (String value) {
//         _formData['pay_date'] = value;
//       },
//     );
//   }

//   void _submitForm() async {
//     if (!_formKey.currentState.validate()) {
//       return;
//     }

//     _formKey.currentState.save();

//     Provider.of<PaymentreceiveData>(context, listen: false)
//         .addPayment(widget._id, widget._customer_id, _formData['pay_type'],
//             _formData['pay_amount'], _formData['pay_date'])
//         .then(
//       (_) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
//         ));

//         Navigator.of(context).pop();
//       },
//     );
//     setState(() {
//       Provider.of<PaymentreceiveData>(context, listen: false)
//           .fetPaymentreceive(widget._customer_id);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var formatter = NumberFormat('#,##,##0');
//     final double deviceWidth = MediaQuery.of(context).size.width;
//     final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
//     return GestureDetector(
//       onTap: () {
//         return showDialog(
//             context: context,
//             builder: (context) {
//               final TextEditingController _textEditingController =
//                   TextEditingController();
//               bool isChecked = false;
//               // return Material( // fullscreen
//               //   shadowColor: Colors.grey,
//               //   child: Container(
//               //     padding: EdgeInsets.all(16),
//               //     // width: double.infinity,
//               //     // height: double.infinity,
//               //     width: MediaQuery.of(context).size.width - 100,
//               //     height: MediaQuery.of(context).size.height - 10,

//               //   ),
//               // );

//               return SingleChildScrollView(
//                 child: Dialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 10,
//                     height: MediaQuery.of(context).size.height - 50,
//                     // height: MediaQuery.of(context).size.height - 100,
//                     // width: double.infinity,
//                     // height: double.infinity,
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           SizedBox(height: 20),
//                           Center(
//                               child: Text(
//                             "บันทึกชำระเงิน",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: _builddatepicker(),
//                           ),
//                           SizedBox(height: 10),
//                           ListTile(
//                             title: Text("เงินสด"),
//                             leading: Radio<Paytype>(
//                               value: Paytype.Cash,
//                               groupValue: _paytype,
//                               onChanged: (value) {
//                                 // print('ss = $value');
//                                 setState(() {
//                                   _paytype = value;
//                                   _formData['pay_type'] = '1';
//                                 });
//                               },
//                             ),
//                           ),
//                           ListTile(
//                             title: Text("โอนธนาคาร"),
//                             leading: Radio<Paytype>(
//                               value: Paytype.Transfer,
//                               groupValue: _paytype,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _paytype = value;
//                                   _formData['pay_type'] = '2';
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   "ยอดค้างชำระ",
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   '${formatter.format(double.parse(widget._remain_amount))}',
//                                   style: TextStyle(
//                                       fontSize: 25, color: Colors.red),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   'บาท',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ]),
//                           SizedBox(height: 20),
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: _builpayamount(),
//                           ),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
//                             child: SizedBox(
//                               height: 55.0,
//                               width: targetWidth,
//                               child: new RaisedButton(
//                                   elevation: 0.2,
//                                   shape: new RoundedRectangleBorder(
//                                       borderRadius:
//                                           new BorderRadius.circular(15.0)),
//                                   color: Colors.green[700],
//                                   child: new Text('บันทึก',
//                                       style: new TextStyle(
//                                           fontSize: 20.0, color: Colors.white)),
//                                   onPressed: () {
//                                     _submitForm();
//                                     // Navigator.pop(context);
//                                   }),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
//                             child: SizedBox(
//                               height: 55.0,
//                               width: targetWidth,
//                               child: new RaisedButton(
//                                   elevation: 0.2,
//                                   shape: new RoundedRectangleBorder(
//                                       borderRadius:
//                                           new BorderRadius.circular(15.0)),
//                                   color: Colors.blue[700],
//                                   child: new Text('ชำระเต็มจำนวน',
//                                       style: new TextStyle(
//                                           fontSize: 20.0, color: Colors.white)),
//                                   onPressed: () {
//                                     _submitForm();
//                                     // Navigator.pop(context);
//                                   }),
//                             ),
//                           ),

//                           Padding(
//                             padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
//                             child: SizedBox(
//                               height: 55.0,
//                               width: targetWidth,
//                               child: new RaisedButton(
//                                   elevation: 0.2,
//                                   shape: new RoundedRectangleBorder(
//                                       borderRadius:
//                                           new BorderRadius.circular(15.0)),
//                                   color: Colors.grey[700],
//                                   child: new Text('ยกเลิก',
//                                       style: new TextStyle(
//                                           fontSize: 20.0, color: Colors.white)),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   }),
//                             ),
//                           ),

//                           // RaisedButton(
//                           //   //padding: EdgeInsets.only(right: 8),
//                           //   shape: RoundedRectangleBorder(
//                           //       borderRadius: BorderRadius.circular(15)),
//                           //   color: Colors.blue[500],
//                           //   textColor: Colors.white,
//                           //   onPressed: () => _submitForm(),
//                           //   child: Text("บันทีก"),
//                           // ),
//                           // Column(
//                           //   mainAxisAlignment: MainAxisAlignment.end,
//                           //   children: <Widget>[
//                           //     Row(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       children: <Widget>[
//                           //         SizedBox(width: 20),
//                           //         RaisedButton(
//                           //           padding: EdgeInsets.only(left: 8),
//                           //           shape: RoundedRectangleBorder(
//                           //               borderRadius:
//                           //                   BorderRadius.circular(15)),
//                           //           color: Colors.orange,
//                           //           textColor: Colors.white,
//                           //           onPressed: () {
//                           //             Navigator.pop(context);
//                           //           },
//                           //           child: Text("ยกเลิก"),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //   ],
//                           // )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             });
//       }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
//       child: Column(
//         children: <Widget>[
//           // ListTile(
//           //   // leading: RaisedButton(
//           //   //     color:
//           //   //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
//           //   //     onPressed: () {},
//           //   //     child: Text(
//           //   //       "$_payment_method",
//           //   //       style: TextStyle(color: Colors.white),
//           //   //     )),
//           //   // leading: Chip(
//           //   //   label: Text("${_order_no}", style: TextStyle(color: Colors.white)),
//           //   //   backgroundColor: Colors.green[500],
//           //   // ),
//           //   leading: Checkbox(
//           //     activeColor: Colors.red,
//           //     value: pay_selected,
//           //     onChanged: (value) {
//           //       setState(() {
//           //         pay_selected = value;
//           //         print('pay_selected is ${pay_selected}');
//           //       });
//           //     },
//           //   ),
//           //   title: Text(
//           //     "${widget._order_no}",
//           //     style: TextStyle(fontSize: 16, color: Colors.purple),
//           //   ),
//           //   subtitle: Text("${widget._order_date}"),
//           //   trailing: Column(
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: [
//           //       Text("${formatter.format(double.parse(widget._remain_amount))}",
//           //           style: TextStyle(
//           //               fontWeight: FontWeight.bold,
//           //               color: Colors.red,
//           //               fontSize: 20)),
//           //     ],
//           //   ),
//           // ),

//           CheckboxListTile(
//             secondary: Text(
//                 "${formatter.format(double.parse(widget._remain_amount))}",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                     fontSize: 20)),
//             title: Text('${widget._order_no}'),
//             subtitle: Text('${widget._order_date}'),
//             value: this.pay_selected,
//             activeColor: Colors.red,
//             checkColor: Colors.white,
//             onChanged: (bool value) {
//               setState(() {
//                 this.pay_selected = value;
//                 print("checkbox is ${this.pay_selected}");
//                 if (value == true) {
//                   Paymentselected select_data = new Paymentselected(
//                     widget._id,
//                     widget._order_no,
//                     widget._customer_id,
//                     widget._customer_code,
//                     widget._order_date,
//                     widget._remain_amount,
//                   );
//                   paymentselected.add(select_data);
//                 } else {
//                   paymentselected.forEach((element) {
//                     if (element.order_id == widget._id) {
//                       paymentselected
//                           .removeWhere((item) => item.order_id == widget._id);
//                     }
//                   });
//                 }
//               });

//               paymentselected.forEach((element) {
//                 print(element.order_no);
//               });
//             },
//           ),
//           Divider(),
//         ],
//       ),
//     );
//   }
// }


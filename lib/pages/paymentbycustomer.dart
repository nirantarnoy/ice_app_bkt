import 'dart:async';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

class PaymentCustomerPage extends StatefulWidget {
  static const routeName = '/paymentcustomer';
  final String customer_id;
  final String customer_name;

  const PaymentCustomerPage({
    Key key,
    this.customer_id,
    this.customer_name,
  }) : super(key: key);
  @override
  _PaymentCustomerPageState createState() => _PaymentCustomerPageState();
}

class _PaymentCustomerPageState extends State<PaymentCustomerPage> {
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

  Future _paymentlistFuture;

  Future _obtainpaymentlistFuture() {
    return Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentreceive(widget.customer_id);
  }

  @override
  initState() {
    _checkinternet();

    //_paymentlistFuture = _obtainpaymentlistFuture();
    EasyLoading.show(status: "โหลดข้อมูล");
    Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentreceive(widget.customer_id);
    EasyLoading.dismiss();
    _isChecked = List<bool>.filled(50, false);
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
  void didUpdateWidget(PaymentCustomerPage oldWidget) {
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

  Widget _buildpaymentsList(List<Paymentreceive> payments) {
    Widget orderCards;
    var formatter = NumberFormat('#,##,##0.0#');
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    if (payments != null) {
      if (payments.length > 0) {
        print("has list");

        //  print('${_isChecked.length}');

        orderCards = ListView.builder(
          //scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: payments.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
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
                      child: Card(
                        margin: EdgeInsets.all(3),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'ลูกค้า : ${widget.customer_name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                          fontSize: 20, color: Colors.black87),
                                    ),
                                    SizedBox(width: 10),
                                    Chip(
                                      label: Consumer<PaymentreceiveData>(
                                          builder: (context, payments, _) =>
                                              Text(
                                                payments.totalAmount == null
                                                    ? 0
                                                    : "${formatter.format(payments.totalAmount)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              )),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    Text("บาท",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87))
                                  ]),
                            ],
                          ),
                        ),
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

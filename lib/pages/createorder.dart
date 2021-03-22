import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';

import 'package:ice_app_new/models/customers.dart';
import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
import 'package:ice_app_new/providers/customer.dart';

class CreateorderPage extends StatefulWidget {
  static const routeName = '/createorder';
  @override
  _CreateorderPageState createState() => _CreateorderPageState();
}

class _CreateorderPageState extends State<CreateorderPage> {
  String selectedValue;
  var _isInit = true;
  var _isLoading = false;
  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
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

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('No intenet', 'You are no internet connect');
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
                  child: Text('ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final CustomerData customers =
        Provider.of<CustomerData>(context, listen: false);
    customers.fetCustomers();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ทำรายการขาย',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        //body: SaleProductItem(),
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.1),
                          borderRadius: BorderRadius.circular(1)),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: selectedValue,
                          iconSize: 30,
                          icon: (null),
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                          hint: Text(
                            'เลือกลูกค้า',
                            style: TextStyle(fontFamily: 'kanit'),
                          ),
                          dropdownColor: Colors.white,
                          items: customers.listcustomer
                              .map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.name)))
                              .toList(),
                          onChanged: (String value) {
                            setState(() {
                              selectedValue = value;
                              SaleProductItem.selectedCustomer = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                //  SaleProductItem()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "รายการสินค้า",
              style: TextStyle(color: Colors.purple[500], fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SaleProductItem(),
            )
          ],
        ),
      ),
    );
  }
}

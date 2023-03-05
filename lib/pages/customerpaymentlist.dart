import 'package:flutter/material.dart';
import 'package:ice_app_new/models/customerpaymentlist.dart';
import 'package:ice_app_new/models/paymentreceive.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/paymentbycustomer.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerPaymentListPage extends StatefulWidget {
  @override
  State<CustomerPaymentListPage> createState() =>
      _CustomerPaymentListPageState();
}

class _CustomerPaymentListPageState extends State<CustomerPaymentListPage> {
  @override
  void initState() {
    // TODO: implement initState

    Provider.of<PaymentreceiveData>(context, listen: false)
        .fetchCustomerpaymentlist();
    super.initState();
  }

  Widget _buildlist(List<CustomerPaymentList> _list) {
    var formatter = NumberFormat('#,##,##0.0#');
    Widget _cards;

    if (_list.isNotEmpty) {
      _cards = new ListView.builder(
          itemCount: _list.length,
          itemBuilder: ((BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentCustomerPage(
                            customer_id: _list[index].customer_id,
                            customer_name: _list[index].customer_name,
                          ))),
              child: Card(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${_list[index].customer_name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     '${formatter.format(double.parse(_list[index].remain_amt))}',
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }));
      return _cards;
    } else {
      return Center(
        child: Text('ไม่พบข้อมูล'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายชื่อลูกค้าที่ต้องรับชำระเงิน',
            style: TextStyle(
              color: Colors.white,
            ),
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
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<PaymentreceiveData>(
                builder: (context, value, _) {
                  return _buildlist(value.listcustomerpayment);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

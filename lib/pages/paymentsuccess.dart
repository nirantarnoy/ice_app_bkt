import 'package:flutter/material.dart';
//import 'package:ice_app_new/pages/home.dart';
import 'package:ice_app_new/pages/main_test.dart';
//import 'package:ice_app_new/pages/payment.dart';
//import 'package:ice_app_new/pages/transferout.dart';
//import 'package:ice_app_new/pages/transferin.dart';

class PaymentsuccessPage extends StatefulWidget {
  @override
  _PaymentsuccessPageState createState() => _PaymentsuccessPageState();
}

class _PaymentsuccessPageState extends State<PaymentsuccessPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // appBar: AppBar(
          //   iconTheme: IconThemeData(color: Colors.white),
          //   title: Text('แจ้งผลการรับชำระเงิน'),
          // ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50.0,
                ),
                Text(
                  'รับชำระเงินเรียบร้อย',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        // ignore: deprecated_member_use
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[500])),
                        child: Text(
                          'กลับหน้าหลัก',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          //Navigator.pushReplacementNamed(context, '/payment');
                          //Navigator.of(context).maybePop();
                          // Navigator.of(context, rootNavigator: true)
                          //     .pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MainTest(),
                            ),
                          );
                        },
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

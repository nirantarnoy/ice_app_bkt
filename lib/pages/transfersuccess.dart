import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/Transfer.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/transferout.dart';
import 'package:ice_app_new/pages/transferin.dart';

class TransfersuccessPage extends StatefulWidget {
  @override
  _TransfersuccessPageState createState() => _TransfersuccessPageState();
}

class _TransfersuccessPageState extends State<TransfersuccessPage> {
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
                  'ทำรายการโอนรถเรียบร้อย',
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
                      child: FlatButton(
                        color: Colors.blue[500],
                        child: Text(
                          'กลับหน้าหลัก',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
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

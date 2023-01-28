import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/assetcheck.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/customer_asset.dart';
import 'package:ice_app_new/pages/main_test.dart';

class AssetchecksuccessPage extends StatefulWidget {
  const AssetchecksuccessPage({Key key, this.customer_selected})
      : super(key: key);
  final String customer_selected;
  @override
  _AssetchecksuccessPageState createState() => _AssetchecksuccessPageState();
}

class _AssetchecksuccessPageState extends State<AssetchecksuccessPage> {
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
                  'บันทึกตรวจสอบเรียบร้อย',
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600]),
                        child: Text(
                          'ตรวจสอบต่อ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomerAssetPage(
                                  customer_selected: widget.customer_selected),
                            ),
                          );
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             OrderPage()),
                          //     (Route<dynamic> route) => false);
                        },
                      ),
                    ))
                  ],
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[500]),
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
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             OrderPage()),
                          //     (Route<dynamic> route) => false);
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

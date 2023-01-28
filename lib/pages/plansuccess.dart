import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/plan.dart';

class PlansuccessPage extends StatefulWidget {
  @override
  _PlansuccessPageState createState() => _PlansuccessPageState();
}

class _PlansuccessPageState extends State<PlansuccessPage> {
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
                  'บันทึกคำสั่งซื้อเรียบร้อย',
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
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[600])),
                        child: Text(
                          'สั่งสินค้าต่อ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlanPage(),
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
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[500])),
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

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:ice_app_new/models/products.dart';
import 'package:ice_app_new/models/reviewload.dart';
import 'package:ice_app_new/pages/issuesuccess.dart';
//import 'package:ice_app_new/pages/journalissue.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/sqlite/providers/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:provider/provider.dart';

class CarloadReviewPage extends StatefulWidget {
  static const routeName = '/carloadreview';
  @override
  _CarloadReviewState createState() => _CarloadReviewState();
}

class _CarloadReviewState extends State<CarloadReviewPage> {
  @override
  initState() {
    //_callDb();
    super.initState();
  }

  // Future _callDb() async {
  //   int chk_db = await DbHelper.instance.checkDB();
  //   print(chk_db);
  // }

  // Future deleteData() async {
  //   await DbHelper.instance.deleteCustpriceAll();
  // }

  // Future callapidata() async {
  //   await Provider.of<CustomerpriceData>(context, listen: false)
  //       .fetpriceonline();
  // }

  Widget _buildlist(List<ReviewLoadData> issue_items) {
    Widget productCards;
    if (issue_items.isNotEmpty) {
      if (issue_items.length > 0) {
        print("has list");
        productCards = new ListView.builder(
          itemCount: issue_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              issue_items[index].code.toString(),
              issue_items[index].name.toString(),
              issue_items[index].qty.toString(),
            );
          },
        );
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return productCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'รายการสินค้า',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ตรวจสอบสินค้าและจำนวน',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
            Expanded(
              child: Consumer<IssueData>(
                builder: (context, issues, _) => issues.listreview.isNotEmpty
                    ? _buildlist(issues.listreview)
                    : Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: 1 > 0 ? Colors.red[700] : Colors.red[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Text(
                              'ไม่รับ',
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
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('ยืนยัน'),
                          content: Text('คุณต้องการยืนยันการใช่หรือไม่'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<IssueData>(context, listen: false)
                                    .issueconfirmcancel();
                                // Navigator.of(context).pop(true);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IssuesuccessPage(),
                                  ),
                                );
                                // Navigator.of(context).pop(true);
                              },
                              child: Text('ยืนยัน'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('ไม่'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: 1 > 0 ? Colors.green[700] : Colors.green[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Text(
                              'รับสินค้า',
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
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('ยืนยัน'),
                          content: Text('คุณต้องการยืนยันการใช่หรือไม่'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<IssueData>(context, listen: false)
                                    .issueconfirm();

                                Provider.of<CustomerpriceData>(context,
                                        listen: false)
                                    .fetpriceonline(); // get customer price for offline
                                // Navigator.of(context).pop(true);
                                // deleteData(); // clear data before
                                // callapidata(); // insert data to sqlite
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IssuesuccessPage(),
                                  ),
                                );

                                // Navigator.of(context).pop(true);
                              },
                              child: Text('ยืนยัน'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('ไม่'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _code;
  final String _name;
  final String _qty;

  Items(
    this._code,
    this._name,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              "$_code",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            title: Text(
              "$_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            //  subtitle: Text("$_name"),
            trailing: Text("${_qty}",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800])),
          ),
          Divider(),
        ],
      ),
    );
  }
}

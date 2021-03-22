import 'package:flutter/material.dart';
import 'package:ice_app_new/models/delivery_route.dart';
import 'package:ice_app_new/pages/sale.dart';
import 'package:ice_app_new/pages/journalissue.dart';
import 'package:ice_app_new/widgets/journalissue/journalissue_item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';

import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../pages/order.dart';
import '../pages/products.dart';
import '../pages/payment.dart';

class MainTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTest();
  }
}

class _MainTest extends State<MainTest> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  String appTitle = 'เบิกสินค้า';
  String user_name = '';
  String user_email = '';
  String user_photo = '';
  String user_route_code = '';
  String user_car_name = '';

  @override
  void initState() {
    _getUserPrefer();
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  void _getUserPrefer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_name = prefs.getString("emp_name");
      user_photo = prefs.getString("emp_photo");
      user_route_code = prefs.getString("emp_route_name");
      user_car_name = prefs.getString("emp_car_name");
      //user_email = prefs.getString("");
    });
  }

  void _onTaped(int index) {
    print(index);
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        appTitle = 'เบิกสินค้า';
      }
      if (index == 1) {
        appTitle = 'ขายสินค้า';
      }
      if (index == 2) {
        appTitle = 'รับ-โอน';
      }
      if (index == 3) {
        appTitle = 'รับชำระเงิน';
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => OrderPage(widget.model)),
        // );
      }
      if (index == 3) {
        //_logout();
      }
    });
  }

  void show_Title_n_message_Flushbar(BuildContext context) {
    Flushbar(
      title: 'Success',
      message: 'Form Submitted successfully',
      icon: Icon(
        Icons.done_outline,
        size: 28,
        color: Colors.green.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showInfoFlushbar(BuildContext context) {
    FlushbarHelper.createInformation(
      message: 'บันทึกข้อมูลเรียบร้อย',
      title: 'แจ้งให้ทราบ',
      duration: const Duration(seconds: 5),
    ).show(context);
  }

  void _logoutaction(Function logout) async {
    Map<String, dynamic> successInformation;
    successInformation = await logout();
    if (successInformation['success']) {
      print('logout success');
      Navigator.of(context).pop();
    }
  }

  void _logout(UserData users) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ยืนยันการออกจากระบบ!',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "คุณต้องการออกจากระบบใช่หรือไม่",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ใช่',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () => _logoutaction(users.logout),
            ),
            FlatButton(
              child: Text('ไม่ใช่',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      JournalissuePage(),
      OrderPage(),
      null,
      PaymentPage(),
    ];
    // List<Widget> tabs = [null, null, null];
    // print('building main test page');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appTitle,
            style: TextStyle(fontFamily: 'Cloud-Bold', color: Colors.white),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     //color: Colors.white,
          //     icon: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       //showInfoFlushbar(context);
          //       show_Title_n_message_Flushbar(context);
          //       // showSearch(context: context, delegate: DataSearch());
          //     },
          //   ),
          //   (_currentIndex == 3)
          //       ? IconButton(
          //           //color: Colors.white,
          //           onPressed: () => {},
          //           icon: Icon(
          //             Icons.add_circle_outline,
          //             color: Colors.white,
          //           ),
          //         )
          //       : Container(),
          //   // IconButton(
          //   //     //color: Colors.white,
          //   //     icon: Icon(Icons.shopping_cart, color: Colors.white),
          //   //     onPressed: () {
          //   //       // Navigator.push(context,
          //   //       //     MaterialPageRoute(builder: (context) => CardPage()));
          //   //     }),
          // ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  "${user_name}",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  "${user_car_name}",
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${user_photo}"),
                  //  child: Text("NT"),
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    // child: Text("${user_route_code}"),
                    child: Text("${user_route_code}"),
                  ),
                ],
              ),
              ListTile(
                title: Text("Sycn ข้อมูล"),
                trailing: Icon(Icons.sync_alt_outlined),
              ),
              ListTile(
                title: Text("โหลดสินค้าขึ้นรถ"),
                trailing: Icon(Icons.insert_link),
              ),
              ListTile(
                title: Text("บันทึกขายออฟไลน์"),
                trailing: Icon(Icons.delivery_dining),
              ),
              Divider(),
              ListTile(
                title: Text("บันทึกขาย"),
                trailing: Icon(Icons.shopping_cart_outlined),
                onTap: () => {},
              ),
              Divider(),
              ListTile(
                title: Text("ตรวจสอบ ถัง/กระสอบ"),
                trailing: Icon(Icons.check),
                onTap: () => {},
              ),
              Divider(),
              ListTile(
                title: Text("ยืมสินค้า"),
                trailing: Icon(Icons.cached_outlined),
                onTap: () => {},
              ),
              Divider(),
              Consumer<UserData>(
                builder: (context, users, _) => ListTile(
                  title: Text("ออกจากระบบ"),
                  trailing: Icon(Icons.power_settings_new_sharp),
                  onTap: () => _logout(users),
                ),
              ),
            ],
          ),
        ),
        // body: Center(
        //   child: Text(
        //     'Vorapat Sales Mobile',
        //     style: TextStyle(color: Colors.blue, fontSize: 25.0),
        //   ),
        // ),
        body: tabs[_currentIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onTaped,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.pages_rounded), title: Text('เบิกสินค้า')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), title: Text('ขายสินค้า')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.transform_sharp), title: Text('รับ-โอน')),
                BottomNavigationBarItem(
                  icon: Icon(Icons.beenhere),
                  title: Text('รับชำระเงิน'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

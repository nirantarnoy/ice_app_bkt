import 'package:flutter/material.dart';
import 'package:ice_app/models/delivery_route.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';

import '../scoped-models/main.dart';
import '../pages/products.dart';
import '../pages/delivery_route.dart';
import '../pages/order.dart';
import '../pages/order_create.dart';

class MainTest extends StatefulWidget {
  final MainModel model;

  MainTest(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MainTest();
  }
}

class _MainTest extends State<MainTest> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  String appTitle = 'วรภัทร ไอซ์';

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  void _onTaped(int index) {
    print(index);
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        appTitle = 'เส้นทาง';
      }
      if (index == 1) {
        appTitle = 'รายการสินค้า';
      }
      if (index == 2) {
        appTitle = 'ส่งสินค้าสำเร็จ';
      }
      if (index == 3) {
        appTitle = 'ออเดอร์ใหม่';
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

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      // HomePage(widget.model),
      //RoomsPage(widget.model),
      //  null,
      // CustomersPage(widget.model),
      // ExamPage(widget.model),
      // SemesterPage(widget.model),
      // LeavePage(widget.model),
      DeliveryRoutePage(widget.model),
      // null,
      null,
      null,
      OrderPage(widget.model),
    ];
    // List<Widget> tabs = [null, null, null];
    print('building main test page');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appTitle,
          style: TextStyle(fontFamily: 'Cloud-Bold', color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            //color: Colors.white,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              //showInfoFlushbar(context);
              show_Title_n_message_Flushbar(context);
              // showSearch(context: context, delegate: DataSearch());
            },
          ),
          (_currentIndex == 3)
              ? IconButton(
                  //color: Colors.white,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderCreatePage(widget.model))),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                )
              : Container(),
          // IconButton(
          //     //color: Colors.white,
          //     icon: Icon(Icons.shopping_cart, color: Colors.white),
          //     onPressed: () {
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => CardPage()));
          //     }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "Niran Tarlek",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                "sale01@vorapat.com",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("NT"),
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("NT"),
                ),
              ],
            ),
            ListTile(
              title: Text("บันทึกส่งของ"),
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
            ListTile(
              title: Text("ออกจากระบบ"),
              trailing: Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTaped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.map), title: Text('เส้นทาง')),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('รายการส่งสินค้า')),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              title: Text('ส่งสินค้าสำเร็จ')),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases_outlined),
            title: Text('ออเดอร์ใหม่'),
          ),
        ],
      ),
    );
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/page_offline/customer_price.dart';
import 'package:ice_app_new/page_offline/orderoffline.dart';
import 'package:ice_app_new/page_offline/product_issue.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ice_app_new/models/delivery_route.dart';
import 'package:ice_app_new/pages/auth.dart';
import 'package:ice_app_new/pages/blue_print.dart';
import 'package:ice_app_new/pages/checkinpage.dart';
import 'package:ice_app_new/pages/createorder_boot.dart';
import 'package:ice_app_new/pages/customer_asset.dart';
import 'package:ice_app_new/pages/customerpaymentlist.dart';
import 'package:ice_app_new/pages/home.dart';
import 'package:ice_app_new/pages/home_offline.dart';
// import 'package:ice_app_new/pages/issuesuccess.dart';
import 'package:ice_app_new/pages/journalissue.dart';
import 'package:ice_app_new/pages/offlinetest.dart';
// import 'package:ice_app_new/pages/offlinetest.dart';
import 'package:ice_app_new/pages/order_print.dart';
// import 'package:ice_app_new/pages/paymentsuccess.dart';
import 'package:ice_app_new/pages/plan.dart';
// import 'package:ice_app_new/pages/print_bluetooth.dart';
import 'package:ice_app_new/pages/qrscan.dart';
import 'package:ice_app_new/pages/stepper.dart';
// import 'package:ice_app_new/pages/take_photo.dart';
// import 'package:ice_app_new/widgets/journalissue/journalissue_item.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';

import 'package:provider/provider.dart';

// import '../models/user.dart';
import '../providers/user.dart';
import '../pages/order.dart';
// import '../pages/products.dart';
import '../pages/payment.dart';
// import '../pages/transfer.dart';

class MainTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTest();
  }
}

class _MainTest extends State<MainTest> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  String appTitle = '';
  String user_name = '';
  String user_email = '';
  String user_photo = '';
  String user_route_code = '';
  String user_car_name = '';

  bool _networkisok = false;

  @override
  void initState() {
    _checkinternet();
    _getUserPrefer();
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      Theme.of(context).accentColor;
      setState(() {
        _networkisok = false;
      });
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
        appTitle = '';
      }
      if (index == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => JournalissuePage()));
        appTitle = 'หน้าหลัก';
        _currentIndex = 0;
      }
      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderPage()));
        appTitle = 'รายการขายสินค้า';
        _currentIndex = 0;
      }
      if (index == 3) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaymentPage()));
        appTitle = 'รับชำระเงิน';
        _currentIndex = 0;
        // Navigator.of(context).pushNamed(PaymentPage
        //     .routeName); //กระโดดไปหน้าใหม่ ไม่แสดง bottontab ข้างล่าง
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckinPage()));
      // Navigator.of(context).pop();
    }
  }

  void _logout(UserData users) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              Icon(
                Icons.privacy_tip_outlined,
                size: 32,
                color: Colors.lightGreen,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'ยืนยันการทำรายการ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'ต้องการออกจากระบบใช่หรือไม่',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () => _logoutaction(users.logout),
                      child: Text('ใช่'),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: MaterialButton(
                      color: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('ไม่ใช่'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(
    //         'ยืนยันการออกจากระบบ!',
    //         style: TextStyle(
    //           fontSize: 20.0,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       content: Text(
    //         "คุณต้องการออกจากระบบใช่หรือไม่",
    //         style: TextStyle(color: Colors.red),
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('ใช่',
    //               style: TextStyle(
    //                 fontSize: 20.0,
    //                 fontWeight: FontWeight.bold,
    //               )),
    //           onPressed: () => _logoutaction(users.logout),
    //         ),
    //         FlatButton(
    //           child: Text('ไม่ใช่',
    //               style: TextStyle(
    //                 fontSize: 20.0,
    //                 fontWeight: FontWeight.bold,
    //               )),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      //JournalissuePage(),
      _networkisok == true ? HomePage() : HomeOfflinePage(),
      null,
      null,
      null
      //PaymentPage(),
    ];
    // List<Widget> tabs = [null, null, null];
    // print('building main test page');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            appTitle,
            style: TextStyle(color: Colors.white),
            //      style: TextStyle(fontFamily: 'Cloud-Bold', color: Colors.white),
          ),
          // actions: <Widget>[
          //   // IconButton(
          //   //   //color: Colors.white,
          //   //   icon: Icon(
          //   //     // Icons.keyboard_control_outlined,
          //   //     Icons.more_vert,
          //   //     color: Colors.white,
          //   //   ),
          //   //   onPressed: () {
          //   //     //showInfoFlushbar(context);
          //   //     show_Title_n_message_Flushbar(context);
          //   //     // showSearch(context: context, delegate: DataSearch());
          //   //   },
          //   // ),
          //   PopupMenuButton<String>(
          //     onSelected: (String result) {
          //       switch (result) {
          //         case 'option1':
          //           print('option 1 clicked');
          //           break;
          //         case 'option2':
          //           print('option 2 clicked');
          //           break;
          //         case 'delete':
          //           print('I want to delete');
          //           break;
          //         default:
          //       }
          //     },
          //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //       const PopupMenuItem<String>(
          //         value: 'option1',
          //         child: Text('สายส่ง 1'),
          //       ),
          //       const PopupMenuItem<String>(
          //         value: 'option2',
          //         child: Text('สายส่ง 2'),
          //       ),
          //       const PopupMenuItem<String>(
          //         value: 'delete',
          //         child: Text('สายส่ง 3'),
          //       ),
          //     ],
          //   )
          //   // (_currentIndex == 3)
          //   //     ? IconButton(
          //   //         //color: Colors.white,
          //   //         onPressed: () => {},
          //   //         icon: Icon(
          //   //           Icons.add_circle_outline,
          //   //           color: Colors.white,
          //   //         ),
          //   //       )
          //   //     : Container(),
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
                accountEmail: Row(
                  children: <Widget>[
                    Icon(Icons.drive_eta_rounded),
                    SizedBox(width: 10),
                    Text(
                      "${user_car_name}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPrintPage(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   title: Text("ขายออกบูธ"),
              //   trailing: Icon(Icons.shopping_bag_outlined),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CreateorderBootPage(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                title: Text("รับคำสั่งซื้อ"),
                trailing: Icon(Icons.shopping_cart_outlined),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanPage(),
                    ),
                  );
                },
              ),

              // ListTile(
              //   title: Text("บันทึกขายออฟไลน์"),
              //   trailing: Icon(Icons.delivery_dining),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             ProductsPage(), // StepperPage(), //OfflinePage(),
              //       ),
              //     );
              //   },
              // ),

              ListTile(
                title: Text("บันทึกขายออฟไลน์"),
                trailing: Icon(Icons.delivery_dining),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomerpricePage(), // StepperPage(), //OfflinePage(),OrderofflinePage()
                    ),
                  );
                },
              ),
              Divider(),
              // ListTile(
              //   title: Text("บันทึกขาย"),
              //   trailing: Icon(Icons.shopping_cart_outlined),
              //   onTap: () => {},
              // ),
              // Divider(),
              ListTile(
                title: Text("ตรวจสอบ ถัง/กระสอบ"),
                trailing: Icon(Icons.camera_alt_outlined),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerAssetPage(),
                    ),
                  )
                  //  Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TakePictureScreen(),),)
                },
              ),
              // ListTile(
              //   title: Text("QR Scan"),
              //   trailing: Icon(Icons.qr_code_scanner_sharp),
              //   onTap: () => {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => QrscanPage()))
              //   },
              // ),
              // TakePictureScreen()
              // Divider(),
              // ListTile(
              //   title: Text("ยืมสินค้า"),
              //   trailing: Icon(Icons.cached_outlined),
              //   onTap: () => {},
              // ),
              Divider(),
              ListTile(
                title: Text("ตั้งค่าเครื่องพิมพ์"),
                trailing: Icon(Icons.print),
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BluePrintPage()))
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PrintBluetoothPage()))
                },
              ),
              Divider(),
              ListTile(
                title: Text("ลูกค้าที่ต้องชำระเงิน"),
                trailing: Icon(Icons.money),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerPaymentListPage()))
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PrintBluetoothPage()))
                },
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
                    icon: Icon(Icons.home), label: 'หน้าหลัก'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.transform_sharp), label: 'สินค้า'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'ขายสินค้า'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.beenhere),
                  label: 'รับชำระเงิน',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

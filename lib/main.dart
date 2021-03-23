import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:provider/provider.dart';

import 'pages/auth.dart';

import 'providers/product.dart';
import 'providers/customer.dart';
import 'providers/user.dart';
import 'providers/order.dart';
import 'providers/issuedata.dart';
import 'providers/paymentreceive.dart';
import 'pages/main_test.dart';

import 'pages/order.dart';
import 'pages/orderdetail.dart';
import 'pages/createorder.dart';
import 'pages/payment.dart';

//import 'pages/photo_cap.dart';

//void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    // setState(() {
    //   _isAuthenticated = false;
    // });
    // _model.autoAuthenticate();
    // _model.userSubject.listen((bool isAuthenticated) {
    //   setState(() {
    //     _isAuthenticated = isAuthenticated;
    //   });
    // });

    super.initState();
  }

  // void checkAuthen(UserData userdata) {
  //   userdata.autoAuthenticate();
  //   setState(() {
  //     _isAuthenticated = userdata.is_authenuser;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final UserData users = Provider.of<UserData>(context);
    // checkAuthen(users);
    print('building main page');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>.value(value: UserData()),
        ChangeNotifierProvider<ProductData>.value(value: ProductData()),
        ChangeNotifierProvider<CustomerData>.value(value: CustomerData()),
        ChangeNotifierProvider<OrderData>.value(value: OrderData()),
        ChangeNotifierProvider<IssueData>.value(value: IssueData()),
        ChangeNotifierProvider<PaymentreceiveData>.value(
            value: PaymentreceiveData()),
        ChangeNotifierProvider<TransferoutData>.value(value: TransferoutData()),
        ChangeNotifierProvider<TransferinData>.value(value: TransferinData())
      ],
      child: Consumer(builder: (context, UserData users, _) {
        // checkAuthen(users);
        users.autoAuthenticate();
        return MaterialApp(
          // debugShowMaterialGrid: true,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.lightBlue,
              accentColor: Colors.lightBlue,
              buttonColor: Colors.blue,
              fontFamily: 'Kanit-Regular'),
          home: users.is_authenuser ? MainTest() : AuthPage(),
          routes: {
            OrderPage.routeName: (ctx) => OrderPage(),
            OrderDetailPage.routeName: (ctx) => OrderDetailPage(),
            CreateorderPage.routeName: (ctx) => CreateorderPage(),
            PaymentPage.routeName: (ctx) => PaymentPage(),
          },
        );
      }),
    );
  }
}

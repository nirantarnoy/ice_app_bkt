import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'pages/auth.dart';

import 'providers/product.dart';
import 'providers/customer.dart';
import 'providers/user.dart';
import 'providers/issuedata.dart';
import 'pages/main_test.dart';
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
    setState(() {
      _isAuthenticated = false;
    });
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
          ChangeNotifierProvider<IssueData>.value(value: IssueData())
        ],
        child: Consumer<UserData>(
          builder: (context, UserData users, _) => (MaterialApp(
            // debugShowMaterialGrid: true,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.lightBlue,
                accentColor: Colors.lightBlue,
                buttonColor: Colors.blue,
                fontFamily: 'Kanit-Regular'),
            home: users.is_authenuser ? MainTest() : AuthPage(),
            // routes: {
            //   '/': (BuildContext context) => !_isAuthenticated
            //       ? MainTest()
            //       : MainTest(), //LandingScreen MainTest(_model)
            //   '/admin': (BuildContext context) =>
            //       !_isAuthenticated ? MainTest() : MainTest(),
            // },
            // onGenerateRoute: (RouteSettings settings) {
            //   if (!_isAuthenticated) {
            //     return MaterialPageRoute<bool>(
            //       builder: (BuildContext context) => MainTest(),
            //     );
            //   }
            //   final List<String> pathElements = settings.name.split('/');
            //   if (pathElements[0] != '') {
            //     return null;
            //   }

            //   return null;
            // },
            // onUnknownRoute: (RouteSettings settings) {
            //   return MaterialPageRoute(
            //       builder: (BuildContext context) =>
            //           !_isAuthenticated ? MainTest() : MainTest());
            // },
          )),
        ));
  }
}

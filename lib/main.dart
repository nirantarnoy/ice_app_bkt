import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/auth.dart';

import 'pages/main_page.dart';
import 'scoped-models/main.dart';
import 'pages/main_test.dart';
import 'pages/photo_cap.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building main page');
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.lightBlue,
            buttonColor: Colors.blue,
            fontFamily: 'Kanit-Regular'),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => !_isAuthenticated
              ? MainTest(_model)
              : MainPage(_model), //LandingScreen MainTest(_model)
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? MainTest(_model) : MainPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : MainPage(_model));
        },
      ),
    );
  }
}

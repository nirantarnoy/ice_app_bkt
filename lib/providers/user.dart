import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ice_app_new/models/user.dart';

class UserData with ChangeNotifier {
  final String url_to_user_list =
      //    "http://192.168.1.120/icesystem/frontend/web/api/customer/list";
      // "http://103.13.28.31/icesystem/frontend/web/api/customer/list";
      //  "http://103.13.28.31/icesystem/frontend/web/api/customer/list";
      "http://103.13.28.31/icesystem/frontend/web/api/customer/list";
  // "http://103.13.28.31/icesystem/frontend/web/api/customer/list";
  final String url_to_user_login =
      //  "http://192.168.1.120/icesystem/frontend/web/api/authen/login";
      // "http://103.13.28.31/icesystem/frontend/web/api/authen/login";
      // "http://103.13.28.31/icesystem/frontend/web/api/authen/login";
      "http://103.13.28.31/icesystem/frontend/web/api/authen/login";
  final String url_to_user_login_qrcode =
      //  "http://192.168.1.120/icesystem/frontend/web/api/authen/login";
      // "http://103.13.28.31/icesystem/frontend/web/api/authen/login";
      // "http://103.13.28.31/icesystem/frontend/web/api/authen/login";
      "http://103.13.28.31/icesystem/frontend/web/api/authen/loginqrcode";

  User _authenticatedUser;
  Timer _authTimer;

  List<User> _user;
  List<User> _userlogin;
  List<User> get listuser => _user;
  List<User> get listuserlogin => _userlogin;
  bool _isLoading = false;
  bool _isauthenuser = false;

  int _id = 0;
  int get idUser => _id;

  String _route_type = "1";
  String get routeType => _route_type;

  set idUser(int val) {
    _id = val;
    notifyListeners();
  }

  set routeType(String val) {
    _route_type = val;
    notifyListeners();
  }

  set listuser(List<User> val) {
    _user = val;
    notifyListeners();
  }

  set listuserlogin(List<User> val) {
    _userlogin = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_authenuser {
    return _isauthenuser;
  }

  Future<dynamic> login(String username, String password) async {
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };
    //   print(username);
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_user_login),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<User> data = [];
        print('user login is ${res["data"].length}');
        print('data user is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final User userresult = User(
          id: res['data'][0]['user_id'].toString(),
          username: res['data'][0]['username'].toString(),
          emp_id: res['data'][0]['emp_id'].toString(),
          emp2_id: res['data'][0]['emp2_id'].toString(),
          emp_code: res['data'][0]['emp_code'].toString(),
          emp_name: res['data'][0]['emp_name'].toString(),
          emp_photo: res['data'][0]['emp_photo'].toString(),
          emp_route_id: res['data'][0]['emp_route_id'].toString(),
          emp_route_name: res['data'][0]['emp_route_name'].toString(),
          emp_car_id: res['data'][0]['emp_car_id'].toString(),
          emp_car_name: res['data'][0]['emp_car_name'].toString(),
          company_id: res['data'][0]['company_id'].toString(),
          branch_id: res['data'][0]['branch_id'].toString(),
          route_type: res['data'][0]['route_type'].toString(),
        );

        data.add(userresult);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: 160000));
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('user_id', res['data'][0]['user_id'].toString());
        prefs.setString('emp_id', res['data'][0]['emp_id'].toString());
        prefs.setString('emp2_id', res['data'][0]['emp2_id'].toString());
        prefs.setString('emp_code', res['data'][0]['emp_code'].toString());
        prefs.setString('emp_name', res['data'][0]['emp_name'].toString());
        prefs.setString('emp_photo', res['data'][0]['emp_photo'].toString());
        prefs.setString(
            'emp_route_name', res['data'][0]['emp_route_name'].toString());
        prefs.setString(
            'emp_route_id', res['data'][0]['emp_route_id'].toString());
        prefs.setString('emp_car_id', res['data'][0]['emp_car_id'].toString());
        prefs.setString(
            'emp_car_name', res['data'][0]['emp_car_name'].toString());
        prefs.setString('company_id', res['data'][0]['company_id'].toString());
        prefs.setString('branch_id', res['data'][0]['branch_id'].toString());
        //  prefs.setString('route_type', res['data'][0]['route_type'].toString());

        prefs.setString('expiryTime', expiryTime.toIso8601String());
        prefs.setString('working_mode', 'online');

        // set route type
        routeType = res['data'][0]['route_type'].toString();

        print('route type is ${routeType}');

        listuserlogin = data;
        _isauthenuser = true;
        _isLoading = false;
        return listuserlogin;
      } else {
        print('server not status 200');
      }
    } catch (_) {
      _isauthenuser = false;
    }
  }

  Future<dynamic> loginwithqr(String car, String driver, String memeber) async {
    final Map<String, dynamic> loginData = {
      'car': car,
      'driver': driver,
      'password': '',
      'member': memeber
    };
    print(loginData);
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_user_login_qrcode),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<User> data = [];
        print('user login is ${res["data"].length}');
        print('data user is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['status'].toString() == "1") {
          final User userresult = User(
            id: res['data'][0]['user_id'].toString(),
            username: res['data'][0]['username'].toString(),
            emp_id: res['data'][0]['emp_id'].toString(),
            emp2_id: res['data'][0]['emp2_id'].toString(),
            emp_code: res['data'][0]['emp_code'].toString(),
            emp_name: res['data'][0]['emp_name'].toString(),
            emp_photo: res['data'][0]['emp_photo'].toString(),
            emp_route_id: res['data'][0]['emp_route_id'].toString(),
            emp_route_name: res['data'][0]['emp_route_name'].toString(),
            emp_car_id: res['data'][0]['emp_car_id'].toString(),
            emp_car_name: res['data'][0]['emp_car_name'].toString(),
            company_id: res['data'][0]['company_id'].toString(),
            branch_id: res['data'][0]['branch_id'].toString(),
            route_type: res['data'][0]['route_type'].toString(),
            login_shift: res['data'][0]['login_shift'].toString(),
          );

          data.add(userresult);

          final DateTime now = DateTime.now();
          final DateTime expiryTime = now.add(Duration(seconds: 160000));
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('user_id', res['data'][0]['user_id'].toString());
          prefs.setString('emp_id', res['data'][0]['emp_id'].toString());
          prefs.setString('emp2_id', res['data'][0]['emp2_id'].toString());
          prefs.setString('emp_code', res['data'][0]['emp_code'].toString());
          prefs.setString('emp_name', res['data'][0]['emp_name'].toString());
          prefs.setString('emp_name_2', res['data'][0]['emp_name2'].toString());
          prefs.setString('emp_photo', res['data'][0]['emp_photo'].toString());
          prefs.setString(
              'emp_route_name', res['data'][0]['emp_route_name'].toString());
          prefs.setString(
              'emp_route_id', res['data'][0]['emp_route_id'].toString());
          prefs.setString(
              'emp_car_id', res['data'][0]['emp_car_id'].toString());
          prefs.setString(
              'emp_car_name', res['data'][0]['emp_car_name'].toString());
          prefs.setString(
              'company_id', res['data'][0]['company_id'].toString());
          prefs.setString('branch_id', res['data'][0]['branch_id'].toString());
          // prefs.setString('route_type', res['data'][0]['route_type'].toString());

          prefs.setString('expiryTime', expiryTime.toIso8601String());
          prefs.setString('working_mode', 'online');

          routeType = res['data'][0]['route_type'].toString();
          prefs.setString(
              'login_shift', res['data'][0]['login_shift'].toString());

          listuserlogin = data;
          _isauthenuser = true;
          _isLoading = false;
          return listuserlogin;
        } else {
          _isauthenuser = false;
          _isLoading = false;
          return listuserlogin;
        }
      } else {
        print('server not status 200');
      }
    } catch (_) {
      _isauthenuser = false;
    }
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    final DateTime now = DateTime.now();
    final parsedExpiryTime = DateTime.parse(expiryTimeString);
    if (parsedExpiryTime.isBefore(now)) {
      _authenticatedUser = null;
      notifyListeners();
      return;
    }
    final String emp_id = prefs.getString('emp_id');
    final String emp2_id = prefs.getString('emp2_id');
    final String emp_code = prefs.getString('emp_code');
    final String emp_name = prefs.getString('emp_name');
    final String userId = prefs.getString('user_id');
    final String emp_photo = prefs.getString('user_photo');
    final String emp_route_id = prefs.getString('emp_route_id');
    final String emp_route_name = prefs.getString('emp_route_name');
    final String emp_car_id = prefs.getString('emp_car_id');
    final String emp_car_name = prefs.getString('emp_car_name');
    final String company_id = prefs.getString('company_id');
    final String branch_id = prefs.getString('branch_id');
    final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
    _authenticatedUser = User(
        id: userId,
        emp_id: emp_id,
        emp2_id: emp2_id,
        emp_code: emp_code,
        emp_name: emp_name,
        emp_photo: emp_photo,
        username: null,
        emp_route_id: emp_route_id,
        emp_car_id: emp_car_id,
        emp_car_name: emp_car_name,
        emp_route_name: emp_route_name,
        company_id: company_id,
        branch_id: branch_id);
    _isauthenuser = true;
    setAuthTimeout(tokenLifespan);
    notifyListeners();
  }

  Future<Null> getUserAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      User _currentinfo;

      _currentinfo = new User(
          id: prefs.getString('userId'),
          emp_id: prefs.getString('emp_id'),
          emp2_id: prefs.getString('emp2_id'),
          emp_code: prefs.getString('emp_code'),
          emp_name: prefs.getString('emp_name'),
          emp_photo: prefs.getString('emp_photo'),
          username: null,
          emp_route_id: prefs.getString('emp_route_id'),
          emp_car_id: prefs.getString('emp_car_id'),
          emp_car_name: prefs.getString('emp_car_name'),
          emp_route_name: prefs.getString('emp_route_name'),
          company_id: prefs.getString('company_id'),
          branch_id: prefs.getString('branch_id'));
      return _currentinfo;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    _authenticatedUser = null;
    _isauthenuser = false;
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.remove('token');
    // prefs.remove('username');
    // prefs.remove('userId');
    // prefs.remove('studentId');
    _isLoading = false;

    return {'success': true};
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  // Future<dynamic> fetUser() async {
  //   final Map<String, dynamic> filterData = {'route_id': 5};
  //   // _isLoading = true;
  //   notifyListeners();
  //   try {
  //     http.Response response;
  //     response = await http.post(
  //       Uri.parse(url_to_user_list),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(filterData),
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       List<User> data = [];
  //       print('data customer length is ${res["data"].length}');
  //       //    print('data server is ${res["data"]}');

  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return;
  //       }

  //       for (var i = 0; i < res['data'].length - 1; i++) {
  //         // var product = User.fromJson(res[i]);
  //         //print(res['data'][i]['code']);
  //         // data.add(product);
  //         final User userresult = User(
  //             id: res['data'][i]['user_id'].toString(),
  //             username: res['data'][i]['username'].toString(),
  //             emp_code: res['data'][i]['emp_code'].toString(),
  //             emp_name: res['data'][i]['emp_name'].toString(),
  //             emp_photo: res['data'][i]['emp_photo'].toString());

  //         //  print('data from server is ${userresult}');
  //         data.add(userresult);
  //       }

  //       listuser = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listuser;
  //     }
  //   } catch (_) {}
  // }

  // Future<Orders> getDetails() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(Uri.parse(url_to_user),
  //         headers: {'Content-Type': 'application/json'});

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       List<Orders> data = [];
  //       print('data length is ${res["data"].length}');
  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return null;
  //       }
  //       for (var i = 0; i < res['data'].length - 1; i++) {
  //         final Orders orderresult = Orders(
  //           id: res['data'][i]['id'],
  //           order_no: res['data'][i]['order_no'],
  //           order_date: res['data'][i]['order_date'],
  //           customer_name: res['data'][i]['customer_name'],
  //           note: res['data'][i]['note'],
  //         );

  //         data.add(orderresult);
  //       }

  //       listuser = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listuser;
  //     }
  //   } catch (_) {}
  // }
}

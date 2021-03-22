import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ice_app_new/models/user.dart';

class UserData with ChangeNotifier {
  final String url_to_user_list =
      "http://192.168.1.120/icesystem/frontend/web/api/customer/list";
  // "http://192.168.60.118/icesystem/frontend/web/api/customer/list";
  //"http://119.59.100.74/icesystem/frontend/web/api/customer/list";
  final String url_to_user_login =
      "http://192.168.1.120/icesystem/frontend/web/api/authen/login";
  //"http://192.168.60.118/icesystem/frontend/web/api/authen/login";
  // "http://119.59.100.74/icesystem/frontend/web/api/customer/detail";

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

  set idUser(int val) {
    _id = val;
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
      response = await http.post(Uri.encodeFull(url_to_user_login),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<User> data = [];
        print('user login is ${res["data"].length}');
        print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        final User userresult = User(
          id: res['data'][0]['user_id'].toString(),
          username: res['data'][0]['username'].toString(),
          emp_code: res['data'][0]['emp_code'].toString(),
          emp_name: res['data'][0]['emp_name'].toString(),
          emp_photo: res['data'][0]['emp_photo'].toString(),
          emp_route_id: res['data'][0]['emp_route_id'].toString(),
          emp_route_name: res['data'][0]['emp_route_name'].toString(),
          emp_car_id: res['data'][0]['emp_car_id'].toString(),
          emp_car_name: res['data'][0]['emp_car_name'].toString(),
        );

        data.add(userresult);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: 160000));
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('user_id', res['data'][0]['user_id'].toString());
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

        prefs.setString('expiryTime', expiryTime.toIso8601String());

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
    final String emp_code = prefs.getString('emp_code');
    final String emp_name = prefs.getString('emp_name');
    final String userId = prefs.getString('user_id');
    final String emp_photo = prefs.getString('user_photo');
    final String emp_route_id = prefs.getString('emp_route_id');
    final String emp_route_name = prefs.getString('emp_route_name');
    final String emp_car_id = prefs.getString('emp_car_id');
    final String emp_car_name = prefs.getString('emp_car_name');
    final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
    _authenticatedUser = User(
        id: userId,
        emp_code: emp_code,
        emp_name: emp_name,
        emp_photo: emp_photo,
        username: null,
        emp_route_id: emp_route_id,
        emp_car_id: emp_car_id,
        emp_car_name: emp_car_name,
        emp_route_name: emp_route_name);
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
          emp_code: prefs.getString('emp_code'),
          emp_name: prefs.getString('emp_name'),
          emp_photo: prefs.getString('emp_photo'),
          username: null,
          emp_route_id: prefs.getString('emp_route_id'),
          emp_car_id: prefs.getString('emp_car_id'),
          emp_car_name: prefs.getString('emp_car_name'),
          emp_route_name: prefs.getString('emp_route_name'));
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
  //       Uri.encodeFull(url_to_user_list),
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
  //     response = await http.get(Uri.encodeFull(url_to_user),
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

import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/auth.dart';
import '../models/user.dart';

mixin ConnectedUserModel on Model {
  User _authenticatedUser;
  bool _isLoading = false;
  // final url = "http://192.168.1.103/school/backend/web/index.php?r=site/apilogin";http://localhost/testapi/login.php
  // final url_user =
  //     "http://192.168.1.101/icesystem/backend/web/index.php?r=member/get-member";
  final url_user =
      "http://192.168.1.101/icesystem/backend/web/index.php?r=member/api-login";
}

mixin UsersModel on ConnectedUserModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(
      String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password
    };
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("auth data before send: ${authData}");
    http.Response response;
    if (1 > 0) {
      response = await http.post(
        Uri.encodeFull(url_user),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authData),
      );
    }

    bool hasError = true;
    String message = 'Username หรือ Password ไม่ถูกต้อง';
    print("auth data: ${authData}");
    print("api status: ${response.statusCode}");
    print("api body: ${response.body}");
    if (response.statusCode == 200) {
      print("api body: ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // print(responseData['data'][0]['fname']);
      if (responseData['data'].length > 0 &&
          responseData['data'][0]['user_id'] != '') {
        hasError = false;
        message = 'Authentication succeeded!';
        _authenticatedUser = User(
            id: responseData['data'][0]['user_id'].toString(),
            username: username,
            token: responseData['data'][0]['idToken']);
        setAuthTimeout(160000);
        //  setAuthTimeout(int.parse(responseData['data']['expiresIn']));

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: 160000));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseData['data'][0]['idToken']);
        prefs.setString('username', username);
        prefs.setString('userId', responseData['data'][0]['user_id']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
      } else {
        bool hasError = true;
        String message = 'Username หรือ Password ไม่ถูกต้อง.';
      }
    } else {
      bool hasError = true;
      String message = 'พบข้อผิดพลาดเกี่ยวกับการเชื่อมต่อ';
    }

    _isLoading = false;
    autoAuthenticate();
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String username = prefs.getString('username');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, username: username, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    prefs.remove('userId');
    _isLoading = false;
    return {'success': true};
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedUserModel {
  bool get isLoading {
    return _isLoading;
  }
}

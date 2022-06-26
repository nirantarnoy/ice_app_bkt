import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ice_app_new/pages/auth.dart';

import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../models/user.dart';
import '../models/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CheckinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckinPageState();
  }
}

class _CheckinPageState extends State<CheckinPage> {
  final Map<String, dynamic> _formData = {
    'username': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  Color car_check_color = Colors.grey[200];
  Color car_driver_color = Colors.grey[200];
  Color car_member_color = Colors.grey[200];
  Color car_route_color = Colors.grey[200];
  bool is_car_scan = false;
  bool is_driver_scan = false;
  bool is_member_scan = false;
  bool is_already_scan = false;
  bool is_different_route = false;
  String qrCode = 'Scan result';
  String car_data = '';
  String driver_data = '';
  String member_data = '';
  int _index = 0;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/logo.jpg'),
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'vorapat ice',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70.0,
          child: Image.asset('assets/VP.png'),
          // child: Text('ICE',
          //     style: TextStyle(
          //         fontSize: 38.0,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white)),
        ),
      ),
    );
  }

  Future<bool> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return false;
      setState(() {
        this.qrCode = qrCode;
        if (this.qrCode != '-1') {
          if (car_data == '' && is_car_scan == false) {
            car_data = this.qrCode;
            is_car_scan = true;
            car_check_color = Colors.green;
            print(qrCode);
            return true;
          }
          if (driver_data == '' &&
              is_driver_scan == false &&
              is_car_scan == true) {
            driver_data = this.qrCode;
            is_driver_scan = true;
            car_driver_color = Colors.green;
            return true;
          }
          if (member_data == '' &&
              is_member_scan == false &&
              is_driver_scan == true &&
              is_car_scan == true) {
            member_data = this.qrCode;
            is_member_scan = true;
            car_member_color = Colors.green;
            return true;
          }
        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version';
    }
  }

  void _submitForm2(Function loginqrcode) async {
    if (car_data == '' && driver_data == '') {
      return;
    }
    // print('car is ${car_data.substring(0, 3)}');
    if (car_data.substring(0, 3) != "CAR" ||
        car_data.substring(0, 3) != "BTC") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('พบข้อผิดพลาด!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            content: Text('กรุณาสแกนรหัสรถใหม่ที่ขึ้นต้นด้วย CAR หรือ BTC'),
            actions: <Widget>[
              FlatButton(
                child: Text('ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
      return;
    }

    List<User> successInformation;
    successInformation = await loginqrcode(car_data, driver_data, member_data);

    if (successInformation != null) {
      Navigator.pushReplacementNamed(context, '/');
      //print(successInformation);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('พบข้อผิดพลาด!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            content: Text('ข้อมูลไม่ครบถ้วนหรือไม่ถูกต้อง'),
            actions: <Widget>[
              FlatButton(
                child: Text('ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
    //Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final UserData users = Provider.of<UserData>(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'Login to system',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _showLogo(),
                      // Text('VP ICE',
                      //     style: TextStyle(
                      //         fontSize: 50,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.blue[700])),

                      Text(
                        'สแกนข้อมูลให้ครบถ้วนตามลำดับ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('เปลี่ยนสายส่ง'),
                              Switch(
                                  value: is_different_route,
                                  onChanged: (value) {
                                    setState(() {
                                      is_different_route = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                      is_different_route == true
                          ? Row(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.alt_route,
                                    size: 50.0,
                                    color: car_check_color,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'สายส่ง',
                                    style: TextStyle(
                                        color: car_check_color, fontSize: 24.0),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.directions_car,
                              size: 50.0,
                              color: car_check_color,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'รถ',
                              style: TextStyle(
                                  color: car_check_color, fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: car_driver_color,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'คนขับ',
                              style: TextStyle(
                                  color: car_driver_color, fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.account_box,
                              size: 50.0,
                              color: car_member_color,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'คนติดตาม',
                              style: TextStyle(
                                  color: car_member_color, fontSize: 24.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      is_car_scan == false ||
                              is_driver_scan == false ||
                              is_member_scan == false
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                              child: SizedBox(
                                height: 45.0,
                                width: targetWidth,
                                child: new RaisedButton(
                                    elevation: 5,
                                    splashColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    color: Colors.blue[700],
                                    child: new Text(
                                        is_car_scan == false
                                            ? 'สแกนรถ'
                                            : is_car_scan == true &&
                                                    is_driver_scan == false
                                                ? 'สแกนคนขับ'
                                                : 'สแกนคนติดตาม',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () {
                                      scanQRCode();
                                    }),
                              ),
                            )
                          : Text(''),
                      is_car_scan == true ||
                              is_driver_scan == true ||
                              is_member_scan == true
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                              child: SizedBox(
                                height: 45.0,
                                width: targetWidth,
                                child: new RaisedButton(
                                    elevation: 5,
                                    splashColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    color: Colors.grey[700],
                                    child: new Text('ล้างข้อมูล',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () {
                                      setState(() {
                                        is_car_scan = false;
                                        is_driver_scan = false;
                                        is_member_scan = false;
                                        car_data = '';
                                        member_data = '';
                                        driver_data = '';
                                        car_check_color = Colors.grey[200];
                                        car_driver_color = Colors.grey[200];
                                        car_member_color = Colors.grey[200];
                                      });
                                    }),
                              ),
                            )
                          : Text(''),
                      is_car_scan == true && is_driver_scan == true
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                              child: SizedBox(
                                height: 45.0,
                                width: targetWidth,
                                child: new RaisedButton(
                                    elevation: 5,
                                    splashColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    color: Colors.green[700],
                                    child: new Text('เข้าใช้งาน',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () {
                                      _submitForm2(users.loginwithqr);
                                    }),
                              ),
                            )
                          : Text(''),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthPage()));
                          },
                          child: Text(
                            'เข้าระบบด้วยรหัสผ่าน',
                            style: TextStyle(color: Colors.green),
                          )),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('version 2.1')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('update 21-06-2022')],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// 0.9 แผนผลิต

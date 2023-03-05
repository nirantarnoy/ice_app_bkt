import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../models/user.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'username': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

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
      tag: 'bkt ice',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70.0,
          // child: Image.asset('assets/VP.png'),
          child: Text('BKT ICE',
              style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }

  // Widget _buildEmailTextField() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //         labelText: 'E-Mail', filled: true, fillColor: Colors.white),
  //     keyboardType: TextInputType.emailAddress,
  //     validator: (String value) {
  //       if (value.isEmpty ||
  //           !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
  //               .hasMatch(value)) {
  //         return 'Please enter a valid email';
  //       }
  //     },
  //     onSaved: (String value) {
  //       _formData['email'] = value;
  //     },
  //   );
  // }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'ชื่อผู้ใช้', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณากรอกชื่อผู้ใช้';
        }
      },
      onSaved: (String value) {
        _formData['username'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'รหัสผ่าน', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'กรุณากรอกรหัสผ่าน';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  // Widget _buildPasswordConfirmTextField() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //         labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
  //     obscureText: true,
  //     validator: (String value) {
  //       if (_passwordTextController.text != value) {
  //         return 'Passwords do not match.';
  //       }
  //     },
  //   );
  // }

  // Widget _buildAcceptSwitch() {
  //   return SwitchListTile(
  //     value: _formData['acceptTerms'],
  //     onChanged: (bool value) {
  //       setState(() {
  //         _formData['acceptTerms'] = value;
  //       });
  //     },
  //     title: Text('Accept Terms'),
  //   );
  // // }

  void _submitForm(Function login) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    List<User> successInformation;
    successInformation =
        await login(_formData['username'], _formData['password']);

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Sucess!'),
    //       content: Text(''),
    //       actions: <Widget>[
    //         ElevatedButton(
    //           child: Text('ตกลง'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );

    if (successInformation != null) {
      if (successInformation[0].emp_route_id.toString() == '0') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('พบข้อผิดพลาด!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              content: Text('ตรวจสอบว่ามีการจัดรายการรถประจำวันหรือยัง'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK',
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
      } else {
        Navigator.pushReplacementNamed(context, '/');
        print(successInformation);
      }

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Sucess!'),
      //       content: Text(''),
      //       actions: <Widget>[
      //         ElevatedButton(
      //           child: Text('ตกลง'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         )
      //       ],
      //     );
      //   },
      // );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('พบข้อผิดพลาด!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            content: Text('ชื่อหรือรหัสผ่านไม่ถูกต้อง'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK',
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
                      // _showLogo(),
                      Text(
                        'BKT ICE',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildUsernameTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),

                      // ElevatedButton(
                      //   child: Text(
                      //       'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                      //   onPressed: () {
                      //     setState(() {
                      //       _authMode = _authMode == AuthMode.Login
                      //           ? AuthMode.Signup
                      //           : AuthMode.Login;
                      //     });
                      //   },
                      // ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                        child: SizedBox(
                          height: 45.0,
                          width: targetWidth,
                          child: new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                elevation: 5,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                              child: new Text('เข้าสู่ระบบ',
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              onPressed: () => _submitForm(users.login)),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('version 2.6')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('update 25-02-2023')],
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

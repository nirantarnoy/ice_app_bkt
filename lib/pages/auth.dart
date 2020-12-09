import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
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
      image: AssetImage('assets/logo2.jpg'),
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'vorapat ice',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: CircleAvatar(
          // backgroundColor: Colors.transparent,
          radius: 80.0,
          // child: Image.asset('assets/logo.jpg'),
          child: Text('VORAPAT',
              style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Username', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'Username can not be blank';
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
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password can not be blank';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
    );
  }

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

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation =
        await authenticate(_formData['username'], _formData['password']);
    if (successInformation['success']) {
      // Navigator.pushReplacementNamed(context, '/');
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Sucess!'),
      //       content: Text(successInformation['message']),
      //       actions: <Widget>[
      //         FlatButton(
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
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    return Scaffold(
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
                child: Column(
                  children: <Widget>[
                    _showLogo(),
                    _buildUsernameTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _authMode == AuthMode.Signup
                        ? _buildPasswordConfirmTextField()
                        : Container(),
                    // _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    // FlatButton(
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
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? CircularProgressIndicator()
                            : Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                                child: SizedBox(
                                  height: 45.0,
                                  width: targetWidth,
                                  child: new RaisedButton(
                                    elevation: 0.2,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    color: Colors.green,
                                    child: new Text(
                                        _authMode == AuthMode.Login
                                            ? 'Log in'
                                            : '',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () =>
                                        _submitForm(model.authenticate),
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

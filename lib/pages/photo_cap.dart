import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app/helpers/activity_connection.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;
  final _picker = ImagePicker();
  ActivitityConnection activity_con = new ActivitityConnection();

  Future _openGallery(BuildContext context) async {
    final picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        print('Has image na ja');
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async {
    final picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: Text("Gallery"),
                      onTap: () => _openGallery(context)),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () => _openCamera(context),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("No image Screen");
    } else {
      // return Text("OK");
      return Image.file(
        File(imageFile.path),
        width: 400,
        height: 400,
      );
    }
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('No intenet', 'You are no internet connect');
    } else if (result == ConnectivityResult.mobile) {
      _showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      _showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              RaisedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text("Select Image"),
              ),
              RaisedButton(
                onPressed: () {
                  _checkinternet();
                },
                child: Text("Check intenet connection"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

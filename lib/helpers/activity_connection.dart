import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ActivityCon extends StatefulWidget {
  @override
  _ActivityConState createState() => _ActivityConState();
}

class _ActivityConState extends State<ActivityCon> {
  // void _checkinternet(context) async {
  //   var result = await Connectivity().checkConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     _showdialog(context, 'No intenet', 'You are no internet connect');
  //   } else if (result == ConnectivityResult.mobile) {
  //     _showdialog(context, 'Intenet access', 'You are connect mobile data');
  //   }
  //   if (result == ConnectivityResult.wifi) {
  //     _showdialog(context, 'Intenet access', 'You are connect wifi');
  //   }
  // }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('พบข้อผิดพลาด!',
          'กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตของคุณแล้วลองอีกครั้ง');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
  // _showdialog(context, title, text) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(title),
  //           content: Text(text),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('ok'))
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    _checkinternet();
  }
}

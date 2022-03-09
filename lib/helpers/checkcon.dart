import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';

// class CheckCon extends StatelessWidget {
//   Future<void> _checkinternet() async {
//     var result = await Connectivity().checkConnectivity();

//     if (result == ConnectivityResult.none) {
//       _showdialog('พบข้อผิดพลาด!',
//           'กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตของคุณแล้วลองอีกครั้ง');
//     } else if (result == ConnectivityResult.mobile) {
//       //_showdialog('Intenet access', 'You are connect mobile data');
//     }
//     if (result == ConnectivityResult.wifi) {
//       //_showdialog('Intenet access', 'You are connect wifi');
//     }
//   }

//   _showdialog(title, text) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(title),
//             content: Text(text),
//             actions: <Widget>[
//               FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('ok'))
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return _checkinternet();
//   }
// }

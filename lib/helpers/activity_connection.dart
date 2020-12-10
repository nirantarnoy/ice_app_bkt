import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


  
//  void _checkinternet(context) async {
//     var result = await Connectivity().checkConnectivity();
//     if (result == ConnectivityResult.none) {
//       _showdialog(context,'No intenet', 'You are no internet connect');
//     } else if (result == ConnectivityResult.mobile) {
//       _showdialog(context,'Intenet access', 'You are connect mobile data');
//     }
//     if (result == ConnectivityResult.wifi) {
//       _showdialog(context,'Intenet access', 'You are connect wifi');
//     }
//  }
//  _showdialog(context,title, text) {
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
  

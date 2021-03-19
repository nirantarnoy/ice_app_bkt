import 'package:flutter/material.dart';

class ErrorApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.yellow[700],
              size: 100.0,
            ),
            Text('ไม่สามารถเชื่อมต่อ api ได้',
                style: TextStyle(color: Colors.grey[400], fontSize: 16.0)),
          ],
        ),
      ],
    )));
  }
}

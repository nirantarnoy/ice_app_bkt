import 'package:flutter/material.dart';

class ErrorInternet extends StatelessWidget {
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
              Icons.wifi_off_outlined,
              color: Colors.yellow[700],
              size: 100.0,
            ),
            Text('ไม่สามารถเชื่อมต่ออินเตอร์เน็ต',
                style: TextStyle(color: Colors.grey[400], fontSize: 16.0)),
          ],
        ),
      ],
    )));
  }
}

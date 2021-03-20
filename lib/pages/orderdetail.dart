import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  static const routeName = '/orderdetail';
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียด",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.blue[800],
                  child: Text(
                    'เลขที่ขาย',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

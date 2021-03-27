import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        //  color: Theme.of(context).accentColor,
        color: Colors.lightBlue,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              "สรุปรายการขาย",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(children: <Widget>[
                        Text(
                          'ขายสด',
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        //Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text('จำนวน'),
                                  Text(
                                    '405',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  VerticalDivider(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('ยอดขาย'),
                                  Text(
                                    '6,790',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(children: <Widget>[
                        Text(
                          'ขายเชื่อ',
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        //Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text('จำนวน'),
                                  Text(
                                    '354',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('ยอดขาย'),
                                  Text(
                                    '5,510',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(children: <Widget>[
                        Text(
                          'รับชำระ',
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        //Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('ยอดรับชำระ'),
                                  Text(
                                    '1,240',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ข้อมูลวันที่',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ));
  }
}

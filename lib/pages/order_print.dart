import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class OrderPrintPage extends StatefulWidget {
  @override
  _OrderPrintPageState createState() => _OrderPrintPageState();
}

class _OrderPrintPageState extends State<OrderPrintPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  Widget slip() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'น้ำแข็ง',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'เลขที่ AZ210001',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            Expanded(
                child: Text(
              'วันที่ 23/06/2021 16:11',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'ลูกค้า AZ001 อเมซอน',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ))
          ],
        ),
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'รายการ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Text(
              'จำนวน',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
            Expanded(
                child: Text(
              'ราคา',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
            Expanded(
                child: Text(
              'รวม',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ))
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'PB หลอดใหญ่',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
                child: Text(
              '20',
              style: TextStyle(fontSize: 14),
            )),
            Expanded(
                child: Text(
              '5',
              style: TextStyle(fontSize: 14),
            )),
            Expanded(
                child: Text(
              '100',
              style: TextStyle(fontSize: 14),
            ))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Print preview'),
        ),
        body: Column(
          children: <Widget>[
            slip(),
            Container(
              child: Row(
                children: [
                  ElevatedButton(
                    child: Text('Print Slip'),
                    onPressed: () async {
                      final image =
                          await screenshotController.captureFromWidget(slip());
                      if (image == null) {
                        print('no screenshort');
                      } else {
                        print('have screenshort');
                        await saveImage(image);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List image) async {
    //await [];
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(image, name: name);
    return result['filePath'];
  }
}

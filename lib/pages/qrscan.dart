import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ice_app_new/pages/qrscan_create.dart';

class QrscanPage extends StatefulWidget {
  @override
  _QrscanPageState createState() => _QrscanPageState();
}

class _QrscanPageState extends State<QrscanPage> {
  String qrCode = 'Scan result';
  @override
  initState() {
    super.initState();
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${qrCode}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "QRCode",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                child: SizedBox(
                  height: 45.0,
                  width: targetWidth,
                  child: new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        elevation: 0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      child: new Text('สแกน QR code',
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white)),
                      onPressed: () => scanQRCode()),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                child: SizedBox(
                  height: 45.0,
                  width: targetWidth,
                  child: new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      elevation: 0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    child: new Text('สร้าง QR code',
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.white)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrcreatePage(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

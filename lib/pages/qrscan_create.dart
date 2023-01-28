import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrcreatePage extends StatefulWidget {
  @override
  _QrcreatePageState createState() => _QrcreatePageState();
}

class _QrcreatePageState extends State<QrcreatePage> {
  final controller = TextEditingController();
  String qr_text = '';
  @override
  initState() {
    super.initState();
  }

  Widget buildTextField(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        qr_text = value;
        // setState(() {
        //   controller.text = value;
        // });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BarcodeWidget(
                  color: Colors.black,
                  data: controller.text ?? 'Hello',
                  barcode: Barcode.qrCode(),
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: buildTextField(context),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.text = qr_text;
                    });
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

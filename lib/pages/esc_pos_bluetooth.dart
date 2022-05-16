import 'dart:html';

import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

class EscPosBluetooth extends StatefulWidget {
  @override
  State<EscPosBluetooth> createState() => _EscPosBluetoothState();
}

class _EscPosBluetoothState extends State<EscPosBluetooth> {
  final PaperSize paper = PaperSize.mm80;
  CapabilityProfile profile;
  NetworkPrinter printer;

  void _print() async {
    printer = NetworkPrinter(paper, profile);
    final PosPrintResult res =
        await printer.connect('192.168.0.123', port: 9100);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: IconButton(
        icon: Icon(Icons.print),
        onPressed: () => _print(),
      )),
    );
  }
}

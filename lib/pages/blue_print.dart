import 'dart:io';
import 'dart:typed_data';
//import 'package:blue_thermal_printer_example/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class BluePrintPage extends StatefulWidget {
  @override
  _BluePrintState createState() => new _BluePrintState();
}

class _BluePrintState extends State<BluePrintPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  final ScreenshotController screenshotController = ScreenshotController();

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  //TestPrint testPrint;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
    //testPrint = TestPrint();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'text.jpg';
    var bytes = await rootBundle.load("assets/ice_cube.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
      print('file is ${pathImage}');
    });
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  Widget slip() {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ใบเสร็จรับเงิน',
                style: TextStyle(fontSize: 10),
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
                style: TextStyle(fontSize: 8),
              )),
              Expanded(
                  child: Text(
                'วันที่ 23/06/2021 16:11',
                style: TextStyle(fontSize: 8),
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
                style: TextStyle(fontSize: 8),
              ))
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'รายการ',
                  style: TextStyle(fontSize: 8),
                ),
              ),
              Expanded(
                  child: Text(
                'จำนวน',
                style: TextStyle(fontSize: 8),
              )),
              Expanded(
                  child: Text(
                'ราคา',
                style: TextStyle(fontSize: 8),
              )),
              Expanded(
                  child: Text(
                'รวม',
                style: TextStyle(fontSize: 8),
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
                  style: TextStyle(fontSize: 8),
                ),
              ),
              Expanded(
                  child: Text(
                '20',
                style: TextStyle(fontSize: 8),
              )),
              Expanded(
                  child: Text(
                '5',
                style: TextStyle(fontSize: 8),
              )),
              Expanded(
                  child: Text(
                '100',
                style: TextStyle(fontSize: 8),
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Screenshot(
          controller: screenshotController,
          child: Scaffold(
            appBar: AppBar(
              title: Text('ตั้งค่าเครื่องพิมพ์'),
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Printer:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButton(
                            items: _getDeviceItems(),
                            onChanged: (value) {
                              print('printer value is ${value}');
                              setState(() {
                                _device = value;
                              });
                            },
                            value: _device,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700]),
                          onPressed: () {
                            initPlatformState();
                          },
                          child: Text(
                            'Refresh',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _connected ? Colors.red : Colors.green),
                          onPressed: _connected ? _disconnect : _connect,
                          child: Text(
                            _connected ? 'Disconnect' : 'Connect',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700]),
                        onPressed: () {
                          // testPrint.sample(pathImage);
                          _connected ? _testPrint() : print('not connect');
                        },
                        child: Text('PRINT TEST',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Print Screensort'),
                      onPressed: () async {
                        final image = await screenshotController
                            .captureFromWidget(slip());
                        if (image == null) {
                          print('no screenshort');
                        } else {
                          print('have screenshort');
                          await printImage(image);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  void _testPrint() async {
    print('conntected bt');
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printCustom("Ice", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("No: 001", "Date: 08/06/2021", 1);
        bluetooth.printLeftRight("Time: 21:45", "", 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("Items", "Qty", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("PB", "1", 1);
        bluetooth.printLeftRight("PC", "4", 1);
        bluetooth.printLeftRight("M", "3", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("TOTAL", "8", 3);
        // bluetooth.printImage(pathImage);
        // bluetooth.printCustom("Body left", 1, 0);
        // bluetooth.printCustom("Body right", 1, 2);
        // bluetooth.printNewLine();
        // //  bluetooth.printCustom("ผู้ขาย", 2, 1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
    // bluetooth.isConnected.then((isConnected) {
    //   if (isConnected) {
    //     bluetooth.printCustom("HEADER", 3, 1);
    //     bluetooth.printNewLine();
    //     //    bluetooth.printImage(pathImage);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 0);
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 2);
    //     bluetooth.printCustom("Body left", 1, 0);
    //     bluetooth.printCustom("Body right", 0, 2);
    //     bluetooth.printNewLine();
    //     bluetooth.printCustom("Terimakasih", 2, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printNewLine();
    //     bluetooth.paperCut();
    //   }
    // });
  }

  Future<String> saveImage(Uint8List bytes) async {
    //await [];
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result;
  }

  Future printImage(Uint8List image) async {
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // final time = DateTime.now()
    //     .toIso8601String()
    //     .replaceAll('.', '-')
    //     .replaceAll(':', '-');
    // final name = 'screenshot_$time';
    // String fullPath = '$dir/$name';
    // File file = File(fullPath);
    // await file.writeAsBytes(image);
    // setState(() {
    //   pathImage = fullPath;
    //   print('file is ${pathImage}');
    // });
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImageBytes(image);
        // bluetooth.printImage(pathImage);
        //bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}

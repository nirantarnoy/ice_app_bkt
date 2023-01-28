import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/models/plan_detail.dart';
import 'package:ice_app_new/pages/plan.dart';
import 'package:ice_app_new/providers/plan.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';

class PlanDetailPage extends StatefulWidget {
  static const routeName = '/plandetail';

  @override
  _PlanDetailPageState createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  final DateFormat dateformatter2 = DateFormat('H:mm');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonTextController = TextEditingController();
  final ScreenshotController screenshotController =
      ScreenshotController(); // screenshot capture
  File screenshot;
  final Map<String, dynamic> _formData = {
    'cancel_reason': '',
  };
  var _isInit = true;
  var _isLoading = false;

  Future _orderFuture;

  Future _obtainPlanFuture() {
    return Provider.of<PlanData>(context, listen: false).getCustomerDetails();
  }

  @override
  initState() {
    _orderFuture = _obtainPlanFuture();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _buildScreenshot() async {
    // screenshot capture
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      ShowCapturedWidget(context, capturedImage);
    }).catchError((onError) {
      print(onError);
    });
    // final Uint8List bytes = await widget.screenshot.
  }

  Future<dynamic> ShowCapturedWidget(
      // screenshot capture
      BuildContext context,
      Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("พิมพ์สลิป"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  //_saved(File image) async {
  // screenshot capture
  // final result = await ImageGallerySaver.save(image.readAsBytesSync());
  //  print("File Saved to Gallery");
  //}

  Widget _buildreason() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          labelText: 'ระบุเหตุผล', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณากรอกเหตุ';
        }
      },
      onSaved: (String value) {
        _formData['cancel_reason'] = value;
      },
    );
  }

  void _submitForm(String customer_code, String plan_no, String product_code,
      String line_id) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    Provider.of<PlanData>(context, listen: false)
        .cancelPlan(line_id, customer_code, plan_no, product_code,
            _formData['cancel_reason'])
        .then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "ทำรายการสำเร็จ",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).pop();
      },
    );
    setState(() {
      // Provider.of<PaymentreceiveData>(context, listen: false)
      //     .fetPaymentreceive(widget._customer_id);
    });
  }

  Widget _buildplansList(List<PlanDetail> plans, String customer_name,
      String plan_date, String plan_no) {
    final plandata = Provider.of<PlanData>(context, listen: false);
    var formatter2 = NumberFormat('#,##,##0.#');
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    Widget orderCards;
    if (plans.length > 0) {
      // print("has list");
      orderCards = new ListView.builder(
        itemCount: plans.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(plans[index]),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('แจ้งเตือน'),
                  content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ยืนยัน'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('ไม่'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              print('delete is ${plans[index].id}');
              setState(() {
                Provider.of<PlanData>(context, listen: false)
                    .removePlanDetail(plans[index].id);
                plans.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "ทำรายการสำเร็จ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ));
            },
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController _textEditingController =
                          TextEditingController();
                      bool isChecked = false;

                      return SingleChildScrollView(
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 10,
                            height: MediaQuery.of(context).size.height - 300,
                            // height: MediaQuery.of(context).size.height - 100,
                            // width: double.infinity,
                            // height: double.infinity,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Center(
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      size: 50,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                      child: Text(
                                    "ยกเลิกการขาย",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text('ลูกค้า ${customer_name}'),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text('เลขที่ ${plan_no}'),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text('วันที่ ${plan_date}'),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: _buildreason(),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 15.0, 10.0, 0.0),
                                    child: SizedBox(
                                      height: 55.0,
                                      width: targetWidth,
                                      child: new ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[700],
                                            elevation: 0.2,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: new Text('บันทึก',
                                              style: new TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            _submitForm(
                                              customer_name,
                                              plan_no,
                                              plans[index].product_name,
                                              plans[index].id.toString(),
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PlanPage(),
                                              ),
                                            );
                                            //Navigator.pop(context);
                                          }),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 15.0, 10.0, 0.0),
                                    child: SizedBox(
                                      height: 55.0,
                                      width: targetWidth,
                                      child: new ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[400],
                                            elevation: 0.2,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: new Text('ยกเลิก',
                                              style: new TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    // leading: Chip(
                    //   label: Text("${plans[index].product_name}",
                    //       style: TextStyle(color: Colors.white)),
                    //   backgroundColor: Colors.orange[700],
                    // ),
                    title: Text(
                      "${plans[index].product_name}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    // subtitle: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         Text(
                    //           "วันที่ ${plans[index].trans_date}",
                    //           style: TextStyle(
                    //               fontSize: 12, color: Colors.cyan[700]),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    trailing: plans[index].status != '500'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "x${plans[index].qty}",
                                style: TextStyle(
                                    color: Colors.green[500],
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                'ยกเลิก',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
      return orderCards;
    } else {
      return Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      );
    }
  }

  // void _testPrint(List<OrderDetail> plans, String emp_name) async {
  //   print('conntected bt');
  //   //SIZE
  //   // 0- normal size text
  //   // 1- only bold text
  //   // 2- bold with medium text
  //   // 3- bold with large text
  //   //ALIGN
  //   // 0- ESC_ALIGN_LEFT
  //   // 1- ESC_ALIGN_CENTER
  //   // 2- ESC_ALIGN_RIGHT
  //   int total_amount = 0;
  //   DateTime _plan_date = new DateTime.now();

  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected) {
  //       bluetooth.printCustom("Vorapat", 3, 1);
  //       bluetooth.printNewLine();
  //       bluetooth.printLeftRight("No: ${plans[0].plan_no}", "", 1);
  //       bluetooth.printLeftRight("Date: ${dateformatter.format(_plan_date)}",
  //           "Time: ${dateformatter2.format(_plan_date)}", 1);
  //       bluetooth.printLeftRight("Customer: ${plans[0].customer_code}", "", 1);
  //       bluetooth.printCustom("-----------------------------------", 1, 1);
  //       bluetooth.printLeftRight("Items", "Price", 1);
  //       bluetooth.printCustom("-----------------------------------", 1, 1);
  //       if (plans.length > 0 || plans.isNotEmpty) {
  //         plans.forEach((element) {
  //           total_amount = total_amount +
  //               (int.parse(element.price) * int.parse(element.qty));
  //           bluetooth.printLeftRight(
  //               "${element.product_code} qty: ${element.qty}x${element.price}",
  //               "${(int.parse(element.price) * int.parse(element.qty))}",
  //               1);
  //         });
  //       }
  //       bluetooth.printCustom("-----------------------------------", 1, 1);
  //       bluetooth.printLeftRight("TOTAL", "${total_amount}", 3);
  //       bluetooth.printNewLine();
  //       bluetooth.printLeftRight("Driver: ${emp_name}", "", 1);
  //       bluetooth.printNewLine();
  //       bluetooth.printCustom("Receiver: ______________________", 1, 1);

  //       // bluetooth.printImage(pathImage);
  //       // bluetooth.printCustom("Body left", 1, 0);
  //       // bluetooth.printCustom("Body right", 1, 2);
  //       // bluetooth.printNewLine();
  //       // //  bluetooth.printCustom("ผู้ขาย", 2, 1);
  //       // bluetooth.printNewLine();
  //       // bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       bluetooth.paperCut();
  //     }
  //   });
  //   // bluetooth.isConnected.then((isConnected) {
  //   //   if (isConnected) {
  //   //     bluetooth.printCustom("HEADER", 3, 1);
  //   //     bluetooth.printNewLine();
  //   //     //    bluetooth.printImage(pathImage);
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.printLeftRight("LEFT", "RIGHT", 0);
  //   //     bluetooth.printLeftRight("LEFT", "RIGHT", 1);
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.printLeftRight("LEFT", "RIGHT", 2);
  //   //     bluetooth.printCustom("Body left", 1, 0);
  //   //     bluetooth.printCustom("Body right", 0, 2);
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.printCustom("Terimakasih", 2, 1);
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.printNewLine();
  //   //     bluetooth.paperCut();
  //   //   }
  //   // });
  // }

  //   Future _printThermalBluetooth() async {
  //   print('_printThermalBluetooth');
  //   this
  //       ._screenshotCustomer
  //       .capture(delay: Duration(milliseconds: 10), pixelRatio: 3)
  //       .then((Uint8List captureImage) async {
  //     print('_printThermalBluetooth ====> $captureImage');
  //     bluetooth.isConnected.then((isConnected) async {
  //       if (isConnected) {
  //         var image = decodeImage(captureImage);
  //         image = copyResize(image, width: 380);
  //         Uint8List imageByte = encodePng(image);
  //         print('_printThermalBluetooth ====> $imageByte');
  //         print('_printThermalBluetooth asUint8List ====> ${imageByte.offsetInBytes}   ${imageByte.lengthInBytes}');
  //         bluetooth.printImageBytes(imageByte.buffer
  //             .asUint8List(imageByte.offsetInBytes, imageByte.lengthInBytes));
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.paperCut();
  //         _disconnect();
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0.#');
    // final customer_order_id =
    //     ModalRoute.of(context).settings.arguments as String; // is id
    final plan_data = ModalRoute.of(context).settings.arguments as Map; // is id
    //  print(plan_data);
    final loadCustomerplan = Provider.of<PlanData>(context, listen: false)
        .findById(plan_data['plan_id']);

    final loadordertotal = Provider.of<PlanData>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "รายละเอียด",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (context, dataSnapshort) {
            if (dataSnapshort.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshort.error != null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: Container(
                        //         height: 40,
                        //         color: Colors.green[700],
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: <Widget>[
                        //             Column(
                        //               children: <Widget>[
                        //                 Row(
                        //                   children: <Widget>[
                        //                     Column(
                        //                       children: <Widget>[
                        //                         SizedBox(
                        //                           height: 10,
                        //                         ),
                        //                         Text(
                        //                             loadCustomerplan
                        //                                 .customer_name,
                        //                             style: TextStyle(
                        //                                 fontSize: 16,
                        //                                 color: Colors.white))
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "รายการสั่งสินค้า",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Consumer<PlanData>(
                            builder: (context, plandetails, _) =>
                                _buildplansList(
                                    plandetails.listplan_detail,
                                    loadCustomerplan.customer_name,
                                    loadCustomerplan.trans_date,
                                    loadCustomerplan.code),
                          ),
                        ),
                        Container(
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Consumer<PlanData>(
                                      builder: (context, plandetails, _) =>
                                          Text(
                                        'รวมทั้งหมด ${formatter.format(plandetails.sumqtydetail)}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

// class Items extends StatelessWidget {
//   //plans _plans;
//   final String _order_id;
//   final String _plan_no;
//   final String _plan_date;
//   final String _customer_name;
//   final String _line_id;
//   final String _product_id;
//   final String _product_code;
//   final String _product_name;
//   final String _price_group_id;
//   final String _qty;
//   final String _price;
//   Items(
//       this._order_id,
//       this._plan_no,
//       this._plan_date,
//       this._customer_name,
//       this._line_id,
//       this._product_id,
//       this._product_code,
//       this._product_name,
//       this._price_group_id,
//       this._qty,
//       this._price);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PlanData>(
//       builder: (BuildContext context, plans, Widget child) => Dismissible(
//         key: ValueKey(_line_id),
//         background: Container(
//           color: Theme.of(context).errorColor,
//           child: Icon(
//             Icons.delete,
//             color: Colors.white,
//             size: 40,
//           ),
//           alignment: Alignment.centerRight,
//           padding: EdgeInsets.only(right: 20),
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//         ),
//         direction: DismissDirection.endToStart,
//         onDismissed: (direction) {
//           setState() {
//             plans.removePlanDetail(_line_id);
//           }
//         },
//         child: GestureDetector(
//           onTap: () =>
//               Navigator.of(context).pushNamed(PlanDetailPage.routeName),
//           child: Column(
//             children: <Widget>[
//               ListTile(
//                 // leading: ElevatedButton(
//                 //     color:
//                 //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
//                 //     onPressed: () {},
//                 //     child: Text(
//                 //       "$_payment_method",
//                 //       style: TextStyle(color: Colors.white),
//                 //     )),
//                 leading: Chip(
//                   label: Text("${_product_code}",
//                       style: TextStyle(color: Colors.white)),
//                   backgroundColor: Colors.purple[700],
//                 ),
//                 title: Text(
//                   "$_product_name",
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 subtitle: Text(
//                   "วันที่ ${_plan_date}",
//                   style: TextStyle(fontSize: 12, color: Colors.cyan[700]),
//                 ),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("$_qty x $_price = $_qty * $_price}",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.red)),
//                   ],
//                 ),
//               ),
//               Divider(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//}

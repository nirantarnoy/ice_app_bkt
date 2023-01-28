import 'package:flutter/material.dart';
import 'package:ice_app_new/models/routeolestock.dart';

import 'package:ice_app_new/pages/carload_review.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
//import 'package:ice_app_new/pages/journalissue.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

import '../../models/issueitems.dart';

class Journalissueitem extends StatefulWidget {
  @override
  _JournalissueitemState createState() => _JournalissueitemState();
}

class _JournalissueitemState extends State<Journalissueitem> {
  initState() {
    Provider.of<IssueData>(context, listen: false).fetoldstockroute();
    super.initState();
  }

  Widget _buildissueitemList(List<Issueitems> issue_items) {
    Widget productCards;
    if (issue_items.isNotEmpty) {
      if (issue_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: issue_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              issue_items[index].line_issue_id.toString(),
              issue_items[index].issue_id,
              issue_items[index].product_id,
              issue_items[index].product_name.toString(),
              issue_items[index].qty,
              issue_items[index].price,
              issue_items[index].product_image,
              issue_items[index].avl_qty,
            );
          },
        );
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return productCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildoldstocklist(List<RouteOldStock> oldstock_items) {
    Widget productCards2;
    if (oldstock_items.isNotEmpty) {
      if (oldstock_items.length > 0) {
        // print("has list");
        productCards2 = new ListView.builder(
          itemCount: oldstock_items.length,
          itemBuilder: (BuildContext context, int index) {
            //  print(oldstock_items[index].product_code.toString());
            return Items2(
              oldstock_items[index].product_code.toString(),
              oldstock_items[index].product_id.toString(),
              oldstock_items[index].product_name.toString(),
              oldstock_items[index].qty,
            );
          },
        );
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return productCards2;
    } else {
      return Center(
        child: Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final IssueData item_issues =
    //     Provider.of<IssueData>(context, listen: false);
    //Provider.of<IssueData>(context, listen: false).fetoldstockroute();
    var formatter = NumberFormat('#,##,##0.#');
    return Consumer<IssueData>(
      builder: (context, issues, _) => issues.listissue.isNotEmpty
          ? issues.userconfirm == 1
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        issues.hasissue_open
                            ? Expanded(
                                // ignore: deprecated_member_use
                                child: new ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      elevation: 0.5,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(0)),
                                    ),
                                    child: Column(
                                      children: [
                                        new Text(
                                          'มีใบเบิกใหม่ กดรับสินค้าขึ้นรถ',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CarloadReviewPage(),
                                        ),
                                      ).then((value) => setState(() {}));
                                      // return showDialog(
                                      //   context: context,
                                      //   builder: (context) => AlertDialog(
                                      //     title: Text('ยืนยัน'),
                                      //     content: Text(
                                      //         'คุณต้องการยืนยันการรับของขึ้นรถใช่หรือไม่'),
                                      //     actions: <Widget>[
                                      //       ElevatedButton(
                                      //         onPressed: () {
                                      //           Provider.of<IssueData>(context,
                                      //                   listen: false)
                                      //               .issueconfirm();
                                      //           // Navigator.of(context).pop(true);
                                      //           Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   JournalissuePage(),
                                      //             ),
                                      //           );
                                      //         },
                                      //         child: Text('ยืนยัน'),
                                      //       ),
                                      //       ElevatedButton(
                                      //         onPressed: () {
                                      //           Navigator.of(context)
                                      //               .pop(false);
                                      //         },
                                      //         child: Text('ไม่'),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // );
                                    }),
                              )
                            : Text(''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("รายการสินค้าประจำวัน",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                            ),
                            // Chip(
                            //   label: Text("อ้างอิง ${item_issues.listissue[0].issue_no}",
                            //       style: TextStyle(color: Colors.white)),
                            //   backgroundColor: Colors.purple,
                            // )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Consumer<IssueData>(
                        builder: (context, issues, _) =>
                            issues.listissue.isNotEmpty
                                ? _buildissueitemList(issues.listissue)
                                : Center(
                                    child: Text(
                                      "ไม่พบข้อมูล",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "สินค้าคงเหลือ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  Chip(
                                    label: Consumer<IssueData>(
                                        builder: (context, issues, _) => Text(
                                              issues.totalAmount == null
                                                  ? 0
                                                  : "${formatter.format(issues.totalAmount)}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 50.0,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'มีรายการเบิกสินค้ารอรับขึ้นรถ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // ignore: deprecated_member_use
                      new ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(
                              right: 8,
                            ),
                            elevation: 0.2,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              // Icon(
                              //   Icons.local_shipping_outlined,
                              //   color: Colors.white,
                              // ),
                              new Text(
                                'กดรับสินค้าขึ้นรถ',
                                style: new TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarloadReviewPage(),
                              ),
                            ).then((value) => setState(() {}));
                          }),
                    ],
                  ),
                )
          : Container(
              // child: Text(
              //   "ไม่พบข้อมูลx",
              //   style: TextStyle(fontSize: 20, color: Colors.grey),
              // ),
              child: issues.hasissue_open
                  ? Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 50.0,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'มีรายการเบิกสินค้ารอรับขึ้นรถ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  textStyle: TextStyle(color: Colors.white),
                                  padding: EdgeInsets.only(
                                    right: 8,
                                  ),
                                  elevation: 0.2,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Icon(
                                    //   Icons.local_shipping_outlined,
                                    //   color: Colors.white,
                                    // ),
                                    new Text(
                                      'กดรับสินค้าขึ้นรถ',
                                      style: new TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarloadReviewPage(),
                                    ),
                                  ); //.then((value) => setState(() {}));
                                  // return showDialog(
                                  //   context: context,
                                  //   builder: (context) => AlertDialog(
                                  //     title: Text('ยืนยัน'),
                                  //     content: Text(
                                  //         'คุณต้องการยืนยันการรับของขึ้นรถใช่หรือไม่'),
                                  //     actions: <Widget>[
                                  //       ElevatedButton(
                                  //         onPressed: () {
                                  //           // Provider.of<IssueData>(context,
                                  //           //         listen: false)
                                  //           //     .issueconfirm();
                                  //           // // Navigator.of(context).pop(true);

                                  //           // Navigator.push(
                                  //           //   context,
                                  //           //   MaterialPageRoute(
                                  //           //     builder: (context) =>
                                  //           //         JournalissuePage(),
                                  //           //   ),
                                  //           // );

                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   CarloadReviewPage(),
                                  //             ),
                                  //           );
                                  //         },
                                  //         child: Text('ยืนยัน'),
                                  //       ),
                                  //       ElevatedButton(
                                  //         onPressed: () {
                                  //           Navigator.of(context).pop(false);
                                  //         },
                                  //         child: Text('ไม่'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                }),
                          ],
                        ),
                        Consumer<IssueData>(
                          builder: (context, oldstock, _) =>
                              oldstock.listoldstock.length > 0
                                  ? Expanded(
                                      child: Row(
                                      children: [
                                        Expanded(
                                            child: _buildoldstocklist(
                                                oldstock.listoldstock)),
                                      ],
                                    ))
                                  : Text('no'),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "ไม่พบข้อมูล",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
            ),
    );
  }
}

class Items extends StatelessWidget {
  var formatter = NumberFormat('#,##,##0.#');
  //orders _orders;
  final String _line_issue_id;
  final String _issue_id;
  final String _product_id;
  final String _product_name;
  final String _qty;
  final String _price;
  final String _product_image;
  final String _avl_qty;

  Items(
    this._line_issue_id,
    this._issue_id,
    this._product_id,
    this._product_name,
    this._qty,
    this._price,
    this._product_image,
    this._avl_qty,
  );
  @override
  Widget build(BuildContext context) {
    // double check_old_qty =
    //     Provider.of<IssueData>(context, listen: false).getOldqty(_product_id);
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(''),
            ),
            title: Text(
              "$_product_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // subtitle: Text("ราคาขาย $_price บาท"),
            trailing: Text("${formatter.format(double.parse(_avl_qty))}",
                //  trailing: Text("0",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class Items2 extends StatelessWidget {
  var formatter = NumberFormat('#,##,##0.#');
  //orders _orders;
  final String _product_code;
  final String _product_id;
  final String _product_name;
  final String _qty;

  Items2(
    this._product_code,
    this._product_id,
    this._product_name,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    // double check_old_qty =
    //     Provider.of<IssueData>(context, listen: false).getOldqty(_product_id);
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(''),
            ),
            title: Text(
              "$_product_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // subtitle: Text("ราคาขาย $_price บาท"),
            trailing: Text("${formatter.format(double.parse(_qty))}",
                //  trailing: Text("0",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
          Divider(),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:ice_app_new/models/products.dart';
// import 'package:ice_app_new/models/reviewload.dart';
import 'package:ice_app_new/models/transferin.dart';
import 'package:ice_app_new/pages/issuesuccess.dart';
// import 'package:ice_app_new/pages/journalissue.dart';
// import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:provider/provider.dart';

class TransferInReviewPage extends StatefulWidget {
  static const routeName = '/transferinreview';
  @override
  _TransferInReviewPageState createState() => _TransferInReviewPageState();
}

class _TransferInReviewPageState extends State<TransferInReviewPage> {
  Widget _buildlist(List<Transferin> transferin_items) {
    Widget productCards;
    if (transferin_items.isNotEmpty) {
      if (transferin_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: transferin_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              transferin_items[index].product_name,
              transferin_items[index].product_name.toString(),
              transferin_items[index].qty.toString(),
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

  @override
  Widget build(BuildContext context) {
    final transfer_data = ModalRoute.of(context).settings.arguments as Map;
    String _id = transfer_data['transfer_id'];
    Provider.of<TransferinData>(context, listen: false).fetTransferinnew(_id);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'รายการโอนสินค้า',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ตรวจสอบสินค้าและจำนวน',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
            Expanded(
              child: Consumer<TransferinData>(
                builder: (context, transferin, _) => transferin
                        .listtransferin.isNotEmpty
                    ? _buildlist(transferin.listtransferin)
                    : Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
              ),
            ),
            Consumer<TransferinData>(
              builder: (context, transferin, _) =>
                  transferin.listtransferin[0].transfer_status == "1"
                      ? Row(
                          children: <Widget>[
                            // Expanded(
                            //   child: GestureDetector(
                            //     child: Container(
                            //       color: 1 > 0 ? Colors.red[700] : Colors.red[200],
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(16),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: <Widget>[
                            //             SizedBox(width: 5),
                            //             Text(
                            //               'ไม่รับ',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontWeight: FontWeight.normal,
                            //                   fontSize: 20),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     onTap: () {
                            //       return showDialog(
                            //         context: context,
                            //         builder: (context) => AlertDialog(
                            //           title: Text('ยืนยัน'),
                            //           content:
                            //               Text('คุณต้องการยืนยันการใช่หรือไม่'),
                            //           actions: <Widget>[
                            //             ElevatedButton(
                            //               onPressed: () {
                            //                 Provider.of<TransferinData>(context,
                            //                         listen: false)
                            //                     .accepttransfer(_id);
                            //                 // Navigator.of(context).pop(true);

                            //                 Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         IssuesuccessPage(),
                            //                   ),
                            //                 );
                            //                 // Navigator.of(context).pop(true);
                            //               },
                            //               child: Text('ยืนยัน'),
                            //             ),
                            //             ElevatedButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop(false);
                            //               },
                            //               child: Text('ไม่'),
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  color: 1 > 0
                                      ? Colors.green[700]
                                      : Colors.green[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 5),
                                        Text(
                                          'รับสินค้า',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('ยืนยัน'),
                                      content:
                                          Text('คุณต้องการยืนยันการใช่หรือไม่'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Provider.of<TransferinData>(context,
                                                    listen: false)
                                                .accepttransfer(_id);
                                            // Navigator.of(context).pop(true);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IssuesuccessPage(),
                                              ),
                                            );

                                            // Navigator.of(context).pop(true);
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
                              ),
                            ),
                          ],
                        )
                      : Text(''),
            )
          ],
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _code;
  final String _name;
  final String _qty;

  Items(
    this._code,
    this._name,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            // leading: Text(
            //   "$_code",
            //   style: TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
            title: Text(
              "$_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            //  subtitle: Text("$_name"),
            trailing: Text("${_qty}",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800])),
          ),
          Divider(),
        ],
      ),
    );
  }
}

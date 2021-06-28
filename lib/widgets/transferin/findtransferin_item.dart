import 'package:flutter/material.dart';
import 'package:ice_app_new/models/findtransfer.dart';
import 'package:ice_app_new/pages/transferin_review.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FindtransferinItem extends StatefulWidget {
  @override
  _FindtransferinItemState createState() => _FindtransferinItemState();
}

class _FindtransferinItemState extends State<FindtransferinItem> {
  Widget _buildissueitemList(List<FindTransfer> findtransfer_item) {
    Widget productCards;
    if (findtransfer_item.isNotEmpty) {
      if (findtransfer_item.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: findtransfer_item.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              findtransfer_item[index].id.toString(),
              findtransfer_item[index].journal_no,
              findtransfer_item[index].trans_date,
              findtransfer_item[index].from_route_id.toString(),
              findtransfer_item[index].from_route_name,
              findtransfer_item[index].transfer_status,
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
    // final IssueData item_issues =
    //     Provider.of<IssueData>(context, listen: false);
    var formatter = NumberFormat('#,##,##0.#');
    return Consumer<TransferinData>(
      builder: (context, _findtransfer, _) =>
          _findtransfer.findtransfer.isNotEmpty
              ? Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("รายการสินค้าโอน",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
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
                      child: _buildissueitemList(_findtransfer.findtransfer),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _id;
  final String _journal_no;
  final String _trans_date;
  final String _from_route_id;
  final String _from_route_name;
  final String _transfer_status;

  Items(
    this._id,
    this._journal_no,
    this._trans_date,
    this._from_route_id,
    this._from_route_name,
    this._transfer_status,
  );
  @override
  Widget build(BuildContext context) {
    final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
    final DateFormat dateformatter2 = DateFormat('H:mm');
    return new GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TransferInReviewPage.routeName, arguments: {
          'transfer_id': _id,
        });
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "${_journal_no} สายส่ง ${_from_route_name}",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            subtitle: Text("${_trans_date}"),
            trailing: _transfer_status == "1"
                ? Text(
                    "Open",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

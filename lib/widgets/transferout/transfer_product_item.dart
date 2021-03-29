import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

class TransferProductItem extends StatelessWidget {
  Widget _buildlistitem(List<TransferProduct> issueproduct) {
    if (issueproduct.isNotEmpty) {
      Widget productcards;
      if (issueproduct.length > 0) {
        //print('product length is ${issueproduct[0].product_name}');
        productcards = new ListView.builder(
          itemCount: issueproduct.length,
          itemBuilder: (BuildContext context, int index) {
            // print('index is ${issueproduct[index]}');
            return Items(
              issueproduct[index].id,
              issueproduct[index].code,
              issueproduct[index].name,
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
      return productcards;
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
    return Column(
      children: <Widget>[
        Expanded(
          child: Consumer<IssueData>(
            builder: (context, products, _) =>
                products.transferproductitems.isNotEmpty
                    ? _buildlistitem(products.transferproductitems)
                    : Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
          ),
        )
        // FutureBuilder(
        //   builder: (context, dataSnapshort) {
        //     if (dataSnapshort.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else {
        //       return Expanded(
        //         child: Consumer<IssueData>(
        //           builder: (context, products, _) => products
        //                   .listissue.isNotEmpty
        //               ? _buildlistitem(products.listissue)
        //               : Center(
        //                   child: Text(
        //                     "ไม่พบข้อมูล",
        //                     style: TextStyle(fontSize: 20, color: Colors.grey),
        //                   ),
        //                 ),
        //         ),
        //       );
        //     }
        //   },
        // ),
      ],
    );
  }
}

class Items extends StatelessWidget {
  final String _id;
  final String _code;
  final String _name;

  Items(
    this._id,
    this._code,
    this._name,
  );

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('${_code}')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: Column(
                  children: [
                    IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(),
                    ),
                    IconButton(icon: Icon(Icons.add), onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // child: Column(
      //   children: <Widget>[
      //     ListTile(
      //       title: Text('${_code}'),
      //     ),
      //     Divider(),
      //   ],
      // ),
    );
  }
}

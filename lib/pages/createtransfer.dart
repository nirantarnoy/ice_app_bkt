import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/widgets/transferout/transfer_product_item.dart';
import 'package:provider/provider.dart';

class CreatetransferPage extends StatefulWidget {
  @override
  _CreatetransferPageState createState() => _CreatetransferPageState();
}

class _CreatetransferPageState extends State<CreatetransferPage> {
  Future _productFuture;
  Future _obtainproductFuture() {
    return Provider.of<IssueData>(context, listen: false).fetTransferitems();
  }

  @override
  void initState() {
    _productFuture = _obtainproductFuture();
    // TODO: implement initState
    super.initState();
  }

  Widget _buildlist() {
    IssueData products = Provider.of<IssueData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _productFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: Text('${dataSnapshort.error}'));
          } else {
            return Container(child: TransferProductItem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: products.fetIssueitems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          title: Text(
            "โอนสินค้า",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'สินค้าที่โอนได้',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Expanded(child: _buildlist()),
          ],
        ),
      ),
    );
  }
}

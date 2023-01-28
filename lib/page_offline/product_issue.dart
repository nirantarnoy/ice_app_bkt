import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/sqlite/models/customer_price.dart';
import 'package:ice_app_new/sqlite/models/product.dart';
import 'package:ice_app_new/sqlite/providers/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _callDb();
    //Provider.of<CustomerpriceData>(context, listen: false).fetpriceonline();
    super.initState();
  }

  Future _callDb() async {
    int chk_db = await DbHelper.instance.checkDB();
    print(chk_db);
  }

  Future callapidata() async {
    // await Provider.of<CustomerpriceData>(context, listen: false)
    //     .fetpriceonline();
    List<Issueitems> issue_daily =
        await Provider.of<IssueData>(context, listen: false).listissue;
    print('issue daily is ${issue_daily.length}');
    if (issue_daily != null) {
      issue_daily.forEach((element) async {
        final Product product_data = Product(
          id: element.product_id,
          code: element.product_name,
          name: element.product_name,
          qty: element.avl_qty,
          issue_id: int.parse(element.issue_id),
          createdTime: DateTime.now(),
          price_group_id: 0,
          route_id: 0,
        );

        if (product_data != null) {
          await DbHelper.instance.createProduct(product_data);
        }
      });
    }
  }

  Future refreshData() async {
    setState(() => isLoading = true);
    this.products = await DbHelper.instance.readAllProduct();
    setState(() => isLoading = false);
  }

  Future deleteData() async {
    setState(() => isLoading = true);
    await DbHelper.instance.deleteProductAll();
    refreshData();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Mode')),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    callapidata();
                  },
                  child: Text('api data'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => refreshData(),
                  child: Text('pull data'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => deleteData(),
                  child: Text('delete data'),
                ),
              ],
            ),
            Expanded(child: products != null ? buildList() : Text('No data')),
          ],
        ),
      ),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            //.then(getRefresh()),
            child: Column(
              children: [
                ListTile(
                  //leading: Text('${notes[index].createdTime}'),
                  title: Text(
                    '${products[index].code}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${products[index].name}'),
                    ],
                  ),
                  trailing: Text('${products[index].qty}'),
                ),
                Divider(),
              ],
            ),
          );
        },
      );
}

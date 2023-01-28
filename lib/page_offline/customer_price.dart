import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/page_offline/createorder_new_offline.dart';
import 'package:ice_app_new/page_offline/orderoffline.dart';
import 'package:ice_app_new/page_offline/product_issue.dart';
import 'package:ice_app_new/sqlite/models/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:provider/provider.dart';

class CustomerpricePage extends StatefulWidget {
  @override
  _CustomerpriceState createState() => _CustomerpriceState();
}

class _CustomerpriceState extends State<CustomerpricePage> {
  List<CustomerPrice> custprice;
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
    await Provider.of<CustomerpriceData>(context, listen: false)
        .fetpriceonline();
  }

  Future refreshData() async {
    setState(() => isLoading = true);
    this.custprice = await DbHelper.instance.readAllCustomerPrice();
    setState(() => isLoading = false);
  }

  Future deleteData() async {
    setState(() => isLoading = true);
    await DbHelper.instance.deleteCustpriceAll();
    refreshData();
    setState(() => isLoading = false);
  }

  Future deleteOrder() async {
    setState(() => isLoading = true);
    await DbHelper.instance.deleteOrderAll();
    refreshData();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Mode2')),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('get api');
                    callapidata();
                  },
                  child: Text('api data 2'),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductsPage())),
                  child: Text('get product issue'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderofflinePage())),
                  child: Text('new order'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => deleteOrder(),
                  child: Text('delete all order'),
                ),
              ],
            ),
            Expanded(child: custprice != null ? buildList() : Text('No data')),
          ],
        ),
      ),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: custprice.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            //.then(getRefresh()),
            child: Column(
              children: [
                ListTile(
                  //leading: Text('${notes[index].createdTime}'),
                  title: Text(
                    '${custprice[index].code}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${custprice[index].name}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${custprice[index].product_name}'),
                      Text('${custprice[index].sale_price}'),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          );
        },
      );
}

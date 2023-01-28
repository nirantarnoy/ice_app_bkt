import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ice_app_new/models/car.dart';
import 'package:ice_app_new/models/customer_asset.dart';
import 'package:ice_app_new/pages/assetcheck.dart';
// import 'package:ice_app_new/pages/ordercheckout.dart';
// import 'package:ice_app_new/providers/paymentreceive.dart';
// import 'package:ice_app_new/providers/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:ice_app_new/providers/issuedata.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/providers/customer.dart';

import 'package:ice_app_new/models/addorder.dart';
// import 'package:ice_app_new/models/products.dart';

class CustomerAssetPage extends StatefulWidget {
  static const routeName = '/customerassetpage';

  const CustomerAssetPage({Key key, this.customer_selected}) : super(key: key);
  final String customer_selected;
  @override
  _CustomerAssetPageState createState() => _CustomerAssetPageState();
}

class _CustomerAssetPageState extends State<CustomerAssetPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  String selectedValueName;
  int isuserconfirm = 0;
  List<Addorder> orderItems = [];

  var _isInit = true;
  var _isLoading = false;
  @override
  initState() {
    _checkinternet();
    selectedValue = widget.customer_selected;
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CustomerData>(context, listen: false)
          .fetCustomers()
          .then((_) {
        setState(() {
          _isLoading = false;

          // print('issue id is ${selectedIssue}');
        });
      });

      // setState(() {
      //   _isLoading = true;

      // });

      // Provider.of<ProductData>(context, listen: false)
      //     .fetProducts("")
      //     .then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('No intenet', 'You are no internet connect');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  Widget _buildproductList(List<CustomerAsset> assets) {
    Widget productCards;

    if (assets != null) {
      if (assets.length > 0) {
        // print("has product item list");
        productCards = new ListView.builder(
            itemCount: assets.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AssetcheckPage.routeName, arguments: {
                    'customer_id': selectedValue,
                    'product_id': assets[index].product_id,
                    'product_code': assets[index].code,
                    'product_name': assets[index].name,
                  });
                }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${assets[index].code} ${assets[index].name}",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      // subtitle: Text(
                      //   "${assets[index].name}",
                      //   style: TextStyle(color: Colors.cyan[700]),
                      // ),
                      trailing: Text(
                        "${assets[index].qty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 20),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            });
        return productCards;
      } else {
        return Container(
          child: Center(
            child: Text(
              'ไม่พบข้อมูล',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Center(
          child: Text('ไม่พบข้อมูล'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //customers.fetCustomers();
    //  IssueData issuedata = Provider.of<IssueData>(context, listen: false);
    // issuedata.fetIssueitems();
    // print('creatd order new');
    var formatter = NumberFormat('#,##,##0');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'ตรวจสอบสถานะอุปกรณ์',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          //body: SaleProductItem(),
          padding: EdgeInsets.only(left: 1, right: 1, top: 0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Consumer<CustomerData>(
                            builder: (context, _customer, _) => TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadController,
                                autofocus: false,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontStyle: FontStyle.normal),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'ค้นหาลูกค้า'),
                              ),
                              // suggestionsCallback: (pattern) async {
                              //   return await BackendService.getSuggestions(pattern);
                              // },
                              suggestionsCallback: (pattern) async {
                                return await _customer.findCustomer(pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  // leading: Icon(Icons.shopping_cart),
                                  title: Text(suggestion.name),
                                  // subtitle: Text('\$${suggestion['price']}'),
                                );
                              },

                              onSuggestionSelected: (items) {
                                setState(() {
                                  selectedValue = items.id;
                                  selectedValueName = items.name;
                                  CustomerData customerdata =
                                      Provider.of<CustomerData>(context,
                                          listen: false);
                                  customerdata.fetCustomerAsset(selectedValue);
                                  this._typeAheadController.text = items.name;
                                });
                              },
                              noItemsFoundBuilder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'ไม่พบข้อมูล',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[100])),
                          onPressed: () {
                            selectedValue = '';
                            selectedValue = '';
                            selectedValueName = '';
                            CustomerData customerdata =
                                Provider.of<CustomerData>(context,
                                    listen: false);
                            customerdata.fetCustomerAsset(selectedValue);

                            this._typeAheadController.text = '';
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.refresh_rounded,
                              size: 45,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "รายการอุปกรณ์",
              //   style: TextStyle(color: Colors.grey[600], fontSize: 18),
              // ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Consumer<CustomerData>(
                  builder: (context, assets, _) =>
                      _buildproductList(assets.listcustomerasset),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:ice_app_new/models/car.dart';
import 'package:ice_app_new/pages/ordercheckout.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
//import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/providers/issuedata.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
// import 'package:ice_app_new/providers/customer.dart';
// import 'package:ice_app_new/providers/order.dart';

import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/products.dart';
//import 'package:ice_app_new/models/issueitems.dart';

class CreateorderBootPage extends StatefulWidget {
  static const routeName = '/createorderboot';
  @override
  _CreateorderBootPageState createState() => _CreateorderBootPageState();
}

class _CreateorderBootPageState extends State<CreateorderBootPage> {
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
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    //Provider.of<CustomerData>(context, listen: false).fetCustomerboot();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   Provider.of<CustomerData>(context, listen: false)
    //       .fetCustomers()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;

    //       // print('issue id is ${selectedIssue}');
    //     });
    //   });

    //   // setState(() {
    //   //   _isLoading = true;

    //   // });

    //   // Provider.of<ProductData>(context, listen: false)
    //   //     .fetProducts("")
    //   //     .then((_) {
    //   //   setState(() {
    //   //     _isLoading = false;
    //   //   });
    //   // });
    // }
    // _isInit = false;
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

  void _editBottomSheet(
    context,
    String name,
    String onhand,
    String product_id,
    String price,
    String product_name,
    String product_code,
    String price_group_id,
  ) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    final TextEditingController _saleqtyTextController =
        TextEditingController();
    // _saleqtyTextController.text = '0';
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              //  height: MediaQuery.of(context).size.height * 0.9,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Icon(
                        //   Icons.check,
                        //   color: Colors.green,
                        // ),
                        Text("รายการละเอียดสินค้า"),
                        SizedBox(width: 10),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.cancel,
                                color: Colors.orange, size: 25),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[400],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Row(children: <Widget>[
                            Text(
                              "${name}",
                              style: TextStyle(
                                  color: Colors.purple[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Row(children: <Widget>[
                            Text(
                              "ราคา",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            Text(
                              " ${price}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Text(
                              " คงเหลือ",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            Text(
                              " ${onhand}",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(2.0)),
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          controller: _saleqtyTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(
                              fontSize: 40, color: Colors.deepPurple[400]),
                          onChanged: (String value) {
                            if (num.tryParse('$value').toDouble() >
                                num.tryParse('$onhand').toDouble()) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'พบข้อผิดพลาด',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content:
                                          Text('จำนวนขายมากกว่าจำนวนคงเหลือ'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('ตกลง'))
                                      ],
                                    );
                                  });
                              _saleqtyTextController.text = onhand.toString();
                            } else {
                              // print('can sale');

                            }
                          },
                        )),
                      ],
                    ),
                    SizedBox(height: 10),
                    // SizedBox(height: 90),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                      child: SizedBox(
                        height: 55.0,
                        width: targetWidth,
                        child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              elevation: 5,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                            ),
                            child: new Text('เพิ่มรายการ',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              print(
                                  'enter value is ${_typeAheadController.text}');
                              if (num.tryParse(_saleqtyTextController.text)
                                      .toDouble() >
                                  0) {
                                orderItems.forEach((element) {
                                  orderItems.removeWhere((item) =>
                                      item.product_id == product_id &&
                                      item.qty == _saleqtyTextController.text);
                                });

                                final Addorder order_item = new Addorder(
                                  customer_id: selectedValue,
                                  customer_name: selectedValueName,
                                  product_id: product_id,
                                  product_code: product_code,
                                  product_name: product_name,
                                  qty: _saleqtyTextController.text,
                                  sale_price: price,
                                  price_group_id: price_group_id,
                                );
                                setState(() {
                                  orderItems.add(order_item);
                                });
                                Fluttertoast.showToast(
                                    msg: "เพิ่มรายการแล้ว",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "จำนวนขายต้องมากกว่า 0",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                // Scaffold.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Row(
                                //       children: <Widget>[
                                //         Icon(
                                //           Icons.error_outline_outlined,
                                //           color: Colors.white,
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           "จำนวนขายต้องมากกว่า 0",
                                //           style: TextStyle(color: Colors.white),
                                //         ),
                                //       ],
                                //     ),
                                //     backgroundColor: Colors.red,
                                //   ),
                                // );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildproductList(List<Products> products) {
    Widget productCards;

    if (products != null) {
      if (products.length > 0) {
        // print("has product item list");
        productCards = new GridView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            //   physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 1),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Card(
                  child: Hero(
                    tag: "${products[index].id}",
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          // String _avl = Provider.of<IssueData>(context, listen: false)
                          //     .listissue
                          //     .firstWhere((value) => value.product_id == _id)
                          //     .avl_qty;
                          String _avl = products[index].onhand;
                          if (selectedValue == null || selectedValue == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "เลือกรายชื่อลูกค้าก่อน",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return false;
                          }
                          _editBottomSheet(
                            context,
                            products[index].name,
                            products[index].onhand,
                            products[index].id,
                            products[index].sale_price,
                            products[index].name,
                            products[index].code,
                            products[index].price_group_id,
                          );
                        },
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image.asset("assets/ice_cube.png"),
                                  Icon(
                                    Icons.image_rounded,
                                    color: Colors.deepPurple,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Text("${products[index].name}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("${products[index].sale_price} B",
                                            style: TextStyle(
                                                color: Colors.blue[800])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
            'ขายออกบูธ',
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
                        // Text(
                        //   "ยอดขาย",
                        //   style: TextStyle(fontSize: 20, color: Colors.black87),
                        // ),
                        // SizedBox(width: 5),
                        // Chip(
                        //   label: Text(
                        //     "${formatter.format(orders.totalAmount)}",
                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                        //   ),
                        //   backgroundColor: Theme.of(context).primaryColor,
                        // ),
                        // Text("บาท",
                        //     style: TextStyle(fontSize: 20, color: Colors.black87)),
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
                                return await _customer
                                    .findCustomer(pattern); // online
                                // return await DbHelper.instance
                                //     .findCustomer(pattern); // offline
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

                                  IssueData issuedata = Provider.of<IssueData>(
                                      context,
                                      listen: false);

                                  issuedata.fetIssueitems();
                                  if (issuedata.userconfirm == 1) {
                                    Provider.of<ProductData>(context,
                                            listen: false)
                                        .fetProductissue(selectedValue);
                                    isuserconfirm = 1;
                                  }

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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                          ),
                          onPressed: () {
                            selectedValue = '';
                            selectedValue = '';
                            selectedValueName = '';
                            IssueData issuedata =
                                Provider.of<IssueData>(context, listen: false);
                            issuedata.fetIssueitems();
                            if (issuedata.userconfirm == 1) {
                              Provider.of<ProductData>(context, listen: false)
                                  .fetProductissue(selectedValue);
                              isuserconfirm = 1;
                            }

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
              Text(
                "รายการสินค้า",
                style: TextStyle(color: Colors.grey[600], fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: isuserconfirm == 1
                    ? Consumer<ProductData>(
                        builder: (context, products, _) =>
                            _buildproductList(products.listproduct),
                      )
                    : Center(
                        child: Text(
                        'ไม่พบรายการ',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Consumer<PaymentreceiveData>(
                                  builder: (context, totals, _) => Row(
                                    children: <Widget>[
                                      Text(
                                        'รายการ ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '${formatter.format(orderItems.length)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: orderItems.length > 0
                              ? Colors.green[700]
                              : Colors.green[100],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'ถัดไป',
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
                          if (orderItems.length <= 0) {
                            return false;
                          } else {
                            Navigator.of(context).pushNamed(
                                OrdercheckoutPage.routeName,
                                arguments: {
                                  'orderitemlist': orderItems,
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

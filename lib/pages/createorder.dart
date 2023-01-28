import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/product.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/providers/issuedata.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
// import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/order.dart';

import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/products.dart';
//import 'package:ice_app_new/models/issueitems.dart';

class CreateorderPage extends StatefulWidget {
  static const routeName = '/createorder';
  @override
  _CreateorderPageState createState() => _CreateorderPageState();
}

class _CreateorderPageState extends State<CreateorderPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  int isuserconfirm = 0;
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
      _showdialog(
          'No intenet', 'กรุณาตรวจสอบการเชื่อมต่อ หรือ ใช้งานโหมดออฟไลน์');
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
              return Items(
                  products[index].id,
                  products[index].code,
                  products[index].name,
                  products[index].sale_price,
                  selectedValue,
                  products[index].issue_id,
                  products[index].onhand);
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'ทำรายการขาย',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          //body: SaleProductItem(),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Container(
              //         color: Colors.purple,
              //         child: Consumer<CustomerData>(
              //           builder: (context, customers, _) =>
              //               DropdownButtonHideUnderline(
              //             child: Container(
              //               padding: EdgeInsets.only(left: 16, right: 16),
              //               decoration: BoxDecoration(
              //                   border:
              //                       Border.all(color: Colors.grey, width: 0.1),
              //                   borderRadius: BorderRadius.circular(1)),
              //               child: ButtonTheme(
              //                 alignedDropdown: true,
              //                 child: DropdownButton(
              //                   value: selectedValue,
              //                   iconSize: 30,
              //                   icon: Icon(Icons.find_in_page,
              //                       color: Colors.white),
              //                   style: TextStyle(
              //                       color: Colors.black54, fontSize: 16),
              //                   hint: Text(
              //                     'เลือกลูกค้า',
              //                     style: TextStyle(
              //                         fontFamily: 'Kanit-Regular',
              //                         color: Colors.white),
              //                   ),
              //                   dropdownColor: Colors.purple,
              //                   items: customers.listcustomer != null
              //                       ? customers.listcustomer
              //                           .map((e) => DropdownMenuItem(
              //                               value: e.id,
              //                               child: Text(e.name,
              //                                   style: TextStyle(
              //                                       fontFamily: 'Kanit-Regular',
              //                                       color: Colors.white))))
              //                           .toList()
              //                       : null,
              //                   onChanged: (String value) {
              //                     setState(() {
              //                       selectedValue = value;

              //                       Provider.of<ProductData>(context,
              //                               listen: false)
              //                           .fetProductissue(value);
              //                     });
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: <Widget>[
                  FutureBuilder(builder: (context, dataSapshort) {
                    if (dataSapshort.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (dataSapshort.error != null) {
                        return Center(child: Text('Data Error'));
                      } else {
                        return Expanded(
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
                                      hintText: 'เลือกลูกค้า')),
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
                                //print(items.id);
                                setState(() {
                                  selectedValue = items.id;
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
                        );
                      }
                    }
                  }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "รายการสินค้า",
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: isuserconfirm == 1
                          ? Column(
                              children: [
                                Consumer<ProductData>(
                                  builder: (context, products, _) =>
                                      _buildproductList(products.listproduct),
                                ),
                              ],
                            )
                          : Text('ไม่พบรายการ'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  //orders _products;
  final String _id;
  final String _code;
  final String _name;
  final String _price;
  final String selectedValue;
  final String issue_id;
  final String _onhand;

  Addorder _orderData;

  Items(this._id, this._code, this._name, this._price, this.selectedValue,
      this.issue_id, this._onhand);

  void _editBottomSheet(context, String avl_qty) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    final TextEditingController _saleqtyTextController =
        TextEditingController();
    _saleqtyTextController.text = '0';
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
                    // Row(
                    //   children: <Widget>[
                    //     // Icon(
                    //     //   Icons.check,
                    //     //   color: Colors.green,
                    //     // ),
                    //     Text("จำนวนที่ขายได้"),
                    //     SizedBox(width: 10),
                    //     Text("${avl_qty}"),
                    //     Spacer(),
                    //     IconButton(
                    //         icon: Icon(Icons.cancel,
                    //             color: Colors.orange, size: 25),
                    //         onPressed: () => Navigator.of(context).pop())
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Row(children: <Widget>[
                            Text(
                              "${_name}",
                              style: TextStyle(
                                  color: Colors.purple[900], fontSize: 20),
                            ),
                            Text(
                              " (คงเหลือ ${_onhand})",
                              style: TextStyle(color: Colors.red),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Row(
                    //   children: <Widget>[
                    //     NumberPicker(
                    //       value: _currentValue,
                    //       minValue: 0,
                    //       maxValue: 100,
                    //       onChanged: (value) =>
                    //           setState(() => _currentValue = value),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(2.0)),
                        Expanded(
                            child: TextField(
                          controller: _saleqtyTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              //hintText: "0",

                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(
                              fontSize: 40, color: Colors.deepPurple[400]),
                          onChanged: (String value) {
                            if (num.tryParse('$value').toDouble() >
                                num.tryParse('$avl_qty').toDouble()) {
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
                              _saleqtyTextController.text = avl_qty.toString();
                            } else {
                              print('can sale');
                              _orderData = new Addorder(
                                customer_id: selectedValue,
                                product_id: _id,
                                qty: value,
                                sale_price: _price,
                              );
                              print(_orderData.qty);
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
                            child: new Text('เงินสด',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              _addorder(context, '1');
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                      child: SizedBox(
                        height: 55.0,
                        width: targetWidth,
                        child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              elevation: 5,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                            ),
                            child: new Text('เงินเชื่อ',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              _addorder(context, "2");
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                      child: SizedBox(
                        height: 55.0,
                        width: targetWidth,
                        child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              elevation: 5,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                            ),
                            child: new Text('ฟรี',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              _addorder(context, "3");
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     ElevatedButton(
                    //       padding: EdgeInsets.all(20.0),
                    //       onPressed: () {
                    //         _addorder(context);
                    //         Navigator.pop(context);
                    //       },
                    //       child: Text(
                    //         'เงินสด',
                    //         style: TextStyle(color: Colors.white, fontSize: 20),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     ElevatedButton(
                    //       color: Colors.orange,
                    //       padding: EdgeInsets.all(20.0),
                    //       onPressed: () {
                    //         _addorder(context);
                    //         Navigator.pop(context);
                    //       },
                    //       child: Text(
                    //         'เงินเชื่อ',
                    //         style: TextStyle(color: Colors.white, fontSize: 20),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Expanded(
                    //   flex: 2,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //           flex: 2,
                    //           child: Container(
                    //               padding: EdgeInsets.all(2),
                    //               alignment: Alignment.center,
                    //               //color: Colors.green[500],
                    //               child: MaterialButton(
                    //                 padding: EdgeInsets.all(20),
                    //                 color: Colors.green,
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(10)),
                    //                 child: Align(
                    //                   child: Text(
                    //                     'เงินสด',
                    //                     style: TextStyle(
                    //                         color: Colors.white, fontSize: 20),
                    //                   ),
                    //                 ),
                    //                 onPressed: () {
                    //                   _addorder(context);
                    //                   Navigator.pop(context);
                    //                 },
                    //               ))),
                    //       Expanded(
                    //         flex: 2,
                    //         child: Container(
                    //           padding: EdgeInsets.all(2),
                    //           alignment: Alignment.center,
                    //           // color: Colors.amber,
                    //           child: MaterialButton(
                    //             padding: EdgeInsets.all(20),
                    //             color: Colors.blue,
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10)),
                    //             child: Align(
                    //               child: Text(
                    //                 'เงินเชื่อ',
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 20),
                    //               ),
                    //             ),
                    //             onPressed: () => {},
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _addorder(context, String payment_type_id) async {
    //print(_orderData.customer_id);
    // final String product_id = _id;
    // final String qty = "10";

    if (double.parse(_orderData.qty) <= 0 ||
        _orderData.qty == null ||
        _orderData.qty.isEmpty ||
        _orderData.qty == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'พบข้อผิดพลาด',
                style: TextStyle(color: Colors.red),
              ),
              content: Text('กรุณาป้อนจำนวนที่ต้องการขาย'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'))
              ],
            );
          });
    } else {
      bool issave =
          await Provider.of<OrderData>(context, listen: false).addOrder(
        _orderData.product_id,
        _orderData.qty,
        _price,
        _orderData.customer_id,
        issue_id,
        payment_type_id,
      );
      if (issave == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
          ),
        );
      } else {
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
                  "พบข้อผิดพลาดลองใหม่อีกครั้ง",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Hero(
          tag: "$_id",
          child: Material(
            child: InkWell(
              onTap: () {
                // String _avl = Provider.of<IssueData>(context, listen: false)
                //     .listissue
                //     .firstWhere((value) => value.product_id == _id)
                //     .avl_qty;
                String _avl = _onhand;
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
                _editBottomSheet(context, _avl);
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
                        Center(
                          child: Text("$_name"),
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
  }
}

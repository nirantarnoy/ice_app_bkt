import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/product.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/providers/issuedata.dart';

import 'package:ice_app_new/models/customers.dart';
import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/order.dart';

import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/products.dart';
import 'package:ice_app_new/models/issueitems.dart';

class CreateorderPage extends StatefulWidget {
  static const routeName = '/createorder';
  @override
  _CreateorderPageState createState() => _CreateorderPageState();
}

class _CreateorderPageState extends State<CreateorderPage> {
  String selectedValue;
  String selectedIssue;
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
          selectedIssue = Provider.of<IssueData>(context).listissue.length > 1
              ? Provider.of<IssueData>(context).listissue[0].issue_id
              : 0;
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
              FlatButton(
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
        print("has product item list");
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
                  selectedIssue);
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
    return SafeArea(
      child: Scaffold(
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.purple,
                      child: Consumer<CustomerData>(
                        builder: (context, customers, _) =>
                            DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.1),
                                borderRadius: BorderRadius.circular(1)),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                value: selectedValue,
                                iconSize: 30,
                                icon: Icon(Icons.find_in_page,
                                    color: Colors.white),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                                hint: Text(
                                  'เลือกลูกค้า',
                                  style: TextStyle(
                                      fontFamily: 'Kanit-Regular',
                                      color: Colors.white),
                                ),
                                dropdownColor: Colors.purple,
                                items: customers.listcustomer != null
                                    ? customers.listcustomer
                                        .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(e.name,
                                                style: TextStyle(
                                                    fontFamily: 'Kanit-Regular',
                                                    color: Colors.white))))
                                        .toList()
                                    : null,
                                onChanged: (String value) {
                                  setState(() {
                                    selectedValue = value;
                                    Provider.of<ProductData>(context,
                                            listen: false)
                                        .fetProducts(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
              Expanded(
                child: Consumer<ProductData>(
                  builder: (context, products, _) =>
                      _buildproductList(products.listproduct),
                ),
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

  Addorder _orderData;

  Items(
    this._id,
    this._code,
    this._name,
    this._price,
    this.selectedValue,
    this.issue_id,
  );

  void _editBottomSheet(context, String avl_qty) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
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
                    children: [
                      Center(
                        child: Row(children: <Widget>[
                          Text(
                            "${_name}",
                            style: TextStyle(
                                color: Colors.green[900], fontSize: 20),
                          )
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.all(2.0)),
                    Expanded(
                        child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                          fontSize: 40, color: Colors.deepPurple[400]),
                      onChanged: (String value) {
                        if (int.parse(value) > int.parse(avl_qty)) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'พบข้อผิหลาด',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text('จำนวนขายมากกว่าจำนวนคงเหลือ'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('ตกลง'))
                                  ],
                                );
                              });
                        } else {
                          _orderData = new Addorder(
                            customer_id: selectedValue,
                            product_id: _id,
                            qty: value,
                            sale_price: _price,
                          );
                        }
                      },
                    )),
                  ]),
                  SizedBox(height: 10),
                  SizedBox(height: 90),
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  //color: Colors.green[500],
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Align(
                                      child: Text(
                                        'เงินสด',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    onPressed: () {
                                      _addorder(context);
                                      Navigator.pop(context);
                                    },
                                  ))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  // color: Colors.amber,
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Align(
                                      child: Text(
                                        'เงินเชื่อ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ))),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  void _addorder(context) {
    //print(_orderData.customer_id);
    // final String product_id = _id;
    // final String qty = "10";

    if (int.parse(_orderData.qty) <= 0 ||
        _orderData.qty == null ||
        _orderData.qty.isEmpty ||
        _orderData.qty == "") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'พบข้อผิหลาด',
                style: TextStyle(color: Colors.red),
              ),
              content: Text('กรุณาป้อนจำนวนที่ต้องการขาย'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'))
              ],
            );
          });
    } else {
      Provider.of<OrderData>(context, listen: false)
          .addOrder(
            _orderData.product_id,
            _orderData.qty,
            _price,
            _orderData.customer_id,
            issue_id,
          )
          .then((_) => {
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: Text('Successfully'),
                //         content: Text('บันทึกรายการเรียบร้อยแล้ว'),
                //         actions: <Widget>[
                //           FlatButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //               child: Text('ok'))
                //         ],
                //       );
                //     })
                Scaffold.of(context).showSnackBar(SnackBar(
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
                ))
              });
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
              String _avl = Provider.of<IssueData>(context, listen: false)
                  .listissue
                  .firstWhere((value) => value.product_id == _id)
                  .avl_qty;
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
    ));
    // return new GestureDetector(
    //   onTap: () =>
    //       Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
    //   child: Card(
    //       child: ListTile(
    //     leading: Icon(
    //       Icons.shopping_cart_outlined,
    //       color: Colors.blueAccent,
    //       size: 50.0,
    //     ),
    //     title: Text(
    //       "$_order_no $_note",
    //       style: TextStyle(
    //         fontSize: 16,
    //       ),
    //     ),
    //     subtitle: Text("$_order_date ($_customer_name)"),
    //   )),
    // );
  }
}

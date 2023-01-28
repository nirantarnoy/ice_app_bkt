import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/transferin.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:intl/intl.dart';
// import 'package:ice_app_new/pages/createtransfer.dart';
// import 'package:ice_app_new/providers/transferout.dart';
import 'package:provider/provider.dart';

// import '../../models/transferout.dart';

class Transferinitem extends StatelessWidget {
  // List<Transferout> _orders = [];
  Widget _buildissueitemList(List<Transferin> transferout_items) {
    Widget productCards;
    if (transferout_items.isNotEmpty) {
      if (transferout_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: transferout_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              transferout_items[index].transfer_id.toString(),
              transferout_items[index].journal_no.toString(),
              transferout_items[index].from_route.toString(),
              transferout_items[index].from_order_no.toString(),
              transferout_items[index].from_car_no.toString(),
              transferout_items[index].qty.toString(),
              transferout_items[index].product_id.toString(),
              transferout_items[index].product_name.toString(),
              transferout_items[index].sale_price.toString(),
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
    var formatter = NumberFormat('#,##,##0');
    final TransferinData item_transferout =
        Provider.of<TransferinData>(context, listen: false);
    // item_issues.fetIssueitems();

    return Column(
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
                Text(
                  "รับโอนสินค้าเข้า",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: _buildissueitemList(item_transferout.listtransferin)),
        // Row(
        //   children: <Widget>[
        //     Expanded(
        //       child: Card(
        //         margin: EdgeInsets.only(left: 15, right: 20),
        //         child: Padding(
        //           padding: EdgeInsets.all(8),
        //           child: Column(
        //             children: <Widget>[
        //               SizedBox(
        //                 height: 10,
        //               ),
        //               Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: <Widget>[
        //                     Text(
        //                       "จำนวน",
        //                       style:
        //                           TextStyle(fontSize: 20, color: Colors.purple),
        //                     ),
        //                     SizedBox(width: 10),
        //                     Chip(
        //                       label: Consumer<TransferinData>(
        //                         builder: (context, transferouts, _) => Text(
        //                           transferouts.totalAmount == null
        //                               ? 0
        //                               : '${formatter.format(transferouts.totalAmount)}',
        //                           style: TextStyle(
        //                               color: Colors.white, fontSize: 20),
        //                         ),
        //                       ),
        //                       backgroundColor: Theme.of(context).primaryColor,
        //                     ),
        //                   ]),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: FloatingActionButton(
        //           backgroundColor: Colors.green[400],
        //           child: Icon(
        //             Icons.add,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => CreatetransferPage()));
        //           }),
        //     ),
        //     // Expanded(
        //     //   child: Card(
        //     //     margin: EdgeInsets.only(left: 15),
        //     //     child: Padding(
        //     //       padding: EdgeInsets.all(8),
        //     //       child: Column(
        //     //         children: <Widget>[

        //     //         ],
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
      ],
    );
  }
}

class Items extends StatefulWidget {
  //orders _orders;
  final String _transfer_id;
  final String _journal_no;
  final String _from_route;
  final String _from_order_no;
  final String _from_car_no;
  final String _qty;
  final String _product_id;
  final String _product_name;
  final String _sale_price;

  Items(
    this._transfer_id,
    this._journal_no,
    this._from_route,
    this._from_order_no,
    this._from_car_no,
    this._qty,
    this._product_id,
    this._product_name,
    this._sale_price,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _textqtyController = TextEditingController();

  final Map<String, dynamic> _formData = {
    'product_id': null,
    'sale_qty': 0,
    'customer_id': null,
    'sale_price': null,
    'transfer_id': null
  };

  String selectedValue;

  Future _customerFuture;
  Future _obtaincarFuture() {
    return Provider.of<CustomerData>(context, listen: false).fetCustomers();
  }

  @override
  void initState() {
    _customerFuture = _obtaincarFuture();
    // TODO: implement initState
    super.initState();
  }

  Widget _buildsaleqty() {
    return TextFormField(
      controller: _textqtyController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'จำนวน', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'กรุณากรอกจำนวน';
        }
      },
      onChanged: (value) {
        if (int.parse(value) > int.parse(widget._qty)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'พบข้อผิดพลาด',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text('จำนวนขายมากกว่าจำนวนคงเหลือ'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _textqtyController.text = value.toString();
                        });
                        Navigator.of(context).pop(false);
                      },
                      child: Text('ตกลง'),
                    )
                  ],
                );
              });
        }
      },
      onSaved: (String value) {
        _formData['sale_qty'] = value;
      },
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    Provider.of<OrderData>(context, listen: false)
        .addOrderFromtransfer(
      _formData['product_id'],
      _formData['sale_qty'],
      _formData['sale_price'],
      _formData['customer_id'],
      _formData['transfer_id'],
    )
        .then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        ));

        Navigator.of(context).pop();
      },
    );
    setState(() {
      Provider.of<TransferinData>(context, listen: false).fetTransferin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;
    var formatter = NumberFormat('#,##,##0');
    return new GestureDetector(
      onTap: () {
        _formData['product_id'] = widget._product_id;
        _formData['sale_price'] = widget._sale_price;
        _formData['transfer_id'] = widget._transfer_id;
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 300,
                    // height: MediaQuery.of(context).size.height - 100,
                    // width: double.infinity,
                    // height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                                child: Text(
                              "ลูกค้า",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                FutureBuilder(
                                    future: _customerFuture,
                                    builder: (context, dataSapshort) {
                                      if (dataSapshort.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (dataSapshort.error != null) {
                                          return Center(
                                              child: Text('Data Error'));
                                        } else {
                                          return Expanded(
                                            child: Consumer<CustomerData>(
                                              builder:
                                                  (context, _customer, _) =>
                                                      TypeAheadField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                        controller:
                                                            _typeAheadController,
                                                        autofocus: false,
                                                        style: DefaultTextStyle
                                                                .of(context)
                                                            .style
                                                            .copyWith(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal),
                                                        decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'เลือกลูกค้า')),
                                                // suggestionsCallback: (pattern) async {
                                                //   return await BackendService.getSuggestions(pattern);
                                                // },
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  return await _customer
                                                      .findCustomer(pattern);
                                                },
                                                itemBuilder:
                                                    (context, suggestion) {
                                                  return ListTile(
                                                    // leading: Icon(Icons.shopping_cart),
                                                    title:
                                                        Text(suggestion.name),
                                                    // subtitle: Text('\$${suggestion['price']}'),
                                                  );
                                                },
                                                onSuggestionSelected: (items) {
                                                  print('customer is ' +
                                                      items.id);
                                                  setState(() {
                                                    //  selectedValue = items.id;
                                                    _formData['customer_id'] =
                                                        items.id;
                                                    _typeAheadController.text =
                                                        items.name;
                                                  });
                                                },
                                                noItemsFoundBuilder: (context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'ไม่พบข้อมูล',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.red),
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
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  _buildsaleqty(),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                              child: SizedBox(
                                height: 55.0,
                                width: targetWidth,
                                child: new ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[700],
                                      elevation: 0.2,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                    ),
                                    child: new Text('เงินสด',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () {
                                      _submitForm();
                                      // Navigator.pop(context);
                                    }),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                              child: SizedBox(
                                height: 55.0,
                                width: targetWidth,
                                child: new ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[700],
                                      elevation: 0.2,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                    ),
                                    child: new Text('เงินเชื่อ',
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    onPressed: () {
                                      _submitForm();
                                      Navigator.pop(context);
                                    }),
                              ),
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: <Widget>[
                            //         ElevatedButton(
                            //           padding: EdgeInsets.only(right: 8),
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(15)),
                            //           color: Colors.blue[500],
                            //           textColor: Colors.white,
                            //           onPressed: () {
                            //             _submitForm();
                            //           },
                            //           child: Text("บันทีก"),
                            //         ),
                            //         SizedBox(width: 20),
                            //         ElevatedButton(
                            //           padding: EdgeInsets.only(left: 8),
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(15)),
                            //           color: Colors.orange,
                            //           textColor: Colors.white,
                            //           onPressed: () {
                            //             Navigator.pop(context);
                            //           },
                            //           child: Text("ยกเลิก"),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      child: Column(
        children: <Widget>[
          ListTile(
            // leading: ConstrainedBox(
            //   constraints: BoxConstraints(minHeight: 100, minWidth: 100),
            //   child: Text("$_journal_no"),
            // ),
            title: Text(
              "${widget._product_name}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Text("จากรถทะเบียน"),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget._from_car_no}",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            trailing: Text('${formatter.format(double.parse(widget._qty))}',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800])),
          ),
          Divider(),
        ],
      ),
    );
  }
}

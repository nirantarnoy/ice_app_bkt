import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/pages/transfersuccess.dart';
import 'package:ice_app_new/providers/car.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:intl/intl.dart';
// import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

class TransferProductItem extends StatefulWidget {
  String transfer_total = "0";
  TransferProductItem({this.transfer_total});
  @override
  _TransferProductItemState createState() => _TransferProductItemState();
}

class _TransferProductItemState extends State<TransferProductItem> {
  Future _carFuture;
  Future _obtaincarFuture() {
    return Provider.of<CarData>(context, listen: false).fethCar();
  }

  @override
  void initState() {
    _carFuture = _obtaincarFuture();
    Provider.of<IssueData>(context, listen: false).resetqty();
    super.initState();
  }

  void _submitForm(
      List<TransferProduct> transferdata, String route_id, String car_id) {
    print('transferdata is ${transferdata[0].qty}');
    if (transferdata.isNotEmpty) {
      Future<bool> res = Provider.of<TransferoutData>(context, listen: false)
          .addTransfer(route_id, car_id, transferdata);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransfersuccessPage(),
        ),
      );
      //Navigator.of(context).pop();
      // if (res == true) {
      //   Scaffold.of(context).showSnackBar(
      //     SnackBar(
      //       content: Row(
      //         children: <Widget>[
      //           Icon(
      //             Icons.check_circle,
      //             color: Colors.white,
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Text(
      //             "ทำรายการสำเร็จ",
      //             style: TextStyle(color: Colors.white),
      //           ),
      //         ],
      //       ),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // }
    }
  }

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
              issueproduct[index].avl_qty,
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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _typeAheadController = TextEditingController();
    String selectedValue;
    String selectedCarValue;

    var formatter = NumberFormat('#,##,##0');
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
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Consumer<IssueData>(
                          builder: (context, totals, _) => Row(
                            children: <Widget>[
                              Text(
                                'รวม ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${formatter.format(totals.transferouttotal)}',
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
              child: Consumer<IssueData>(
                builder: (context, totals, _) => GestureDetector(
                  child: Container(
                    color: Colors.green[700],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text(
                            'ตกลง',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    if (totals.transferouttotal > 0) {
                      // check transfer qty > 0
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 10,
                                height:
                                    MediaQuery.of(context).size.height - 500,
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
                                            "โอนสินค้าไปยัง",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: <Widget>[
                                            FutureBuilder(
                                                future: _carFuture,
                                                builder:
                                                    (context, dataSapshort) {
                                                  if (dataSapshort
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    if (dataSapshort.error !=
                                                        null) {
                                                      return Center(
                                                          child: Text(
                                                              'Data Error'));
                                                    } else {
                                                      return Expanded(
                                                        child:
                                                            Consumer<CarData>(
                                                          builder: (context,
                                                                  _car, _) =>
                                                              TypeAheadField(
                                                            textFieldConfiguration: TextFieldConfiguration(
                                                                controller:
                                                                    _typeAheadController,
                                                                autofocus:
                                                                    false,
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style
                                                                    .copyWith(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal),
                                                                decoration: InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        'เลือกรถที่ต้องการโอน')),
                                                            // suggestionsCallback: (pattern) async {
                                                            //   return await BackendService.getSuggestions(pattern);
                                                            // },
                                                            suggestionsCallback:
                                                                (pattern) async {
                                                              return await _car
                                                                  .findCar(
                                                                      pattern);
                                                            },
                                                            itemBuilder:
                                                                (context,
                                                                    suggestion) {
                                                              return ListTile(
                                                                // leading: Icon(Icons.shopping_cart),
                                                                title: Text(
                                                                    suggestion
                                                                        .route_name),
                                                                // subtitle: Text('\$${suggestion['price']}'),
                                                              );
                                                            },
                                                            onSuggestionSelected:
                                                                (items) {
                                                              print(
                                                                  'customer is ' +
                                                                      items.id);
                                                              setState(() {
                                                                selectedValue =
                                                                    items
                                                                        .route_id;
                                                                selectedCarValue =
                                                                    items.id;

                                                                _typeAheadController
                                                                        .text =
                                                                    items
                                                                        .route_name;
                                                              });
                                                            },
                                                            noItemsFoundBuilder:
                                                                (context) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'ไม่พบข้อมูล',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Consumer<IssueData>(
                                                  builder: (context,
                                                          transferdata, _) =>
                                                      ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue[500],
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      padding: EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                      elevation: 0.2,
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  15.0)),
                                                    ),
                                                    onPressed: () {
                                                      _submitForm(
                                                        transferdata
                                                            .transferproductitems,
                                                        selectedValue,
                                                        selectedCarValue,
                                                      );
                                                    },
                                                    child: Text("บันทีก"),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue[500],
                                                    textStyle: TextStyle(
                                                        color: Colors.white),
                                                    padding: EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    elevation: 0.2,
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    15.0)),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("ยกเลิก"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _code;
  final String _name;
  final String _avl_qty;

  Items(
    this._id,
    this._code,
    this._name,
    this._avl_qty,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final TextEditingController _transferqtyController = TextEditingController();
  double _beforechange = 0;

  @override
  void initState() {
    // _transferqtyController.text = widget._avl_qty;
    _transferqtyController.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${widget._code}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // color: Colors.purple,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (int.parse(_transferqtyController.text) != 0) {
                              var new_value = 0;
                              new_value =
                                  int.parse(_transferqtyController.text) - 1;
                              _transferqtyController.text =
                                  new_value.toString();
                              Provider.of<IssueData>(context, listen: false)
                                  .updateTotalDown(
                                      widget._id, _transferqtyController.text);
                            }
                            // _transferqtyController.text = new_value.toString();
                          });
                        }),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      controller: _transferqtyController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onEditingComplete: () {
                        Provider.of<IssueData>(context, listen: false)
                            .updateTotalUp(
                                widget._id, _transferqtyController.text);
                      },
                      onTap: () {
                        setState(() {
                          _beforechange =
                              double.parse(_transferqtyController.text);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    // color: Colors.purple,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          var new_value = 0;
                          new_value =
                              int.parse(_transferqtyController.text) + 1;
                          _transferqtyController.text = new_value.toString();
                          Provider.of<IssueData>(context, listen: false)
                              .updateTotalUp(
                                  widget._id, _transferqtyController.text);
                        });

                        if (double.parse(_transferqtyController.text) >
                            double.parse(widget._avl_qty)) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('แจ้งเตือน'),
                                  content: Text('จำนวนไม่พอสำหรับการทำรายการ'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          _transferqtyController.text =
                                              widget._avl_qty;
                                          Provider.of<IssueData>(context,
                                                  listen: false)
                                              .updateTotalUp(widget._id,
                                                  _transferqtyController.text);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('ตกลง'))
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
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

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/orders_new.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../pages/orderdetail.dart';
//import '../../pages/createorder.dart';

class OrderItemNew extends StatefulWidget {
  @override
  _OrderItemNewState createState() => _OrderItemNewState();
}

class _OrderItemNewState extends State<OrderItemNew> {
  List<Orders> _orders = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    }
  }

  Widget _buildordersList(List<OrdersNew> orders) {
    Widget orderCards;
    if (orders.isNotEmpty) {
      if (orders.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            // primary: false,
            //  shrinkWrap: true,
            //  physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) => Items(
                  orders[index].id,
                  orders[index].order_no,
                  orders[index].customer_id,
                  orders[index].customer_code,
                  orders[index].customer_name,
                  orders[index].order_date,
                  orders[index].product_id,
                  orders[index].product_code,
                  orders[index].product_name,
                  orders[index].payment_method_id,
                  orders[index].qty,
                  orders[index].price,
                  orders[index].line_total,
                  orders,
                  index,
                  orders[index].order_line_id,
                  orders[index].order_line_date,
                  orders[index].order_line_status,
                ));
        return orderCards;
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }
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
    final OrderData orders = Provider.of<OrderData>(context);
    // orders.fetOrders();
    var formatter = NumberFormat('#,##,##0.#');
    return Column(
      children: <Widget>[
        Column(children: <Widget>[
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
                            if (_typeAheadController.value == '') {
                              print('not selected');
                            }
                            setState(() {
                              selectedValue = items.id;
                              orders.searchBycustomer = selectedValue;
                              OrderData getneworder = Provider.of<OrderData>(
                                  context,
                                  listen: false);
                              getneworder.fetOrders();
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
                          orders.searchBycustomer = selectedValue;
                          OrderData getneworder =
                              Provider.of<OrderData>(context, listen: false);
                          getneworder.fetOrders();
                          this._typeAheadController.text = '';
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 45,
                            color: Colors.grey[500],
                          ),
                        )),
                    // FloatingActionButton(
                    //     backgroundColor: Colors.green[500],
                    //     onPressed: () => Navigator.of(context)
                    //         .pushNamed(CreateorderPage.routeName),
                    //     child: Icon(Icons.add, color: Colors.white)
                    //     //   ElevatedButton(onPressed: () {}, child: Text("เพิ่มรายการขาย")),
                    //     ),
                  ]),
            ),
          ),
        ]),
        SizedBox(height: 5),
        Expanded(
          child: orders.listorder.isNotEmpty
              ? _buildordersList(orders.listorder)
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        ),
        SizedBox(
          height: 0,
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Consumer<OrderData>(
                  builder: (context, orders, _) => GestureDetector(
                    child: Container(
                      color: Colors.green[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  '${formatter.format(orders.cashTotalAmount)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'สด',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Expanded(
                child: Consumer<OrderData>(
                  builder: (context, orders, _) => GestureDetector(
                    child: Container(
                      color: Colors.orange[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  '${formatter.format(orders.creditTotalAmount)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'เชื่อ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Expanded(
                child: Consumer<OrderData>(
                  builder: (context, orders, _) => GestureDetector(
                    child: Container(
                      color: Colors.purple[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  '${formatter.format(orders.totalAmount)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'รวม',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _order_no;
  final String _customer_name;
  final String _customer_id;
  final String _customer_code;
  final String _order_date;
  final String _product_id;
  final String _product_code;
  final String _product_name;
  final String _payment_method_id;
  final String _qty;
  final String _price;
  final String _line_total;
  final List<OrdersNew> _orders;
  final int _index;
  final String _order_line_id;
  final String _order_line_date;
  final String _order_line_status;

  Items(
    this._id,
    this._order_no,
    this._customer_id,
    this._customer_code,
    this._customer_name,
    this._order_date,
    this._product_id,
    this._product_code,
    this._product_name,
    this._payment_method_id,
    this._qty,
    this._price,
    this._line_total,
    this._orders,
    this._index,
    this._order_line_id,
    this._order_line_date,
    this._order_line_status,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var formatter = NumberFormat('#,##,##0.#');

  DateFormat dateformatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    String sale_type = '';
    if (int.parse(widget._payment_method_id) == 1) {
      sale_type = 'สด';
    } else if (int.parse(widget._payment_method_id) == 2) {
      sale_type = 'เชื่อ';
    } else if (int.parse(widget._payment_method_id) == 3) {
      sale_type = 'ฟรี';
    }
    return Dismissible(
      key: ValueKey(widget._orders[widget._index]),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('ยืนยัน'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('ไม่'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        print(widget._orders[widget._index].id);
        setState(() {
          Provider.of<OrderData>(context, listen: false)
              .removeOrderDetail(widget._order_line_id);
          widget._orders.removeAt(widget._index);
        });
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
      },
      child: GestureDetector(
        onTap: () {
          var setData = Provider.of<OrderData>(context, listen: false);
          setData.idOrder = int.parse(widget._id);
          setData.orderCustomerId = widget._customer_id;
          Navigator.of(context).pushNamed(OrderDetailPage.routeName,
              arguments: {
                'customer_id': widget._customer_id,
                'order_id': widget._id
              });
        }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              // leading: ElevatedButton(
              //     color:
              //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
              //     onPressed: () {},
              //     child: Text(
              //       "$_payment_method",
              //       style: TextStyle(color: Colors.white),
              //     )),
              // leading: Chip(
              //   label:
              //       Text("${_order_no}", style: TextStyle(color: Colors.white)),
              //   backgroundColor: Colors.green[500],
              // ),
              leading: Chip(
                label: Text(
                    '${widget._orders.length - widget._index}.${sale_type}'),
                backgroundColor: int.parse(widget._payment_method_id) == 1
                    ? Colors.green[300]
                    : int.parse(widget._payment_method_id) == 2
                        ? Colors.orange[300]
                        : Colors.blue[200],
              ),
              title: Text(
                "${widget._customer_name}",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              subtitle: Text(
                "${widget._order_line_date}",
                style: TextStyle(color: Colors.cyan[700]),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget._order_line_status != '500'
                      ? Text(
                          "${formatter.format(double.parse(widget._line_total))}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                        )
                      : Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.red),
                        ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

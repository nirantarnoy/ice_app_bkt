import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/orders_new.dart';
import 'package:ice_app_new/page_offline/orderofflinedetail.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/sqlite/models/order.dart';
import 'package:ice_app_new/sqlite/models/orderoffline.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
import 'package:ice_app_new/sqlite/providers/orderoffline.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

//import '../../pages/createorder.dart';

class OrderOfflineItemNew extends StatefulWidget {
  @override
  _OrderItemOfflineNewState createState() => _OrderItemOfflineNewState();
}

class _OrderItemOfflineNewState extends State<OrderOfflineItemNew> {
  List<Order> _orders = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  var _isInit = true;
  var _isLoading = false;

  Future _obtaingetorderoffline() {
    Provider.of<OrderOfflineData>(context, listen: false).showItemlist();
  }

  @override
  void initState() {
    // TODO: implement initState
    _obtaingetorderoffline();
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

  Widget _buildordersList(List<Orderoffline> orders) {
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
                  orders[index].customer_id,
                  orders[index].customer_name,
                  orders[index].qty,
                  // "1",
                  orders[index].payment_method_id,
                  orders[index].total_amt,
                  orders[index].order_date,
                  orders,
                  index,
                  orders[index].data,
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
                            return await DbHelper.instance
                                .findCustomer(pattern); // offline
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
                            // print("xxxxxxxxxxxxxxxxxxxxxx");
                            setState(() {
                              selectedValue = items.id.toString();
                              print('customer select is ${selectedValue}');
                              OrderOfflineData getneworder =
                                  Provider.of<OrderOfflineData>(context,
                                      listen: false);
                              getneworder.fetOrderByCustomerId(selectedValue);
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
                          //orders.searchBycustomer = selectedValue;
                          OrderOfflineData getneworder =
                              Provider.of<OrderOfflineData>(context,
                                  listen: false);

                          getneworder.showItemlist();

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
        // Expanded(
        //   child: orders.listorderoffline.isNotEmpty
        //       ? _buildordersList(orders.listorderoffline)
        //       : Center(
        //           child: Text(
        //             "ไม่พบข้อมูล",
        //             style: TextStyle(fontSize: 20, color: Colors.grey),
        //           ),
        //         ),
        // ),
        Expanded(
          child: Consumer<OrderOfflineData>(
            builder: (context, _orders, _) =>
                _orders.listorderoffline.isNotEmpty
                    ? _buildordersList(_orders.listorderoffline)
                    : Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
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
                child: Consumer<OrderOfflineData>(
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
                child: Consumer<OrderOfflineData>(
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
                child: Consumer<OrderOfflineData>(
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
  final String _customer_id;
  final String _customer_name;
  final String _qty;
  final String _payment_method_id;
  final String _total_amt;
  final String _order_line_date;
  final List<Orderoffline> _orders;
  final int _index;
  final String _data;

  Items(
    this._id,
    this._customer_id,
    this._customer_name,
    this._qty,
    this._payment_method_id,
    this._total_amt,
    this._order_line_date,
    this._orders,
    this._index,
    this._data,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var formatter = NumberFormat('#,##,##0.#');

  DateFormat dateformatter = DateFormat('dd-MM-yyyy HH:mm:ss');

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
        setState(() {
          // Provider.of<OrderData>(context, listen: false)
          //     .removeOrderDetail(widget._order_line_id);
          // widget._orders.removeAt(widget._index);
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
          setData.idOrder = 1;
          setData.orderCustomerId = widget._customer_id;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderOfflineDetailPage(
                    order_id: widget._id,
                    order_data: widget._data,
                  )));
          // Navigator.of(context)
          //     .pushNamed(OrderOfflineDetailPage.routeName, arguments: {
          //   'order_id': widget._id,
          //   'order_data': widget._data,
          // });
        }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Chip(
                  label: Text('${widget._id} ${sale_type}'),
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
                  "${dateformatter.format(DateTime.parse(widget._order_line_date))}",
                  style: TextStyle(color: Colors.cyan[700]),
                ),
                trailing: Text("${widget._total_amt}")),
            Divider(),
          ],
        ),
      ),
    );
  }
}

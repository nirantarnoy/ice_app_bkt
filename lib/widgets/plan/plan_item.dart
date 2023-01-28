import 'package:flutter/material.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/plan.dart';
import 'package:ice_app_new/pages/plandetail.dart';
//import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/plan.dart';
import 'package:intl/intl.dart';
//import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/plan.dart';
//import '../../pages/orderdetail.dart';

class PlanItem extends StatefulWidget {
  @override
  _PlanItemState createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  List<Plan> _plans = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      // Provider.of<CustomerData>(context, listen: false)
      //     .fetCustomers()
      //     .then((_) {
      //   setState(() {
      //     _isLoading = false;

      //     // print('issue id is ${selectedIssue}');
      //   });
      // });
    }
  }

  Widget _buildplansList(List<Plan> plans) {
    Widget orderCards;
    if (plans.isNotEmpty) {
      if (plans.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            itemCount: plans.length,
            itemBuilder: (BuildContext context, int index) => Items(
                  plans[index].id,
                  plans[index].code,
                  plans[index].customer_id,
                  plans[index].customer_name,
                  plans[index].trans_date,
                  plans,
                  index,
                  plans[index].status,
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
    final PlanData plans = Provider.of<PlanData>(context);
    // plans.fetplans();
    var formatter = NumberFormat('#,##,##0.#');
    return Column(
      children: <Widget>[
        Column(children: <Widget>[
          // Card(
          //   margin: EdgeInsets.all(8),
          //   child: Padding(
          //     padding: EdgeInsets.all(2),
          //     child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Expanded(
          //             child: Consumer<CustomerData>(
          //               builder: (context, _customer, _) => TypeAheadField(
          //                 textFieldConfiguration: TextFieldConfiguration(
          //                   controller: _typeAheadController,
          //                   autofocus: false,
          //                   style: DefaultTextStyle.of(context)
          //                       .style
          //                       .copyWith(fontStyle: FontStyle.normal),
          //                   decoration: InputDecoration(
          //                       border: OutlineInputBorder(),
          //                       hintText: 'ค้นหาลูกค้า'),
          //                 ),
          //                 // suggestionsCallback: (pattern) async {
          //                 //   return await BackendService.getSuggestions(pattern);
          //                 // },
          //                 suggestionsCallback: (pattern) async {
          //                   return await _customer.findCustomer(pattern);
          //                 },
          //                 itemBuilder: (context, suggestion) {
          //                   return ListTile(
          //                     // leading: Icon(Icons.shopping_cart),
          //                     title: Text(suggestion.name),
          //                     // subtitle: Text('\$${suggestion['price']}'),
          //                   );
          //                 },

          //                 onSuggestionSelected: (items) {
          //                   //print(items.id);
          //                   if (_typeAheadController.value == '') {
          //                     print('not selected');
          //                   }
          //                   setState(() {
          //                     selectedValue = items.id;
          //                     plans.searchBycustomer = selectedValue;
          //                     PlanData getneworder =
          //                         Provider.of<PlanData>(context, listen: false);
          //                     getneworder.fetPlan();
          //                     this._typeAheadController.text = items.name;
          //                   });
          //                 },
          //                 noItemsFoundBuilder: (context) {
          //                   return Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: <Widget>[
          //                         Text(
          //                           'ไม่พบข้อมูล',
          //                           style: TextStyle(
          //                               fontSize: 16, color: Colors.red),
          //                         ),
          //                       ],
          //                     ),
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 5,
          //           ),
          //           ElevatedButton(
          //               color: Colors.grey[100],
          //               height: 30,
          //               onPressed: () {
          //                 selectedValue = '';
          //                 plans.searchBycustomer = selectedValue;
          //                 PlanData getneworder =
          //                     Provider.of<PlanData>(context, listen: false);
          //                 getneworder.fetPlan();
          //                 this._typeAheadController.text = '';
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Icon(
          //                   Icons.refresh_rounded,
          //                   size: 45,
          //                   color: Colors.grey[500],
          //                 ),
          //               )),
          //           // FloatingActionButton(
          //           //     backgroundColor: Colors.green[500],
          //           //     onPressed: () => Navigator.of(context)
          //           //         .pushNamed(CreateorderPage.routeName),
          //           //     child: Icon(Icons.add, color: Colors.white)
          //           //     //   ElevatedButton(onPressed: () {}, child: Text("เพิ่มรายการขาย")),
          //           //     ),
          //         ]),
          //   ),
          // ),
        ]),
        SizedBox(height: 5),
        Expanded(
          child: plans.listplan.isNotEmpty
              ? _buildplansList(plans.listplan)
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _plan_no;
  final String _customer_name;
  final String _customer_id;
  final String _trans_date;
  final List<Plan> _plans;
  final int _index;

  final String _plan_line_status;

  Items(
    this._id,
    this._plan_no,
    this._customer_id,
    this._customer_name,
    this._trans_date,
    this._plans,
    this._index,
    this._plan_line_status,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var formatter = NumberFormat('#,##,##0.#');

  DateFormat dateformatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget._plans[widget._index]),
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
        print(widget._plans[widget._index].id);
        setState(() {
          Provider.of<PlanData>(context, listen: false)
              .removePlanCustomer(widget._id, widget._customer_id);
          widget._plans.removeAt(widget._index);
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
          var setData = Provider.of<PlanData>(context, listen: false);
          setData.idPlan = int.parse(widget._id);
          setData.planCustomerId = widget._customer_id;
          Navigator.of(context).pushNamed(PlanDetailPage.routeName, arguments: {
            'customer_id': widget._customer_id,
            'plan_id': widget._id
          });
        }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "${widget._plan_no}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              subtitle: Text(
                "${widget._trans_date}",
                style: TextStyle(color: Colors.cyan[700]),
              ),
              trailing: Column(),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

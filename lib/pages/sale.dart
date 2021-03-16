import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';

import 'package:ice_app_new/models/customers.dart';
import 'package:ice_app_new/widgets/sale/sale_product_item.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  String selectedValue;

  @override
  Widget build(BuildContext context) {
    final CustomerData customers = Provider.of<CustomerData>(context);
    customers.fetCustomers();
    return Scaffold(
      // body: Container(
      body: SaleProductItem(),
      //   padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      //   color: Colors.white,
      //   child: Row(
      //     children: <Widget>[
      //       Expanded(
      //         child: DropdownButtonHideUnderline(
      //           child: Container(
      //             padding: EdgeInsets.only(left: 16, right: 16),
      //             decoration: BoxDecoration(
      //                 border: Border.all(color: Colors.grey, width: 0.1),
      //                 borderRadius: BorderRadius.circular(1)),
      //             child: ButtonTheme(
      //               alignedDropdown: true,
      //               child: DropdownButton(
      //                 value: selectedValue,
      //                 iconSize: 30,
      //                 icon: (null),
      //                 style: TextStyle(color: Colors.black54, fontSize: 16),
      //                 hint: Text(
      //                   'เลือกลูกค้า',
      //                   style: TextStyle(fontFamily: 'kanit'),
      //                 ),
      //                 dropdownColor: Colors.white,
      //                 items: customers.listcustomer
      //                     .map((e) => DropdownMenuItem(
      //                         value: e.id, child: Text(e.name)))
      //                     .toList(),
      //                 onChanged: (String value) {
      //                   setState(() {
      //                     selectedValue = value;
      //                   });
      //                 },
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       //  SaleProductItem()
      //     ],
      //   ),
      // ),
    );
  }
}

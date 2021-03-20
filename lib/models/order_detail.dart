import 'package:flutter/material.dart';

class OrderDetail {
  final String order_id;
  final String order_no;
  final String line_id;
  final String customer_id;
  final String customer_name;
  final String product_id;
  final String producnt_name;
  final String qty;
  final String price;
  final String price_group_id;

  OrderDetail(
      {@required this.order_id,
      @required this.order_no,
      @required this.line_id,
      @required this.customer_id,
      @required this.customer_name,
      @required this.product_id,
      @required this.qty,
      @required this.price,
      @required this.price_group_id,
      @required this.producnt_name});
}

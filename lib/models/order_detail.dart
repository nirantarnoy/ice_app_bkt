import 'package:flutter/material.dart';

class OrderDetail {
  final String order_id;
  final String order_no;
  final String order_date;
  final String line_id;
  final String customer_id;
  final String customer_code;
  final String customer_name;
  final String product_id;
  final String product_code;
  final String product_name;
  final String qty;
  final String price;
  final String price_group_id;
  final String order_line_status;
  final String discount_amount;

  OrderDetail({
    @required this.order_id,
    @required this.order_no,
    @required this.order_date,
    @required this.line_id,
    @required this.customer_id,
    @required this.customer_code,
    @required this.customer_name,
    @required this.product_id,
    @required this.product_code,
    @required this.qty,
    @required this.price,
    @required this.price_group_id,
    @required this.product_name,
    @required this.order_line_status,
    this.discount_amount,
  });
}

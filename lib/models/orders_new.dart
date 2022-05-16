import 'package:flutter/material.dart';

class OrdersNew {
  final String id;
  final String order_no;
  final String customer_id;
  final String customer_code;
  final String customer_name;
  final String order_date;
  final String price;
  final String qty;
  final String payment_method_id;
  final String line_total;
  final String product_id;
  final String product_code;
  final String product_name;
  final String order_line_id;
  final String order_line_date;
  final String order_line_status;
  final String discount_amount;

  OrdersNew({
    @required this.id,
    @required this.order_no,
    @required this.customer_id,
    @required this.customer_code,
    @required this.customer_name,
    @required this.order_date,
    @required this.price,
    @required this.qty,
    @required this.payment_method_id,
    @required this.line_total,
    @required this.product_id,
    @required this.product_code,
    @required this.product_name,
    @required this.order_line_id,
    @required this.order_line_date,
    @required this.order_line_status,
    this.discount_amount,
  });
}

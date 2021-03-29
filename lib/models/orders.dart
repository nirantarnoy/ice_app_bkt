import 'package:flutter/material.dart';

class Orders {
  final String id;
  final String order_no;
  final String customer_id;
  final String customer_code;
  final String customer_name;
  final String order_date;
  final String total_amount;
  final String payment_method_id;
  final String payment_method;
  final String total_qty;

  Orders(
      {@required this.id,
      @required this.order_no,
      @required this.customer_id,
      @required this.customer_code,
      @required this.customer_name,
      @required this.order_date,
      @required this.total_amount,
      @required this.payment_method,
      @required this.payment_method_id,
      this.total_qty});
}

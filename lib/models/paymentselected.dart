import 'package:flutter/material.dart';

class Paymentselected {
  final String order_id;
  final String order_no;
  final String customer_id;
  final String customer_name;
  final String order_date;
  final String order_amount;

  Paymentselected(
    this.order_id,
    this.order_no,
    this.customer_id,
    this.customer_name,
    this.order_date,
    this.order_amount,
  );
}

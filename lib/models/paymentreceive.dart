import 'package:flutter/material.dart';

class Paymentreceive {
  final String order_id;
  final String order_no;
  final String order_date;
  final String customer_id;
  final String customer_code;
  final String line_total;
  final String remain_amount;
  bool value;

  Paymentreceive({
    this.order_id,
    this.order_no,
    this.order_date,
    this.customer_id,
    this.customer_code,
    this.line_total,
    this.remain_amount,
    this.value,
  });
}

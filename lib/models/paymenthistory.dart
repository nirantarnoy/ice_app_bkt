import 'package:flutter/material.dart';

class Paymenthistory {
  final String payment_id;
  final String payment_date;
  final String journal_no;
  final String order_id;
  final String customer_id;
  final String customer_name;
  final String payment_amount;
  final String status;
  final String order_no;
  final String order_date;

  Paymenthistory({
    this.payment_id,
    this.payment_date,
    this.journal_no,
    this.order_id,
    this.customer_id,
    this.customer_name,
    this.payment_amount,
    this.status,
    this.order_no,
    this.order_date,
  });
}

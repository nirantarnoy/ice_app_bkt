import 'package:flutter/material.dart';

class Transferin {
  final String transfer_id;
  final String journal_no;
  final String from_route;
  final String from_order_no;
  final String from_car_no;
  final String qty;
  final String product_id;
  final String product_name;
  final String sale_price;
  final String transfer_status;

  Transferin({
    this.transfer_id,
    this.journal_no,
    this.from_route,
    this.from_order_no,
    this.from_car_no,
    this.qty,
    this.product_id,
    this.product_name,
    this.sale_price,
    this.transfer_status,
  });
}

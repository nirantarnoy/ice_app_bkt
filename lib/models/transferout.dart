import 'package:flutter/material.dart';

class Transferout {
  final String transfer_id;
  final String journal_no;
  final String to_route_id;
  final String to_route_name;
  final String transfer_status;
  final String qty;
  final String product_id;
  final String product_name;
  final String sale_price;

  Transferout({
    this.transfer_id,
    this.journal_no,
    this.to_route_id,
    this.to_route_name,
    this.transfer_status,
    this.qty,
    this.product_id,
    this.product_name,
    this.sale_price,
  });
}

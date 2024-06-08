import 'package:flutter/material.dart';

class Addorder {
  final String customer_id;
  final String customer_name;
  final String product_id;
  final String product_code;
  final String product_name;
  final String car_id;
  final String qty;
  String sale_price;
  final String price_group_id;

  Addorder({
    this.customer_id,
    this.customer_name,
    this.product_id,
    this.product_code,
    this.product_name,
    this.car_id,
    this.qty,
    this.sale_price,
    this.price_group_id,
  });
}

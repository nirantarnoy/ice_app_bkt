import 'package:flutter/material.dart';

class Addorder {
  final String customer_id;
  final String product_id;
  final String car_id;
  final String qty;
  final String sale_price;

  Addorder(
      {this.customer_id,
      this.product_id,
      this.car_id,
      this.qty,
      this.sale_price});
}

import 'package:flutter/material.dart';

class CustomerAsset {
  final String id;
  final String code;
  final String customer_id;
  final String product_id;
  final String name;
  final String photo;
  final String qty;
  final String status;

  CustomerAsset({
    this.id,
    this.code,
    this.customer_id,
    this.product_id,
    this.name,
    this.photo,
    this.qty,
    this.status,
  });
}

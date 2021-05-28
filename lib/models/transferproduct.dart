import 'package:flutter/material.dart';

class TransferProduct {
  final String id;
  final String code;
  final String name;
  String qty;
  final String sale_price;
  final String avl_qty;
  final String issue_ref_id;

  TransferProduct({
    this.id,
    this.code,
    this.name,
    this.qty,
    this.sale_price,
    this.avl_qty,
    this.issue_ref_id,
  });
}

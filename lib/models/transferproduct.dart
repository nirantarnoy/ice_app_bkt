import 'package:flutter/material.dart';

class TransferProduct {
  final String id;
  final String code;
  final String name;
  String qty;
  final String sale_price;

  TransferProduct({this.id, this.code, this.name, this.qty, this.sale_price});
}

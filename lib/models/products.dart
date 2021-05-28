import 'package:flutter/material.dart';

class Products {
  final String id;
  final String code;
  final String name;
  final String sale_price;
  final String image;
  final String issue_id;
  final String onhand;

  Products(
      {@required this.id,
      @required this.code,
      @required this.name,
      @required this.sale_price,
      this.image,
      this.issue_id,
      this.onhand});
}

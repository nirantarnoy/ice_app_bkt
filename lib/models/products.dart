import 'package:flutter/material.dart';

class Products {
  final String id;
  final String code;
  final String name;
  final String sale_price;
  final String image;

  Products(
      {@required this.id,
      @required this.code,
      @required this.name,
      @required this.sale_price,
      this.image});
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tableProduct = 'product';

class ProductFields {
  static final List<String> values = [
    id,
    route_id,
    qty,
    code,
    name,
    createdTime,
    issue_id,
    price_group_id,
  ];

  static final String id = 'id';
  static final String route_id = 'route_id';
  static final String qty = 'qty';
  static final String code = 'code';
  static final String name = 'name';
  static final String createdTime = 'createdTime';
  static final String issue_id = 'issue_id';
  static final String price_group_id = 'price_group_id';
}

class Product {
  final String id;
  final int route_id;
  final String qty;
  final String code;
  final String name;
  final DateTime createdTime;
  final int issue_id;
  final int price_group_id;

  const Product({
    this.id,
    @required this.route_id,
    @required this.qty,
    @required this.code,
    @required this.name,
    @required this.createdTime,
    @required this.issue_id,
    @required this.price_group_id,
  });

  Product copy({
    String id,
    int route_id,
    String qty,
    String code,
    String name,
    DateTime cretedTime,
    int issue_id,
    int price_group_id,
  }) =>
      Product(
          id: this.id,
          route_id: this.route_id,
          qty: this.qty,
          code: this.code,
          name: this.name,
          createdTime: this.createdTime,
          issue_id: this.issue_id,
          price_group_id: this.price_group_id);

  static Product fromJson(Map<String, Object> json) => Product(
        id: json[ProductFields.id] as String,
        qty: json[ProductFields.qty] as String,
        code: json[ProductFields.code] as String,
        name: json[ProductFields.name] as String,
        createdTime: DateTime.parse(json[ProductFields.createdTime] as String),
        route_id: json[ProductFields.route_id] as int,
        issue_id: json[ProductFields.issue_id] as int,
        price_group_id: json[ProductFields.price_group_id] as int,
      );

  Map<String, Object> toJson() => {
        ProductFields.id: id,
        ProductFields.route_id: route_id,
        ProductFields.code: code,
        ProductFields.qty: qty,
        ProductFields.name: name,
        ProductFields.createdTime: createdTime.toIso8601String(),
        ProductFields.issue_id: issue_id,
        ProductFields.issue_id: price_group_id,
      };
}

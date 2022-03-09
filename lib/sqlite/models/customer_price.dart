import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tableCustomerprice = 'customer_price';

class CustomerpriceFields {
  static final List<String> values = [
    id,
    route_id,
    sale_price,
    code,
    name,
    createdTime,
    product_id,
    price_group_id,
    product_name,
  ];

  static final String id = 'id';
  static final String route_id = 'route_id';
  static final String sale_price = 'sale_price';
  static final String code = 'code';
  static final String name = 'name';
  static final String createdTime = 'createdTime';
  static final String product_id = 'product_id';
  static final String price_group_id = 'price_group_id';
  static final String product_name = 'product_name';
}

class CustomerPrice {
  final int id;
  final int route_id;
  final String sale_price;
  final String code;
  final String name;
  final DateTime createdTime;
  final int product_id;
  final int price_group_id;
  final String product_name;

  const CustomerPrice({
    @required this.id,
    this.route_id,
    this.sale_price,
    this.code,
    this.name,
    this.createdTime,
    this.product_id,
    this.price_group_id,
    this.product_name,
  });

  CustomerPrice copy({
    int id,
    int route_id,
    String sale_price,
    String code,
    String name,
    DateTime cretedTime,
    int product_id,
    int price_group_id,
    String product_name,
  }) =>
      CustomerPrice(
          id: this.id,
          route_id: this.route_id,
          sale_price: this.sale_price,
          code: this.code,
          name: this.name,
          createdTime: this.createdTime,
          product_id: this.product_id,
          price_group_id: this.price_group_id,
          product_name: this.product_name);

  static CustomerPrice fromJson(Map<String, Object> json) => CustomerPrice(
        id: json[CustomerpriceFields.id] as int,
        sale_price: json[CustomerpriceFields.sale_price] as String,
        code: json[CustomerpriceFields.code] as String,
        name: json[CustomerpriceFields.name] as String,
        createdTime:
            DateTime.parse(json[CustomerpriceFields.createdTime] as String),
        route_id: json[CustomerpriceFields.route_id] as int,
        product_id: json[CustomerpriceFields.product_id] as int,
        price_group_id: json[CustomerpriceFields.price_group_id] as int,
        product_name: json[CustomerpriceFields.product_name] as String,
      );

  Map<String, Object> toJson() => {
        CustomerpriceFields.id: id,
        CustomerpriceFields.route_id: route_id,
        CustomerpriceFields.code: code,
        CustomerpriceFields.sale_price: sale_price,
        CustomerpriceFields.name: name,
        CustomerpriceFields.createdTime: createdTime.toIso8601String(),
        CustomerpriceFields.product_id: product_id,
        CustomerpriceFields.price_group_id: price_group_id,
        CustomerpriceFields.product_name: product_name,
      };

  static CustomerPrice fromJsonDropdown(Map<String, Object> json) =>
      CustomerPrice(
        id: json[CustomerpriceFields.id] as int,
        code: json[CustomerpriceFields.code] as String,
        name: json[CustomerpriceFields.name] as String,
      );
}

class CustomerProductPrice {
  final String id;
  final String code;
  final String name;
  final String sale_price;
  final String image;
  final String issue_id;
  final String onhand;
  final String price_group_id;
  final String product_name;

  const CustomerProductPrice({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.sale_price,
    this.image,
    this.issue_id,
    this.onhand,
    this.price_group_id,
    this.product_name,
  });

  static CustomerProductPrice fromJson(Map<String, Object> json) =>
      CustomerProductPrice(
        id: json['product_id'].toString(),
        code: json[CustomerpriceFields.code] as String,
        name: json[CustomerpriceFields.name] as String,
        sale_price: json[CustomerpriceFields.sale_price] as String,
        image: null,
        issue_id: json['issue_id'].toString(),
        onhand: json['qty'] as String,
        price_group_id: json[CustomerpriceFields.price_group_id] as String,
        product_name: json[CustomerpriceFields.product_name] as String,
      );

  Map<String, Object> toJson() => {
        CustomerpriceFields.id: id,
        CustomerpriceFields.code: code,
        CustomerpriceFields.name: name,
        CustomerpriceFields.sale_price: sale_price,
        'image': image,
        'issue_id': issue_id,
        'qty': onhand,
        CustomerpriceFields.price_group_id: price_group_id,
        CustomerpriceFields.product_name: product_name,
      };
}

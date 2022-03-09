import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tableOrder = 'order';

class OrderFields {
  static final List<String> values = [
    id,
    product_id,
    customer_id,
    qty,
    price,
    price_group_id,
    createdTime,
    issue_id,
    route_id,
    car_id,
    user_id,
    company_id,
    branch_id,
    sync_status,
  ];

  static final String id = 'id';
  static final String product_id = 'product_id';
  static final String customer_id = 'customer_id';
  static final String qty = 'qty';
  static final String price = 'price';
  static final String price_group_id = 'price_group_id';
  static final String createdTime = 'createdTime';
  static final String issue_id = 'issue_id';
  static final String route_id = 'route_id';
  static final String car_id = 'car_id';
  static final String user_id = 'user_id';
  static final String company_id = 'company_id';
  static final String branch_id = 'branch_id';
  static final String sync_status = 'sync_status';
}

class Order {
  final int id;
  final int product_id;
  final int customer_id;
  final double qty;
  final double price;
  final int price_group_id;
  final DateTime createdTime;
  final int issue_id;
  final int route_id;
  final int car_id;
  final int user_id;
  final int company_id;
  final int branch_id;

  const Order({
    @required this.id,
    @required this.product_id,
    @required this.customer_id,
    @required this.qty,
    @required this.price,
    @required this.price_group_id,
    @required this.createdTime,
    @required this.issue_id,
    @required this.route_id,
    @required this.car_id,
    @required this.user_id,
    @required this.company_id,
    @required this.branch_id,
  });

  Order copy({
    int id,
    int product_id,
    int customer_id,
    int qty,
    String price,
    int price_group_id,
    DateTime cretedTime,
    int issue_id,
    int route_id,
    int car_id,
    int user_id,
    int company_id,
    int branch_id,
  }) =>
      Order(
        id: this.id,
        product_id: this.product_id,
        customer_id: this.customer_id,
        qty: this.qty,
        price: this.price,
        price_group_id: this.price_group_id,
        createdTime: this.createdTime,
        issue_id: this.issue_id,
        route_id: this.route_id,
        car_id: this.car_id,
        user_id: this.user_id,
        company_id: this.company_id,
        branch_id: this.branch_id,
      );

  static Order fromJson(Map<String, Object> json) => Order(
        id: json[OrderFields.id] as int,
        product_id: json[OrderFields.product_id] as int,
        qty: json[OrderFields.qty] as double,
        price: json[OrderFields.price] as double,
        price_group_id: json[OrderFields.price_group_id] as int,
        createdTime: DateTime.parse(json[OrderFields.createdTime] as String),
        customer_id: json[OrderFields.customer_id] as int,
        issue_id: json[OrderFields.issue_id] as int,
        route_id: json[OrderFields.route_id] as int,
        car_id: json[OrderFields.car_id] as int,
        user_id: json[OrderFields.user_id] as int,
        company_id: json[OrderFields.company_id] as int,
        branch_id: json[OrderFields.branch_id] as int,
      );

  Map<String, Object> toJson() => {
        OrderFields.id: id,
        OrderFields.product_id: product_id,
        OrderFields.customer_id: customer_id,
        OrderFields.price: price,
        OrderFields.qty: qty,
        OrderFields.price_group_id: price_group_id,
        OrderFields.createdTime: createdTime.toIso8601String(),
        OrderFields.issue_id: issue_id,
        OrderFields.route_id: route_id,
        OrderFields.car_id: car_id,
        OrderFields.user_id: user_id,
        OrderFields.company_id: company_id,
        OrderFields.branch_id: branch_id,
      };
}

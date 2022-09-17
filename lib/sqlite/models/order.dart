import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tableOrder = 'orderoffline';

class OrderFields {
  static final List<String> values = [
    id,
    payment_type_id,
    order_date,
    customer_id,
    user_id,
    route_id,
    car_id,
    company_id,
    branch_id,
    data,
    discount,
    sync_status,
    customer_name,
    total_amt,
  ];

  static final String id = 'id';
  static final String payment_type_id = 'payment_type_id';
  static final String order_date = 'order_date';
  static final String customer_id = 'customer_id';
  static final String user_id = 'user_id';
  static final String route_id = 'route_id';
  static final String car_id = 'car_id';
  static final String company_id = 'company_id';
  static final String branch_id = 'branch_id';
  static final String data = 'data';
  static final String discount = 'discount';
  static final String sync_status = 'sync_status';
  static final String customer_name = 'customer_name';
  static final String total_amt = 'total_amt';
}

class Order {
  final int id;
  final String payment_type_id;
  final DateTime order_date;
  final String customer_id;
  final String user_id;
  final String route_id;
  final String car_id;
  final String company_id;
  final String branch_id;
  final String data;
  final String discount;
  final String sync_status;
  final String customer_name;
  final String total_amt;

  const Order({
    @required this.id,
    @required this.payment_type_id,
    @required this.order_date,
    @required this.customer_id,
    @required this.user_id,
    @required this.route_id,
    @required this.car_id,
    @required this.company_id,
    @required this.branch_id,
    @required this.data,
    @required this.discount,
    @required this.sync_status,
    @required this.customer_name,
    @required this.total_amt,
  });

//   Order copy({
//     int id,
//     int product_id,
//     int customer_id,
//     int qty,
//     String price,
//     int price_group_id,
//     DateTime cretedTime,
//     int issue_id,
//     int route_id,
//     int car_id,
//     int user_id,
//     int company_id,
//     int branch_id,
//   }) =>
//       Order(
//         id: this.id,
//         product_id: this.product_id,
//         customer_id: this.customer_id,
//         qty: this.qty,
//         price: this.price,
//         price_group_id: this.price_group_id,
//         createdTime: this.createdTime,
//         issue_id: this.issue_id,
//         route_id: this.route_id,
//         car_id: this.car_id,
//         user_id: this.user_id,
//         company_id: this.company_id,
//         branch_id: this.branch_id,
//       );

  static Order fromJson(Map<String, Object> json) => Order(
        id: json[OrderFields.id] as int,
        payment_type_id: json[OrderFields.payment_type_id],
        order_date: DateTime.parse(json[OrderFields.order_date]),
        customer_id: json[OrderFields.customer_id],
        user_id: json[OrderFields.user_id],
        route_id: json[OrderFields.route_id],
        car_id: json[OrderFields.customer_id],
        company_id: json[OrderFields.company_id],
        branch_id: json[OrderFields.branch_id],
        data: json[OrderFields.data],
        discount: json[OrderFields.discount],
        sync_status: json[OrderFields.sync_status],
        customer_name: json[OrderFields.customer_name],
        total_amt: json[OrderFields.total_amt],
      );

  Map<String, Object> toJson() => {
        OrderFields.id: id,
        OrderFields.payment_type_id: payment_type_id,
        OrderFields.order_date: order_date.toIso8601String(),
        OrderFields.customer_id: customer_id,
        OrderFields.user_id: user_id,
        OrderFields.route_id: route_id,
        OrderFields.car_id: car_id,
        OrderFields.company_id: company_id,
        OrderFields.branch_id: branch_id,
        OrderFields.data: data,
        OrderFields.discount: discount,
        OrderFields.sync_status: sync_status,
        OrderFields.customer_name: customer_name,
        OrderFields.total_amt: total_amt,
      };
}

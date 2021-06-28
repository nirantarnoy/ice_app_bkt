import 'package:flutter/material.dart';

class Plan {
  final String id;
  final String code;
  final String trans_date;
  final String customer_id;
  final String customer_name;
  final String route_id;
  final String route_name;
  final String car_id;
  final String car_name;
  final String status;

  Plan({
    this.id,
    this.code,
    this.trans_date,
    this.customer_id,
    this.customer_name,
    this.route_id,
    this.route_name,
    this.car_id,
    this.car_name,
    this.status,
  });
}

import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String emp_code;
  final String emp_name;
  final String emp_photo;
  final String emp_route_id;
  final String emp_route_name;
  final String emp_car_id;
  final String emp_car_name;
  final String company_id;
  final String branch_id;
  final String route_type;

  User({
    @required this.id,
    @required this.username,
    @required this.emp_code,
    @required this.emp_name,
    @required this.emp_photo,
    @required this.emp_route_id,
    @required this.emp_route_name,
    @required this.emp_car_id,
    @required this.emp_car_name,
    @required this.company_id,
    @required this.branch_id,
    @required this.route_type,
  });
}

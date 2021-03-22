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

  User(
      {@required this.id,
      @required this.username,
      @required this.emp_code,
      @required this.emp_name,
      @required this.emp_photo,
      @required this.emp_route_id,
      @required this.emp_route_name,
      @required this.emp_car_id,
      @required this.emp_car_name});
}

import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String emp_code;
  final String emp_name;
  final String emp_photo;

  User(
      {@required this.id,
      @required this.username,
      @required this.emp_code,
      @required this.emp_name,
      @required this.emp_photo});
}

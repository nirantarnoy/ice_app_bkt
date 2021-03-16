import 'package:flutter/material.dart';

class Customers {
  final String id;
  final String code;
  final String name;
  final String route_id;
  final String route_name;

  Customers({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.route_id,
    @required this.route_name,
  });
}

import 'package:flutter/material.dart';

class Orders {
  final int id;
  final String order_no;
  final String customer_name;
  final String order_date;
  final String note;

  Orders({
    @required this.id,
    @required this.order_no,
    @required this.customer_name,
    @required this.order_date,
    @required this.note,
  });
}

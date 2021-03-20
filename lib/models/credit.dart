import 'package:flutter/material.dart';

class Credit {
  final String id;
  final String trans_date;
  final String customer_name;
  final String customer_id;
  final String total_amount;

  Credit(
      {@required this.id,
      @required this.trans_date,
      @required this.customer_name,
      @required this.customer_id,
      @required this.total_amount});
}

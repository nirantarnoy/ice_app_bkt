import 'package:flutter/material.dart';

class Transferout {
  final String transfer_id;
  final String journal_no;
  final String to_route;
  final String to_order_no;
  final String to_car_no;

  Transferout(
      {this.transfer_id,
      this.journal_no,
      this.to_route,
      this.to_order_no,
      this.to_car_no});
}

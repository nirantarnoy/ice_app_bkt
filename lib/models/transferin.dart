import 'package:flutter/material.dart';

class Transferin {
  final String transfer_id;
  final String journal_no;
  final String from_route;
  final String from_order_no;
  final String from_car_no;

  Transferin(
      {this.transfer_id,
      this.journal_no,
      this.from_route,
      this.from_order_no,
      this.from_car_no});
}

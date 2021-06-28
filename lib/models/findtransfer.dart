import 'package:flutter/material.dart';

class FindTransfer {
  final String id;
  final String journal_no;
  final String trans_date;
  final String from_route_id;
  final String from_route_name;
  final String transfer_status;

  FindTransfer({
    this.id,
    this.journal_no,
    this.trans_date,
    this.from_route_id,
    this.from_route_name,
    this.transfer_status,
  });
}

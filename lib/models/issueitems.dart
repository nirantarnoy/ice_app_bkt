import 'package:flutter/material.dart';

class Issueitems {
  final String line_issue_id;
  final String issue_id;
  final String product_id;
  final String product_name;
  final String issue_no;
  final String qty;
  final String price;
  final String product_image;

  Issueitems(
      {@required this.line_issue_id,
      @required this.issue_id,
      @required this.product_id,
      @required this.product_name,
      @required this.issue_no,
      @required this.qty,
      @required this.price,
      this.product_image});
}

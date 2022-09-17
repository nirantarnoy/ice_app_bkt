class Orderoffline {
  final String id;
  final String customer_id;
  final String customer_name;
  final String qty;
  final String total_amt;
  final String payment_method_id;
  final String order_line_status;
  final String line_total;
  final String order_date;
  final String data;
  final String discount_amount;

  Orderoffline({
    this.id,
    this.customer_id,
    this.customer_name,
    this.qty,
    this.total_amt,
    this.payment_method_id,
    this.order_line_status,
    this.line_total,
    this.order_date,
    this.data,
    this.discount_amount,
  });
}

class Orderofflinedetail {
  final String order_id;
  final String product_id;
  final String qty;
  final String price;
  final String price_group_id;
  final String product_code;
  final String product_name;
  final String order_line_status;
  final String discount_amount;

  Orderofflinedetail({
    this.order_id,
    this.product_id,
    this.qty,
    this.price,
    this.price_group_id,
    this.product_code,
    this.product_name,
    this.order_line_status,
    this.discount_amount,
  });

  Orderofflinedetail.fromJson(Map<String, dynamic> json)
      : order_id = json['order_id'],
        product_id = json['product_id'],
        qty = json['qty'],
        price = json['price'],
        price_group_id = json['price_group_id'],
        product_code = json['product_code'],
        product_name = json['product_name'],
        order_line_status = json['order_line_status'],
        discount_amount = json['discount_amount'];
}

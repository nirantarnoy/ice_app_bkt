import 'package:flutter/material.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/products.dart';

class ProductItem extends StatelessWidget {
  List<Products> _orders = [];
  Widget _buildproductList(List<Products> products) {
    Widget productCards;
    if (products.length > 0) {
      print("has list");
      productCards = new ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
              products[index].id.toString(),
              products[index].code,
              products[index].name,
              products[index].sale_price.toString(),
              products[index].image);
        },
      );
      return productCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductData products = Provider.of<ProductData>(context);
    products.fetProducts();
    return _buildproductList(products.listproduct);
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _id;
  final String _code;
  final String _name;
  final String _sale_price;
  final String _image;

  Items(this._id, this._code, this._name, this._sale_price, this._image);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
      child: Card(
          child: ListTile(
        leading: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100, minWidth: 100),
          child: FadeInImage.assetNetwork(
            width: 100,
            height: 100,
            placeholder: '',
            image: "$_image",
          ),
        ),
        title: Text(
          "$_name",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text("ราคาขาย $_sale_price บาท"),
        trailing: Text('100',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800])),
      )),
    );
  }
}

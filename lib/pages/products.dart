import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ice_app/widgets/product/product_item.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatefulWidget {
  final MainModel model;

  ProductPage(this.model);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
            child: Text(
          'ไม่พบข้อมูล!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
        ));
        print("data length = " + model.displayedProducts.length.toString());
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = ProductItem();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   'ตรวจสอบผลการเรียน',
      //   style: TextStyle(fontWeight: FontWeight.bold),
      // )),
      body: _buildProductsList(),
    );
  }
}

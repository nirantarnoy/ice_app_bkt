import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/delivery_route.dart';

class RoutesItem extends StatelessWidget {
  List<DeliveryRoutes> _routes = [];
  Widget _buildproductList(List<DeliveryRoutes> routes) {
    Widget routeCards;
    if (routes.length > 0) {
      print("has list");
      routeCards = new ListView.builder(
        itemCount: routes.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
              routes[index].id, routes[index].name, routes[index].code);
        },
      );
      return routeCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[product Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildproductList(model.allRoutes);
      },
    );
  }
}

class Items extends StatelessWidget {
  //product _product;
  final int _id;
  final String _name;
  final String _code;

  Items(this._id, this._name, this._code);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/productdetail/' + this._id.toString()),
      child: Card(
          child: ListTile(
        leading: Icon(
          Icons.map,
          color: Colors.blueAccent,
          size: 50.0,
        ),
        title: Text(
          "$_code $_name",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      )),
    );
  }
}

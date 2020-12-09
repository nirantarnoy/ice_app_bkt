import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ice_app/widgets/delivery_route/delivery_route_item.dart';
import '../scoped-models/main.dart';

class DeliveryRoutePage extends StatefulWidget {
  final MainModel model;

  DeliveryRoutePage(this.model);
  @override
  _DeliveryRoutePageState createState() => _DeliveryRoutePageState();
}

class _DeliveryRoutePageState extends State<DeliveryRoutePage> {
  @override
  initState() {
    widget.model.fetchRoutes();
    super.initState();
  }

  Widget _buildRoutesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
            child: Text(
          'ไม่พบข้อมูล!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
        ));
        print("data length = " + model.displayedRoutes.length.toString());
        if (model.displayedRoutes.length > 0 && !model.is_route_load) {
          content = RoutesItem();
        } else if (model.is_route_load) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchRoutes,
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
      body: _buildRoutesList(),
    );
  }
}

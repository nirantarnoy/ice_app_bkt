import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/orders.dart';

class OrderItem extends StatelessWidget {
  List<Orders> _orders = [];
  Widget _buildordersList(List<Orders> orders) {
    Widget orderCards;
    if (orders.length > 0) {
      print("has list");
      //   orderCards = ListView.builder(
      //     itemBuilder: (BuildContext context, int index) {

      //         return SingleItem(orders[index]);

      //     },
      //     itemCount: orders.length,
      //   );
      // } else {
      //   print('no list');
      //   orderCards = Container(
      //     child: Text('No'),
      //   );
      // }
      orderCards = new ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
              orders[index].id,
              orders[index].order_no,
              orders[index].customer_name,
              orders[index].order_date,
              orders[index].note);
        },
      );
      return orderCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[orders Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildordersList(model.allorders);
      },
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final int _id;
  final String _order_no;
  final String _customer_name;
  final String _order_date;
  final String _note;

  Items(this._id, this._order_no, this._customer_name, this._order_date,
      this._note);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
      child: Card(
          child: ListTile(
        leading: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.blueAccent,
          size: 50.0,
        ),
        title: Text(
          "$_order_no $_note",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Text("$_order_date ($_customer_name)"),
      )),
    );
  }
}

// class SingleItem extends StatelessWidget {
//   orders orders;
//   // final int roomIndex;

//   SingleItem(this.orders);
//   @override
//   Widget build(BuildContext context) {
//     return new GestureDetector(
//       onTap: () =>
//           Navigator.pushNamed<bool>(context, '/roomdetail/' + orders.id),
//       child: Card(
//         child: Column(
//           children: <Widget>[
//             // Padding(
//             //   padding: EdgeInsets.all(2.0),
//             //   child: Image.asset('assets/background.jpg'),
//             //   //     child: Image.asset('assets/' + room.image),
//             // ),
//             // new Row(
//             //   children: <Widget>[
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         orders.subject_code,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         orders.max_score,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         orders.score,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         orders.grade,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // new Row(children: <Widget>[
//             //   Padding(
//             //           padding: EdgeInsets.all(8.0),
//             //           child: Text(
//             //             'ราคาเช่า',
//             //             style: TextStyle(
//             //               fontFamily: 'Cloud-Light',
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //         ),
//             //         Padding(
//             //           padding: EdgeInsets.fromLTRB(8.9, 2, 2, 2),
//             //           child: Text(
//             //             room.price.toString() + ' THB',
//             //             style: TextStyle(
//             //               fontFamily: 'Cloud-Light',
//             //               color: Colors.red,
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //         ),
//             // ],),
//             // new Row(
//             //   children: <Widget>[
//             //     Wrap(
//             //       direction: Axis.horizontal,
//             //       spacing: 90.0,
//             //       runSpacing: 4.0,
//             //       children: <Widget>[
//             //         Padding(
//             //           padding: EdgeInsets.all(8.0),
//             //           child: Text(
//             //             'ราคาเช่า',
//             //             style: TextStyle(
//             //               fontFamily: 'Cloud-Light',
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //         ),
//             //         Padding(
//             //           padding: EdgeInsets.fromLTRB(8.9, 2, 2, 2),
//             //           child: Text(
//             //             room.price.toString() + ' THB',
//             //             style: TextStyle(
//             //               fontFamily: 'Cloud-Light',
//             //               color: Colors.red,
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //         ),
//             //         Padding(
//             //           padding: EdgeInsets.fromLTRB(10, 0, 3.0, 0),
//             //           child: Icon(
//             //             Icons.favorite_border,
//             //             size: 18.0,
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ],
//             // ),
//             // new Row(
//             //   children: <Widget>[
//             //     Padding(
//             //         padding: EdgeInsets.fromLTRB(8.9, 2, 2, 2),
//             //         child: Text(
//             //           'สถานะ',
//             //           style: TextStyle(fontFamily: 'Cloud-Light',fontWeight: FontWeight.bold,),
//             //         )),
//             //     Padding(
//             //       padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
//             //       child: Text('มีคนเช่า',
//             //           style: TextStyle(
//             //             fontFamily: 'Cloud-Light',
//             //           )),
//             //     ),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//}

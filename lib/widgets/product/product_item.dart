import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/products.dart';

class ProductItem extends StatelessWidget {
  List<Products> _products = [];
  Widget _buildproductList(List<Products> product) {
    Widget productCards;
    if (product.length > 0) {
      print("has list");
      //   productCards = ListView.builder(
      //     itemBuilder: (BuildContext context, int index) {

      //         return SingleItem(product[index]);

      //     },
      //     itemCount: product.length,
      //   );
      // } else {
      //   print('no list');
      //   productCards = Container(
      //     child: Text('No'),
      //   );
      // }
      productCards = new ListView.builder(
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return Items(
              product[index].id, product[index].name, product[index].code);
        },
      );
      return productCards;
    } else {
      print("no data");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[product Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildproductList(model.allProducts);
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
      )
          // child: Column(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Icon(
          //         Icons.explore,
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         'ปีการศีกษา $_name',
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.orangeAccent),
          //       ),
          //     ),
          //     // Padding(
          //     //   padding: const EdgeInsets.all(8.0),
          //     //   child: Container(
          //     //     alignment: Alignment(1, 0),
          //     //     child: Text(
          //     //       '--$_name',
          //     //       style: TextStyle(fontStyle: FontStyle.italic),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
          ),
    );
  }
}

// class SingleItem extends StatelessWidget {
//   product product;
//   // final int roomIndex;

//   SingleItem(this.product);
//   @override
//   Widget build(BuildContext context) {
//     return new GestureDetector(
//       onTap: () =>
//           Navigator.pushNamed<bool>(context, '/roomdetail/' + product.id),
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
//             //         product.subject_code,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         product.max_score,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         product.score,
//             //         style: TextStyle(
//             //           fontFamily: 'Cloud-Light',
//             //           fontWeight: FontWeight.bold,
//             //         ),
//             //       ),
//             //     ),
//             //     Padding(
//             //       padding: EdgeInsets.all(8.0),
//             //       child: Text(
//             //         product.grade,
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

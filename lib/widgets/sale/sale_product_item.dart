import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:ice_app_new/providers/product.dart';
import 'package:ice_app_new/models/products.dart';

class SaleProductItem extends StatelessWidget {
  List<Products> _products = [];
  Widget _buildproductList(List<Products> products) {
    Widget productCards;
    if (products.length > 0) {
      print("has product item list");
      productCards = new GridView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          //   physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 1),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Items(
              products[index].id,
              products[index].code,
              products[index].name,
            );
          });
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
  //orders _products;
  final String _id;
  final String _code;
  final String _name;

  Items(this._id, this._code, this._name);

  void _editBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text("สินค้าที่เลือก"),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red, size: 25),
                          onPressed: () => Navigator.of(context).pop())
                    ],
                  ),
                  Center(
                    child: Row(children: <Widget>[
                      Text(
                        "${_name}",
                        style:
                            TextStyle(color: Colors.green[900], fontSize: 20),
                      )
                    ]),
                  ),
                  SizedBox(height: 20),
                  // Row(
                  //   children: <Widget>[
                  //     NumberPicker(
                  //       value: _currentValue,
                  //       minValue: 0,
                  //       maxValue: 100,
                  //       onChanged: (value) =>
                  //           setState(() => _currentValue = value),
                  //     ),
                  //   ],
                  // ),
                  Row(children: <Widget>[
                    Padding(padding: EdgeInsets.all(2.0)),
                    Expanded(
                        child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                          fontSize: 40, color: Colors.deepPurple[400]),
                    )),
                  ]),
                  SizedBox(height: 10),
                  // Row(children: <Widget>[
                  //   Padding(padding: EdgeInsets.all(5.0)),
                  //   Expanded(
                  //       child: ),
                  // ]),
                  // Expanded(
                  //     flex: 2,
                  //     child: Row(
                  //       children: [
                  //         //  CustomerDropdown(),
                  //         // Expanded(
                  //         //     flex: 3,
                  //         //     child: Container(
                  //         //       padding: EdgeInsets.symmetric(
                  //         //           horizontal: 15, vertical: 10),
                  //         //       decoration: BoxDecoration(
                  //         //           borderRadius: BorderRadius.circular(10),
                  //         //           color: Colors.grey.withOpacity(.10)),
                  //         //       child: TextField(
                  //         //         style: TextStyle(color: Colors.white),
                  //         //         decoration: InputDecoration(
                  //         //             border: InputBorder.none,
                  //         //             hintText: "เลือกรายการลูกค้า",
                  //         //             hintStyle: TextStyle(color: Colors.grey)),
                  //         //       ),
                  //         //     )),
                  //         Expanded(
                  //             flex: 1,
                  //             child: Container(
                  //                 padding: EdgeInsets.all(2),
                  //                 alignment: Alignment.center,
                  //                 // color: Colors.amber,
                  //                 child: MaterialButton(
                  //                   padding: EdgeInsets.all(2),
                  //                   color: Colors.orange,
                  //                   shape: RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(100)),
                  //                   child: Align(
                  //                     child: Text(
                  //                       'ค้นหา',
                  //                       style: TextStyle(
                  //                           color: Colors.white, fontSize: 20),
                  //                     ),
                  //                   ),
                  //                   onPressed: () => showSearch(
                  //                       context: context,
                  //                       delegate: CustomerSearch()),
                  //                 ))),
                  //       ],
                  //     )
                  //     ),
                  SizedBox(height: 90),
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  //color: Colors.green[500],
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Align(
                                      child: Text(
                                        'เงินสด',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  // color: Colors.amber,
                                  child: MaterialButton(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Align(
                                      child: Text(
                                        'เงินเชื่อ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    onPressed: () => {},
                                  ))),
                        ],
                      ))

                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       MaterialButton(
                  //         padding: EdgeInsets.all(20),
                  //         color: Colors.blue,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: Align(
                  //           child: Text(
                  //             'ซื้อเงินสด',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //         onPressed: () => {},
                  //       )
                  //     ]),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // child: Card(
        //     color: Colors.blueGrey,
        //     child: ListTile(
        //       // leading: Icon(
        //       //   Icons.shopping_cart_outlined,
        //       //   color: Colors.blueAccent,
        //       //   size: 50.0,
        //       // ),
        //       leading: Text(
        //         "$_code",
        //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        //       ),
        //       title: Text(
        //         "$_name",
        //         style: TextStyle(
        //           fontSize: 20,
        //         ),
        //       ),
        //       subtitle: Text("xx"),
        //     )),
        child: Card(
      child: Hero(
        tag: "$_id",
        child: Material(
          child: InkWell(
            onTap: () => _editBottomSheet(context),
            child: Wrap(
              children: [
                Column(
                  children: [
                    Image.asset("assets/ice_cube.png"),
                    Center(
                      child: Text("$_name"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
    // return new GestureDetector(
    //   onTap: () =>
    //       Navigator.pushNamed(context, '/ordersdetail/' + this._id.toString()),
    //   child: Card(
    //       child: ListTile(
    //     leading: Icon(
    //       Icons.shopping_cart_outlined,
    //       color: Colors.blueAccent,
    //       size: 50.0,
    //     ),
    //     title: Text(
    //       "$_order_no $_note",
    //       style: TextStyle(
    //         fontSize: 16,
    //       ),
    //     ),
    //     subtitle: Text("$_order_date ($_customer_name)"),
    //   )),
    // );
  }
}

class CustomerSearch extends SearchDelegate<Products> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(icon: Icon(Icons.arrow_back), onPressed: () {});
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

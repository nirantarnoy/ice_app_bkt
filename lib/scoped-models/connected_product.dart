import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/products.dart';

mixin ConnectedProductsModel on Model {
  String _selProductId;
  List<Products> _products = [];
  Products _dataProducts;
  bool _isLoading = false;
  // final url = "http://192.168.1.103/school/backend/web/index.php?r=site/apilogin";http://localhost/testapi/login.php
  //final url_products = "http://192.168.1.103/school/frontend/web/api/user/exam";
  // final url_products = "http://192.168.1.103/school/frontend/web/api/user/news";
  final url_product =
      "http://192.168.1.101/icesystem/backend/web/index.php?r=member/get-products";
}

mixin ProductsModel on ConnectedProductsModel {
  Products get products {
    return _dataProducts;
  }

  List<Products> get allProducts {
    return List.from(_products);
  }

  List<Products> get displayedProducts {
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Products products) {
      return products.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Products get selectedProducts {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Products products) {
      return products.id == _selProductId;
    });
  }

  bool get is_product_load {
    return _isLoading;
  }

  Future<Null> fetchProducts({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> currStudent = {'student_id': "1"};

    http.Response response;
    if (1 > 0) {
      response = await http.post(
        Uri.encodeFull(url_product),
        body: json.encode(currStudent),
        headers: {'Content-Type': 'application/json'},
      );
    }
    print("api product status: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("api product status: ${response.body}");

      final List<Products> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      print("data product item: ${productListData['data'][0]}");
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      for (int i = 0; i <= productListData['data'].length - 1; i++) {
        //print(newstListData['data'][i]['subject_code']);
        final Products productresult = Products(
          id: productListData['data'][i]['id'],
          code: productListData['data'][i]['code'],
          name: productListData['data'][i]['name'],
        );
        fetchedProductList.add(productresult);
      }
      // newstListData['data'][0].forEach((String id, dynamic examData) {
      // print(examData);
      // final Examresult examresult = Examresult(
      //     id: '1',
      //     subject_code: examData[i]['subject_code'],
      //     subject_name: examData[i]['subject_name'],
      //     score: examData[i]['score'],
      //     grade: examData[i]['grade'],
      //     max_score: '100');
      //     i+=1;
      // fetchedNewsList.add(examresult);
      //});
      _products = fetchedProductList;
      print(_products.length);
      _isLoading = false;
      notifyListeners();
    }

    // return http.post(Uri.encodeFull(urls),body: json.encode(currStudent), headers: {'Content-Type': 'application/json'}).then<Null>((http.Response response) {
    //   print(response.statusCode);

    // }).catchError((error) {
    //   print(error);
    //   _isLoading = false;
    //   notifyListeners();
    //   return;
    // });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }
}

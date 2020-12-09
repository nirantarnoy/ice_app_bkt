import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ice_app/models/delivery_route.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/delivery_route.dart';

mixin ConnectedDeliveryRouteModel on Model {
  String _selRouteId;
  List<DeliveryRoutes> _routes = [];
  DeliveryRoutes _dataRoutes;
  bool _isLoading = false;
  // final url = "http://192.168.1.103/school/backend/web/index.php?r=site/apilogin";http://localhost/testapi/login.php
  //final url_routes = "http://192.168.1.103/school/frontend/web/api/user/exam";
  // final url_routes = "http://192.168.1.103/school/frontend/web/api/user/news";
  final url_routes =
      "http://192.168.1.101/icesystem/backend/web/index.php?r=member/get-route";
}

mixin DeliveryRouteModel on ConnectedDeliveryRouteModel {
  PublishSubject<bool> _routesubject = PublishSubject();
  PublishSubject<bool> _profileSubject = PublishSubject();

  DeliveryRoutes get routes {
    return _dataRoutes;
  }

  List<DeliveryRoutes> get allRoutes {
    return List.from(_routes);
  }

  List<DeliveryRoutes> get displayedRoutes {
    return List.from(_routes);
  }

  int get selectedRouteIndex {
    return _routes.indexWhere((DeliveryRoutes routes) {
      return routes.id == _selRouteId;
    });
  }

  String get selectedRouteId {
    return _selRouteId;
  }

  DeliveryRoutes get selectedRoutes {
    if (selectedRouteId == null) {
      return null;
    }

    return _routes.firstWhere((DeliveryRoutes routes) {
      return routes.id == _selRouteId;
    });
  }

  bool get is_route_load {
    return _isLoading;
  }

  // PublishSubject<bool> get newsRoute {
  //   return _routesubject;
  // }

  Future<Null> fetchRoutes({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> currStudent = {'student_id': "1"};

    http.Response response;
    if (1 > 0) {
      response = await http.post(
        Uri.encodeFull(url_routes),
        body: json.encode(currStudent),
        headers: {'Content-Type': 'application/json'},
      );
    }
    print("api status: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("api status: ${response.body}");

      final List<DeliveryRoutes> fetchedRouteList = [];
      final Map<String, dynamic> routeListData = json.decode(response.body);
      print("data news: ${routeListData['data'][0]}");
      if (routeListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      for (int i = 0; i <= routeListData['data'].length - 1; i++) {
        //print(newstListData['data'][i]['subject_code']);
        final DeliveryRoutes routeresult = DeliveryRoutes(
          id: routeListData['data'][i]['id'],
          code: routeListData['data'][i]['code'],
          name: routeListData['data'][i]['name'],
        );
        fetchedRouteList.add(routeresult);
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
      _routes = fetchedRouteList;
      print(_routes.length);
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

  void selectRoute(String routeId) {
    _selRouteId = routeId;
    notifyListeners();
  }
}

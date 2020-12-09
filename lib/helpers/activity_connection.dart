import 'package:connectivity/connectivity.dart';

class ActivitityConnection {
  var result;
  ActivitityConnection({this.result});

  Future<void> _checkinternet() async {
    this.result = await Connectivity().checkConnectivity();
  }
}

import 'package:flutter/widgets.dart';

class CheckBoxState {
  final String title;
  bool value;

  CheckBoxState({
    @required this.title,
    this.value = false,
  });
}

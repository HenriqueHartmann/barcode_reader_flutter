import 'package:flutter/material.dart';

class LoadingController extends ChangeNotifier {
  bool _isLoading = true;

  bool getIsLoading() {
    return _isLoading;
  }

  void setIsLoading({bool? value}) {
    if (value != null) {
      _isLoading = value;
    } else {
      _isLoading = !_isLoading;
    }
  }
}

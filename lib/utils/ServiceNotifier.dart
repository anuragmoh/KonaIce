import 'dart:async';

import 'package:flutter/material.dart';

class ServiceNotifier extends ChangeNotifier {
  static int count = 0;

  final _onNewData = StreamController<String>.broadcast();
  Stream<String> get onNewData => _onNewData.stream;

  increment(int index) {
    count = index;
    _onNewData.add(count.toString());
    debugPrint('service$index');
    notifyListeners();
  }
}

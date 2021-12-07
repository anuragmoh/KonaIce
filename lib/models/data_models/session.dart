import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class Session {
  final String key;
  final String value;

  Session({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "value": value,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      key: map["key"],
      value: map["value"],
    );
  }

  @override
  String toString() {
    return """
    ----------------------------------
    key: $key,
    value: $value
    ----------------------------------
    """;
  }
}

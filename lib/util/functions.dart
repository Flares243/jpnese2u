import 'dart:convert';

import 'package:flutter/foundation.dart';

void printPrettyJson(dynamic json) {
  if (kDebugMode) {
    print(JsonEncoder.withIndent('  ').convert(json));
  }
}

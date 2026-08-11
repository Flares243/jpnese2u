import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jpnese2u/util/constant/constant.dart';

void printPrettyJson(dynamic json) {
  if (kDebugMode) {
    print(encodePrettyJson(json));
  }
}

String encodePrettyJson(dynamic json) =>
    const JsonEncoder.withIndent('  ').convert(json);

String normalizeJapanesePunctuation(String text) =>
    text.split('').map((c) => asciiToFullWidthPunctuation[c] ?? c).join();

String getUniqueString() => DateTime.now().millisecondsSinceEpoch.toString();

List<String> parseListString(dynamic json) {
  if (json is List) {
    return json.map((e) => e.toString()).toList();
  } else if (json is String) {
    return [json];
  }
  return [];
}

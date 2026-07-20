import 'dart:typed_data';

import 'package:screen_capturer/screen_capturer.dart';

Map<String, Object?> capturedDataToJson(CapturedData value) => {
  'imageWidth': value.imageWidth,
  'imageHeight': value.imageHeight,
  'imageBytes': value.imageBytes,
  'imagePath': value.imagePath,
};

CapturedData capturedDataFromJson(Map<String, Object?> json) => CapturedData(
  imageWidth: json['imageWidth'] as int?,
  imageHeight: json['imageHeight'] as int?,
  imageBytes: switch (json['imageBytes']) {
    final Uint8List bytes => bytes,
    final List<dynamic> list => Uint8List.fromList(list.cast<int>()),
    _ => null,
  },
  imagePath: json['imagePath'] as String?,
);

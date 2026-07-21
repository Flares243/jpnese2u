import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/tokenize_serv/model.dart';

part 'capture_info.g.dart';

@JsonSerializable(explicitToJson: true)
class CaptureInfo {
  @JsonKey(toJson: capturedDataToJson, fromJson: capturedDataFromJson)
  final CapturedData data;
  final String? text;
  final List<RawToken> tokens;

  const CaptureInfo({
    required this.data,
    this.text,
    this.tokens = const [],
  });

  factory CaptureInfo.fromJson(Map<String, dynamic> json) =>
      _$CaptureInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CaptureInfoToJson(this);
}

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

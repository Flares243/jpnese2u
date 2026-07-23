import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/window_factory/constant.dart';

part 'model.g.dart';

@JsonSerializable()
class WindowArguments {
  final WindowType type;

  const WindowArguments({required this.type});

  factory WindowArguments.fromJson(Map<String, dynamic> json) =>
      _$WindowArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$WindowArgumentsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CaptureTranslateWindowArguments extends WindowArguments {
  @JsonKey(toJson: capturedDataToJson, fromJson: capturedDataFromJson)
  final CapturedData capturedData;

  const CaptureTranslateWindowArguments({
    required super.type,
    required this.capturedData,
  });

  factory CaptureTranslateWindowArguments.fromJson(Map<String, dynamic> json) =>
      _$CaptureTranslateWindowArgumentsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CaptureTranslateWindowArgumentsToJson(this);
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

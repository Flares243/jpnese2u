import 'package:jpnese2u/util/captured_data_addons.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/service/window_factory/constant.dart';

part 'model.g.dart';

sealed class WindowArguments {
  final WindowType type;

  const WindowArguments({required this.type});

  factory WindowArguments.fromJson(Map<String, dynamic> json) {
    final type = WindowType.values.byName(json['type'] as String);

    return switch (type) {
      WindowType.screenshot => CaptureTranslateWindowArguments.fromJson(json),
      WindowType.settings => SettingWindowArguments.fromJson(json),
    };
  }
}

@JsonSerializable(explicitToJson: true)
class CaptureTranslateWindowArguments extends WindowArguments {
  @JsonKey(toJson: capturedDataToJson, fromJson: capturedDataFromJson)
  final CapturedData capturedData;

  const CaptureTranslateWindowArguments({required this.capturedData})
    : super(type: WindowType.screenshot);

  factory CaptureTranslateWindowArguments.fromJson(Map<String, dynamic> json) =>
      _$CaptureTranslateWindowArgumentsFromJson(json);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    ..._$CaptureTranslateWindowArgumentsToJson(this),
  };
}

@JsonSerializable(explicitToJson: true)
class SettingWindowArguments extends WindowArguments {
  const SettingWindowArguments() : super(type: WindowType.settings);

  factory SettingWindowArguments.fromJson(Map<String, dynamic> json) =>
      _$SettingWindowArgumentsFromJson(json);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    ..._$SettingWindowArgumentsToJson(this),
  };
}

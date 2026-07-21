import 'package:json_annotation/json_annotation.dart';

import 'package:jpnese2u/models/capture_info.dart';

part 'constant.g.dart';

enum WindowType { screenshot }

@JsonSerializable()
class WindowArguments {
  const WindowArguments({
    required this.type,
  });

  final WindowType type;

  factory WindowArguments.fromJson(Map<String, dynamic> json) =>
      _$WindowArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$WindowArgumentsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ScreenshotWindowArguments extends WindowArguments {
  const ScreenshotWindowArguments({
    required super.type,
    required this.captureInfo,
  });

  final CaptureInfo captureInfo;

  factory ScreenshotWindowArguments.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotWindowArgumentsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ScreenshotWindowArgumentsToJson(this);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/extensions/json_ext.dart';

part 'screenshot.g.dart';

@JsonSerializable(explicitToJson: true)
class ScreenshotState {
  @JsonKey(toJson: capturedDataToJson, fromJson: capturedDataFromJson)
  final CapturedData captureData;
  final String? text;
  final List<RawToken> tokens;

  const ScreenshotState({
    required this.captureData,
    this.text,
    this.tokens = const [],
  });

  factory ScreenshotState.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotStateFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotStateToJson(this);
}

class ScreenshotCubit extends Cubit<ScreenshotState?> {
  ScreenshotCubit() : super(null);

  void setState(ScreenshotState newState) {
    emit(newState);
  }
}

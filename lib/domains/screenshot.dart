import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuromoji/kuromoji.dart';
import 'package:screen_capturer/screen_capturer.dart';

part 'screenshot.mapper.dart';

@MappableClass()
class ScreenshotState with ScreenshotStateMappable {
  const ScreenshotState({
    required this.data,
    this.text,
    this.tokens = const [],
  });

  final CapturedData data;
  final String? text;
  final List<UnknownToken> tokens;
}

class ScreenshotCubit extends Cubit<ScreenshotState?> {
  ScreenshotCubit() : super(null);

  void setState(ScreenshotState newState) {
    emit(newState);
  }
}

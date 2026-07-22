import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final kIsMacOS = defaultTargetPlatform == TargetPlatform.macOS;
final kIsWindows = defaultTargetPlatform == TargetPlatform.windows;

const kTempScreenshotFileName = 'temp_screenshot.png';

const asciiToFullWidthPunctuation = {
  '!': '！',
  '?': '？',
  ',': '、',
  '.': '。',
  ':': '：',
  ';': '；',
  '(': '（',
  ')': '）',
  '[': '［',
  ']': '］',
  '{': '｛',
  '}': '｝',
  '<': '＜',
  '>': '＞',
  '"': '＂',
  '\'': '＇',
};

const kDefaultWindowSize = Size(900, 700);

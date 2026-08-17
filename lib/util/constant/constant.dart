import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Set<String> kSentenceEnders = {
  '。',
  '？',
  '！',
  '』',
  '」',
  '）',
  '】',
  '…',
};

final kIsMacOS = defaultTargetPlatform == TargetPlatform.macOS;
final kIsWindows = defaultTargetPlatform == TargetPlatform.windows;

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

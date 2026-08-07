import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extensions/string_ext.dart';

part 'model.g.dart';
part 'model.private.dart';

class CaptureInfo {
  final String? text;
  final List<RawToken> tokens;
  final List<CaptureSentenceData> sentences;

  const CaptureInfo({
    this.text,
    this.tokens = const [],
    this.sentences = const [],
  });
}

@JsonSerializable(explicitToJson: true)
class CaptureSentenceData {
  final int id;
  final String text;
  final List<CaptureTokenData> tokens;

  const CaptureSentenceData({
    required this.id,
    required this.text,
    required this.tokens,
  });

  List<int> get tokenIds => tokens.map((t) => t.id).toList();

  List<CaptureTokenData> get selectableTokens =>
      tokens.where((t) => !t.pos.isPunctuation).toList();

  factory CaptureSentenceData.fromJson(Map<String, dynamic> json) =>
      _$CaptureSentenceDataFromJson(json);

  Map<String, dynamic> toJson() => _$CaptureSentenceDataToJson(this);
}

@JsonSerializable()
class CaptureTokenData {
  final int id;
  final String surface;
  final String pos;
  final String reading;

  const CaptureTokenData({
    required this.id,
    required this.surface,
    required this.pos,
    required this.reading,
  });

  factory CaptureTokenData.fromJson(Map<String, dynamic> json) =>
      _$CaptureTokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$CaptureTokenDataToJson(this);
}

class TokenTranslation {
  final int id;
  final String translation;

  const TokenTranslation({
    required this.id,
    required this.translation,
  });
}

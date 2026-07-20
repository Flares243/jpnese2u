import 'package:flutter/material.dart';

import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/extensions/string_ext.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class UIToken {
  final int id;
  final String surface;
  final String pos;
  final String reading;

  const UIToken({
    required this.id,
    required this.surface,
    required this.pos,
    required this.reading,
  });

  factory UIToken.fromUnidic(int id, UnidicToken source) => UIToken(
    id: id,
    surface: source.surface,
    pos: source.pos,
    reading: source.reading,
  );

  factory UIToken.fromIpadic(int id, IpadicToken source) => UIToken(
    id: id,
    surface: source.surface,
    pos: source.pos,
    reading: source.reading,
  );

  factory UIToken.fromJson(Map<String, dynamic> json) =>
      _$UITokenFromJson(json);

  Map<String, dynamic> toJson() => _$UITokenToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SentenceGroupInfo {
  const SentenceGroupInfo({
    required this.id,
    required this.text,
    required this.tokens,
  });

  final int id;
  final String text;
  final List<UIToken> tokens;

  List<UIToken> get selectableTokens =>
      tokens.where((t) => !t.pos.isPunctuation).toList();

  factory SentenceGroupInfo.fromJson(Map<String, dynamic> json) =>
      _$SentenceGroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceGroupInfoToJson(this);
}

class PosStyle {
  const PosStyle({
    required this.bg,
    required this.borderColor,
    required this.headerColor,
  });

  final Color bg;
  final Color borderColor;
  final Color headerColor;
}

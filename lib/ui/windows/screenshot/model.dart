import 'package:flutter/material.dart';

import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';

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
}

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
      tokens.where((t) => t.pos != Hinshi.auxSymbol.jp).toList();
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

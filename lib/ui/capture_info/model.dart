import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extensions/string_ext.dart';

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
class SentenceInfo {
  final int id;
  final String text;
  final List<UIToken> tokens;

  const SentenceInfo({
    required this.id,
    required this.text,
    required this.tokens,
  });

  List<UIToken> get selectableTokens =>
      tokens.where((t) => !t.pos.isPunctuation).toList();

  List<Hinshi> get presentHinshi => selectableTokens
      .map((t) => Hinshi.fromJp(t.pos))
      .nonNulls
      .fold(<Hinshi>[], (list, h) => list.contains(h) ? list : [...list, h]);

  Map<Hinshi, List<UIToken>> get tokensByHinshi {
    final map = selectableTokens.fold(<Hinshi, List<UIToken>>{}, (map, t) {
      final h = Hinshi.fromJp(t.pos);
      if (h == null) return map;

      return {
        ...map,
        h: [...(map[h] ?? []), t],
      };
    });

    return Map.fromEntries(
      Hinshi.values
          .where((h) => map.containsKey(h))
          .map((h) => MapEntry(h, map[h]!)),
    );
  }

  factory SentenceInfo.fromJson(Map<String, dynamic> json) =>
      _$SentenceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceInfoToJson(this);
}

class PosStyle {
  final Color bg;
  final Color borderColor;
  final Color headerColor;

  const PosStyle({
    required this.bg,
    required this.borderColor,
    required this.headerColor,
  });
}

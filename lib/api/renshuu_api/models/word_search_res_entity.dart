import 'package:jpnese2u/util/function/common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:jpnese2u/api/renshuu_api/models/common.dart';

part 'word_search_res_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class WordSearchResEntity {
  const WordSearchResEntity({
    this.words,
    this.resultCount,
    this.totalPg,
    this.perPg,
    this.pg,
    this.query,
    this.count,
    this.apiUsage,
  });

  @JsonKey(name: "words")
  final List<RenshuuWord>? words;
  @JsonKey(name: "result_count")
  final int? resultCount;
  @JsonKey(name: "total_pg")
  final int? totalPg;
  @JsonKey(name: "per_pg")
  final int? perPg;
  @JsonKey(name: "pg")
  final int? pg;
  @JsonKey(name: "query")
  final String? query;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "api_usage")
  final ApiUsageResFieldEntity? apiUsage;

  factory WordSearchResEntity.fromJson(Map<String, dynamic> json) =>
      _$WordSearchResEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WordSearchResEntityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RenshuuWord {
  const RenshuuWord({
    this.isCommon,
    this.kanjiFull,
    this.hiraganaFull,
    this.id,
    this.reibuns,
    this.aforms,
    this.edictEnt,
    this.config,
    this.markers,
    this.pitch,
    this.notes,
    this.typeofspeech,
    this.def,
    this.pic,
  });

  @JsonKey(name: "is_common")
  final bool? isCommon;
  @JsonKey(name: "kanji_full")
  final String? kanjiFull;
  @JsonKey(name: "hiragana_full")
  final String? hiraganaFull;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "reibuns")
  final String? reibuns;
  @JsonKey(name: "aforms")
  final List<RenshuuAform>? aforms;
  @JsonKey(name: "edict_ent")
  final String? edictEnt;
  @JsonKey(name: "config")
  final List<String>? config;
  @JsonKey(name: "markers")
  final List<String>? markers;
  @JsonKey(name: "pitch")
  final List<String>? pitch;
  @JsonKey(name: "notes")
  final List<dynamic>? notes;
  @JsonKey(name: "typeofspeech")
  final String? typeofspeech;
  @JsonKey(
    name: "def",
    fromJson: parseListString,
  )
  final List<String>? def;
  @JsonKey(name: "pic")
  final List<String>? pic;

  factory RenshuuWord.fromJson(Map<String, dynamic> json) =>
      _$RenshuuWordFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuWordToJson(this);
}

@JsonSerializable()
class RenshuuAform {
  const RenshuuAform({
    this.id,
    this.term,
  });

  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "term")
  final String? term;

  factory RenshuuAform.fromJson(Map<String, dynamic> json) =>
      _$RenshuuAformFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuAformToJson(this);
}

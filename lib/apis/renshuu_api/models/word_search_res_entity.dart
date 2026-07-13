import 'package:json_annotation/json_annotation.dart';

import 'package:jpnese2u/apis/renshuu_api/models/common.dart';

part 'word_search_res_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class WordSearchResEntity {
  const WordSearchResEntity({
    required this.words,
    required this.resultCount,
    required this.totalPg,
    required this.perPg,
    required this.pg,
    required this.query,
    required this.count,
    required this.apiUsage,
  });

  @JsonKey(name: "words")
  final List<WordSearchResEntityWord> words;
  @JsonKey(name: "result_count")
  final int resultCount;
  @JsonKey(name: "total_pg")
  final int totalPg;
  @JsonKey(name: "per_pg")
  final int perPg;
  @JsonKey(name: "pg")
  final int pg;
  @JsonKey(name: "query")
  final String query;
  @JsonKey(name: "count")
  final int count;
  @JsonKey(name: "api_usage")
  final ApiUsageResFieldEntity apiUsage;

  factory WordSearchResEntity.fromJson(Map<String, dynamic> json) =>
      _$WordSearchResEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WordSearchResEntityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WordSearchResEntityWord {
  const WordSearchResEntityWord({
    required this.isCommon,
    required this.kanjiFull,
    required this.hiraganaFull,
    required this.id,
    required this.reibuns,
    required this.aforms,
    required this.edictEnt,
    required this.config,
    required this.markers,
    required this.pitch,
    required this.notes,
    required this.typeofspeech,
    required this.def,
    required this.pic,
  });

  @JsonKey(name: "is_common")
  final bool isCommon;
  @JsonKey(name: "kanji_full")
  final String kanjiFull;
  @JsonKey(name: "hiragana_full")
  final String hiraganaFull;
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "reibuns")
  final String reibuns;
  @JsonKey(name: "aforms")
  final List<WordSearchResEntityAform> aforms;
  @JsonKey(name: "edict_ent")
  final String edictEnt;
  @JsonKey(name: "config")
  final List<String> config;
  @JsonKey(name: "markers")
  final List<String> markers;
  @JsonKey(name: "pitch")
  final List<String> pitch;
  @JsonKey(name: "notes")
  final List<dynamic> notes;
  @JsonKey(name: "typeofspeech")
  final String typeofspeech;
  @JsonKey(name: "def")
  final List<String> def;
  @JsonKey(name: "pic")
  final List<String> pic;

  factory WordSearchResEntityWord.fromJson(Map<String, dynamic> json) =>
      _$WordSearchResEntityWordFromJson(json);

  Map<String, dynamic> toJson() => _$WordSearchResEntityWordToJson(this);
}

@JsonSerializable()
class WordSearchResEntityAform {
  const WordSearchResEntityAform({
    required this.id,
    required this.term,
  });

  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "term")
  final String term;

  factory WordSearchResEntityAform.fromJson(Map<String, dynamic> json) =>
      _$WordSearchResEntityAformFromJson(json);

  Map<String, dynamic> toJson() => _$WordSearchResEntityAformToJson(this);
}

import 'package:jpnese2u/api/renshuu_api/models/common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_profile_res_entity.g.dart';

@JsonSerializable()
class GetProfileResEntity {
  const GetProfileResEntity({
    this.id,
    this.realName,
    this.adventureLevel,
    this.userLength,
    this.kao,
    this.studied,
    this.levelProgressPercs,
    this.streaks,
    this.apiUsage,
  });

  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "real_name")
  final String? realName;
  @JsonKey(name: "adventure_level")
  final int? adventureLevel;
  @JsonKey(name: "user_length")
  final String? userLength;
  @JsonKey(name: "kao")
  final String? kao;
  @JsonKey(name: "studied")
  final Map<String, int>? studied;
  @JsonKey(name: "level_progress_percs")
  final RenshuuLevelProgressPercs? levelProgressPercs;
  @JsonKey(name: "streaks")
  final RenshuuStreaks? streaks;
  @JsonKey(name: "api_usage")
  final ApiUsageResFieldEntity? apiUsage;

  factory GetProfileResEntity.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResEntityToJson(this);
}

@JsonSerializable()
class RenshuuLevelProgressPercs {
  const RenshuuLevelProgressPercs({
    this.vocab,
    this.kanji,
    this.grammar,
    this.sent,
  });

  @JsonKey(name: "vocab")
  final RenshuuVocab? vocab;
  @JsonKey(name: "kanji")
  final RenshuuGrammar? kanji;
  @JsonKey(name: "grammar")
  final RenshuuGrammar? grammar;
  @JsonKey(name: "sent")
  final RenshuuGrammar? sent;

  factory RenshuuLevelProgressPercs.fromJson(Map<String, dynamic> json) =>
      _$RenshuuLevelProgressPercsFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuLevelProgressPercsToJson(this);
}

@JsonSerializable()
class RenshuuGrammar {
  @JsonKey(name: "n1")
  final int? n1;
  @JsonKey(name: "n2")
  final int? n2;
  @JsonKey(name: "n3")
  final int? n3;
  @JsonKey(name: "n4")
  final int? n4;
  @JsonKey(name: "n5")
  final int? n5;

  RenshuuGrammar({
    this.n1,
    this.n2,
    this.n3,
    this.n4,
    this.n5,
  });

  factory RenshuuGrammar.fromJson(Map<String, dynamic> json) =>
      _$RenshuuGrammarFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuGrammarToJson(this);
}

@JsonSerializable()
class RenshuuVocab {
  const RenshuuVocab({
    this.n1,
    this.n2,
    this.n3,
    this.n4,
    this.n5,
    this.n6,
    this.kana,
    this.kata,
  });

  @JsonKey(name: "n1")
  final int? n1;
  @JsonKey(name: "n2")
  final int? n2;
  @JsonKey(name: "n3")
  final int? n3;
  @JsonKey(name: "n4")
  final int? n4;
  @JsonKey(name: "n5")
  final int? n5;
  @JsonKey(name: "n6")
  final int? n6;
  @JsonKey(name: "kana")
  final int? kana;
  @JsonKey(name: "kata")
  final int? kata;

  factory RenshuuVocab.fromJson(Map<String, dynamic> json) =>
      _$RenshuuVocabFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuVocabToJson(this);
}

@JsonSerializable()
class RenshuuStreaks {
  const RenshuuStreaks({
    this.vocab,
    this.kanji,
    this.grammar,
    this.sent,
    this.conj,
    this.aconj,
  });

  @JsonKey(name: "vocab")
  final RenshuuAconj? vocab;
  @JsonKey(name: "kanji")
  final RenshuuAconj? kanji;
  @JsonKey(name: "grammar")
  final RenshuuAconj? grammar;
  @JsonKey(name: "sent")
  final RenshuuAconj? sent;
  @JsonKey(name: "conj")
  final RenshuuAconj? conj;
  @JsonKey(name: "aconj")
  final RenshuuAconj? aconj;

  factory RenshuuStreaks.fromJson(Map<String, dynamic> json) =>
      _$RenshuuStreaksFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuStreaksToJson(this);
}

@JsonSerializable()
class RenshuuAconj {
  const RenshuuAconj({
    this.correctInARow,
    this.correctInARowAlltime,
    this.daysStudiedInARow,
    this.daysStudiedInARowAlltime,
  });

  @JsonKey(name: "correct_in_a_row")
  final int? correctInARow;
  @JsonKey(name: "correct_in_a_row_alltime")
  final int? correctInARowAlltime;
  @JsonKey(name: "days_studied_in_a_row")
  final int? daysStudiedInARow;
  @JsonKey(name: "days_studied_in_a_row_alltime")
  final int? daysStudiedInARowAlltime;

  factory RenshuuAconj.fromJson(Map<String, dynamic> json) =>
      _$RenshuuAconjFromJson(json);

  Map<String, dynamic> toJson() => _$RenshuuAconjToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:mecab_for_dart/mecab_dart.dart';

part 'model.g.dart';

sealed class RawToken {
  final String surface;

  const RawToken({
    required this.surface,
  });

  factory RawToken.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String?) {
      case 'unidic':
        return UnidicToken.fromJson(json);
      case 'ipadic':
        return IpadicToken.fromJson(json);
      default:
        throw ArgumentError('Unknown RawToken type: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson();
}

// UniDic feature indices:
// [0]  pos            品詞
// [1]  posSub         品詞細分類1
// [2]  posSub2        品詞細分類2
// [3]  posSub3        品詞細分類3
// [4]  conjugationType 活用型
// [5]  conjugationForm 活用形
// [6]  lemmaReading   語彙素読み (kana reading of the lemma)
// [7]  baseForm       語彙素     (dictionary/lemma form, e.g. "開ける")
// [8]  orthBase       書字形出現形 (written base of the surface form)
// [9]  reading        読み形出現形 (kana reading of the surface form)
// [10] pronunciation  発音形出現形 (pronunciation of the surface form)
// [11] pronBase       発音形基本形 (base pronunciation)
// [12] goshu          語種        (word origin: 和/漢/外/混/固/記号)
@JsonSerializable()
class UnidicToken extends RawToken {
  final String pos;
  final String posSub;
  final String posSub2;
  final String posSub3;
  final String conjugationType;
  final String conjugationForm;

  /// Kana reading of the lemma (語彙素読み).
  final String lemmaReading;

  /// Dictionary/lemma form of the word (語彙素).
  final String baseForm;

  /// Written base of the surface form (書字形出現形).
  final String orthBase;

  /// Kana reading of the surface form (読み形出現形).
  final String reading;

  /// Pronunciation of the surface form (発音形出現形).
  final String pronunciation;

  /// Word origin/type: 和・漢・外・混・固・記号 (語種).
  final String goshu;

  const UnidicToken({
    required super.surface,
    required this.pos,
    required this.posSub,
    required this.posSub2,
    required this.posSub3,
    required this.conjugationType,
    required this.conjugationForm,
    required this.lemmaReading,
    required this.baseForm,
    required this.orthBase,
    required this.reading,
    required this.pronunciation,
    required this.goshu,
  });

  factory UnidicToken.fromMecab(TokenNode rawToken) {
    final features = rawToken.features;
    final surface = rawToken.surface;

    String f(int i) => features.length > i ? features[i] : '';

    final pos = features.isNotEmpty ? features[0] : 'OTHER';
    final base = f(7);

    return UnidicToken(
      surface: surface,
      pos: pos,
      posSub: f(1),
      posSub2: f(2),
      posSub3: f(3),
      conjugationType: f(4),
      conjugationForm: f(5),
      lemmaReading: f(6),
      baseForm: (base == '*' || base.isEmpty) ? surface : base,
      orthBase: f(8),
      reading: f(9),
      pronunciation: f(10),
      goshu: f(12),
    );
  }

  factory UnidicToken.fromJson(Map<String, dynamic> json) =>
      _$UnidicTokenFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'unidic',
    ..._$UnidicTokenToJson(this),
  };
}

@JsonSerializable()
class IpadicToken extends RawToken {
  final String pos;
  final String posSub;
  final String conjugationType;
  final String conjugationForm;
  final String baseForm;
  final String reading;
  final String pronunciation;

  const IpadicToken({
    required super.surface,
    required this.pos,
    required this.posSub,
    required this.conjugationType,
    required this.conjugationForm,
    required this.baseForm,
    required this.reading,
    required this.pronunciation,
  });

  factory IpadicToken.fromMecab(TokenNode rawToken) {
    final features = rawToken.features;
    final surface = rawToken.surface;

    // Safety checks: punctuation or empty spaces can yield shorter feature lists
    final pos = features.isNotEmpty ? features[0] : 'OTHER';
    final posSub = features.length > 1 ? features[1] : '';
    final conjugationType = features.length > 4 ? features[4] : '';
    final conjugationForm = features.length > 5 ? features[5] : '';
    final base = features.length > 6 ? features[6] : surface;
    final read = features.length > 7 ? features[7] : '';
    final pronunciation = features.length > 8 ? features[8] : '';

    return IpadicToken(
      surface: surface,
      pos: pos,
      posSub: posSub,
      conjugationType: conjugationType,
      conjugationForm: conjugationForm,
      baseForm: (base == '*' || base.isEmpty) ? surface : base,
      reading: read,
      pronunciation: pronunciation,
    );
  }

  factory IpadicToken.fromJson(Map<String, dynamic> json) =>
      _$IpadicTokenFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'ipadic',
    ..._$IpadicTokenToJson(this),
  };
}

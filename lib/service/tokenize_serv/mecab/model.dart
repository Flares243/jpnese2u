import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// UniDic 17-field specification mapping:
// [0]  pos1      品詞大分類     (POS level 1)
// [1]  pos2      品詞中分類     (POS level 2)
// [2]  pos3      品詞小分類     (POS level 3)
// [3]  pos4      品詞細分類     (POS level 4)
// [4]  cType     活用型         (Conjugation type)
// [5]  cForm     活用形         (Conjugation form)
// [6]  lForm     語彙素読み     (Lemma reading in Katakana)
// [7]  lemma     語彙素         (Lemma / dictionary base form)
// [8]  orth      書字形出現形   (Orthographic surface form)
// [9]  pron      発音形出現形   (Pronunciation surface form)
// [10] orthBase  書字形基本形   (Orthographic base form)
// [11] pronBase  発音形基本形   (Pronunciation base form)
// [12] goshu     語種           (Word origin: 和/漢/外/混/固/記号)
// [13] iType     語頭変化型     (Initial transformation type)
// [14] iForm     語頭変化形     (Initial transformation form)
// [15] fType     語末変化型     (Final transformation type)
// [16] fForm     語末変化形     (Final transformation form)
@JsonSerializable()
@CopyWith()
class UnidicToken extends RawToken {
  final String pos;
  final String posSub;
  final String posSub2;
  final String posSub3;
  final String conjugationType;
  final String conjugationForm;

  /// Katakana reading of the lemma (語彙素読み).
  final String lemmaReading;

  /// Dictionary/lemma form of the word (語彙素).
  final String baseForm;

  /// Orthographic surface form (書字形出現形).
  final String orth;

  /// Pronunciation of the surface form (発音形出現形).
  final String pronunciation;

  /// Orthographic base form (書字形基本形).
  final String orthBase;

  /// Pronunciation base form (発音形基本形).
  final String pronBase;

  /// Word origin/type: 和・漢・外・混・固・記号 (語種).
  final String goshu;

  /// Sound transformation fields (語頭・語末変化).
  final String iType;
  final String iForm;
  final String fType;
  final String fForm;

  const UnidicToken({
    required super.tokenId,
    required super.surface,
    required this.pos,
    required this.posSub,
    required this.posSub2,
    required this.posSub3,
    required this.conjugationType,
    required this.conjugationForm,
    required this.lemmaReading,
    required this.baseForm,
    required this.orth,
    required this.pronunciation,
    required this.orthBase,
    required this.pronBase,
    required this.goshu,
    this.iType = '*',
    this.iForm = '*',
    this.fType = '*',
    this.fForm = '*',
  });

  factory UnidicToken.fromJson(Map<String, dynamic> json) =>
      _$UnidicTokenFromJson(json);

  Map<String, dynamic> toJson() => _$UnidicTokenToJson(this);

  @override
  CaptureTokenData toCaptureTokenData([int? id]) => CaptureTokenData(
    id: id ?? tokenId,
    surface: surface,
    pos: pos,
    reading: lemmaReading,
  );
}

// IPADIC standard 9-field feature indices:
// [0] pos             品詞           (POS main level)
// [1] posSub          品詞細分類1    (POS subcategory 1)
// [2] posSub2         品詞細分類2    (POS subcategory 2)
// [3] posSub3         品詞細分類3    (POS subcategory 3)
// [4] conjugationType 活用型         (Conjugation type)
// [5] conjugationForm 活用形         (Conjugation form)
// [6] baseForm        原形           (Base / dictionary form)
// [7] reading         読み           (Katakana reading)
// [8] pronunciation   発音           (Katakana pronunciation)
@JsonSerializable()
@CopyWith()
class IpadicToken extends RawToken {
  final String pos;
  final String posSub;
  final String posSub2;
  final String posSub3;
  final String conjugationType;
  final String conjugationForm;

  /// Base form / dictionary form of the word (原形).
  final String baseForm;

  /// Katakana reading of the word (読み).
  final String reading;

  /// Katakana pronunciation of the word (発音).
  final String pronunciation;

  const IpadicToken({
    required super.tokenId,
    required super.surface,
    required this.pos,
    required this.posSub,
    required this.posSub2,
    required this.posSub3,
    required this.conjugationType,
    required this.conjugationForm,
    required this.baseForm,
    required this.reading,
    required this.pronunciation,
  });

  factory IpadicToken.fromJson(Map<String, dynamic> json) =>
      _$IpadicTokenFromJson(json);

  Map<String, dynamic> toJson() => _$IpadicTokenToJson(this);

  @override
  CaptureTokenData toCaptureTokenData([int? id]) => CaptureTokenData(
    id: id ?? tokenId,
    surface: surface,
    pos: pos,
    reading: reading,
  );
}

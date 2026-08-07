import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:sudachi_dart/sudachi_dart.dart';

part 'model.g.dart';
part 'model.mapper.dart';

@MappableClass()
class SudachiConfig with SudachiConfigMappable {
  final String? configPath;
  final String? resourceDirPath;
  final String? dictionaryPath;

  const SudachiConfig({
    this.configPath,
    this.resourceDirPath,
    this.dictionaryPath,
  });
}

// Sudachi POS 6-field specification (品詞体系):
// [0] pos             品詞           (POS level 1)
// [1] posSub          品詞細分類1    (POS subcategory 1)
// [2] posSub2         品詞細分類2    (POS subcategory 2)
// [3] posSub3         品詞細分類3    (POS subcategory 3)
// [4] conjugationType 活用型         (Conjugation type)
// [5] conjugationForm 活用形         (Conjugation form)
@CopyWith()
class SudachiToken extends RawToken {
  final String dictionaryForm;
  final String normalizedForm;
  final String readingForm;
  final String pos;
  final String posSub;
  final String posSub2;
  final String posSub3;
  final String conjugationType;
  final String conjugationForm;

  const SudachiToken({
    required super.surface,
    required this.dictionaryForm,
    required this.normalizedForm,
    required this.readingForm,
    required this.pos,
    this.posSub = '*',
    this.posSub2 = '*',
    this.posSub3 = '*',
    this.conjugationType = '*',
    this.conjugationForm = '*',
  });

  factory SudachiToken.fromMorpheme(Morpheme morpheme) {
    final p = morpheme.partOfSpeech;
    String f(int i) => p.length > i ? p[i] : '*';

    return SudachiToken(
      surface: morpheme.surface,
      dictionaryForm: morpheme.dictionaryForm,
      normalizedForm: morpheme.normalizedForm,
      readingForm: morpheme.readingForm,
      pos: p.isNotEmpty ? p[0] : 'OTHER',
      posSub: f(1),
      posSub2: f(2),
      posSub3: f(3),
      conjugationType: f(4),
      conjugationForm: f(5),
    );
  }
}

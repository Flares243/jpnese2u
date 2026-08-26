import 'package:jm_dict/jm_dict.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';

class JMDictService implements ITokenDefinitionServ<SudachiToken> {
  final JMDict _jmdict = JMDict();

  Future<void> init() async {
    await _jmdict.initFromAsset(
      assetPath: Assets.dictionaries.jMdictENG,
    );
  }

  @override
  Future<List<TokenDefinitionData>?> getTokenDefinition(
    SudachiToken token,
  ) async {
    // printPrettyJson({
    //   'term': token.surface,
    //   'dictionaryForm': token.dictionaryForm,
    //   'readingForm': token.readingForm,
    //   'partOfSpeech': token.pos,
    // });
    // for (final r
    //     in _jmdict.search(keyword: token.dictionaryForm, limit: 10) ??
    //         <JMDictEntry>[]) {
    //   printPrettyJson({
    //     'kanjiElements': r.kanjiElements?.map((k) => k.element).toList(),
    //     'readingElements': r.readingElements.map((r) => r.element).toList(),
    //     'partOfSpeeches': r.senseElements
    //         .expand((s) => s.partOfSpeeches ?? <PartOfSpeech>{})
    //         .map((p) => p.name)
    //         .toList(),
    //     'glossaries': r.senseElements
    //         .expand((s) => s.glossaries)
    //         .map((g) => g.text)
    //         .toList(),
    //   });
    // }

    final entries = _jmdict.search(
      keyword: token.dictionaryForm,
      limit: 10,
    );

    if (entries == null) return null;
    if (entries.isEmpty) return [];

    final List<TokenDefinitionData> results = [];

    for (final entry in entries) {
      final kanji = entry.kanjiElements?.firstOrNull?.element;
      final hiragana = entry.readingElements.firstOrNull?.element;

      final pos = entry.senseElements
          .expand((s) => s.partOfSpeeches ?? <PartOfSpeech>{})
          .firstOrNull;

      final englishGlossaries = entry.senseElements
          .expand((s) => s.glossaries)
          .map((g) => g.text)
          .toList();

      final alternates = [
        ...?entry.kanjiElements
            ?.skip(1)
            .map((k) => TokenDefinitionAlternate(term: k.element)),
        ...entry.readingElements
            .skip(kanji == null ? 1 : 0)
            .map((r) => TokenDefinitionAlternate(term: r.element)),
      ];

      results.add(
        TokenDefinitionData(
          kanji: kanji,
          hiragana: hiragana,
          typeOfSpeech: pos?.name,
          definitions: englishGlossaries,
          alternates: alternates,
        ),
      );
    }

    return results;
  }

  @override
  Future<void> dispose() async {
    _jmdict.close();
  }
}

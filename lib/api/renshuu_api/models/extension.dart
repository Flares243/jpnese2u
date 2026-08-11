import 'package:jpnese2u/api/renshuu_api/models/word_search_res_entity.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';

extension WordSearchResEntityWordExt on RenshuuWord {
  TokenDefinitionData toTokenDefinitionData({
    required int tokenId,
    required String surface,
  }) {
    return TokenDefinitionData(
      tokenId: tokenId,
      surface: surface,
      kanjiForm: kanjiFull,
      hiraganaForm: hiraganaFull,
      typeOfSpeech: typeofspeech,
      definitions: def,
      pitch: pitch,
      alternates: aforms
          ?.map((a) => TokenDefinitionAlternate(id: a.id, term: a.term))
          .toList(),
    );
  }
}

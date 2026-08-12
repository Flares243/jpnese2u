import 'package:dio/dio.dart';
import 'package:jpnese2u/api/renshuu_api/models/extension.dart';
import 'package:jpnese2u/api/renshuu_api/models/word_search_res_entity.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';

class MockRenshuuTokenDefinitionServ
    implements ITokenDefinitionServ<SudachiToken> {
  const MockRenshuuTokenDefinitionServ();

  @override
  Future<TokenDefinitionData?> getDefinitionForToken(
    SudachiToken token, {
    CancelToken? cancelToken,
  }) async {
    return RenshuuWord.fromJson({
      "is_common": false,
      "kanji_full": "友達",
      "hiragana_full": "ともだち",
      "id": "441",
      "reibuns": "681",
      "aforms": [
        {"id": "286022", "term": "友だち"},
        {"id": "443030", "term": "トモダチ"},
      ],
      "edict_ent": "1540170",
      "config": ["ent_primary"],
      "markers": ["JLPT N5", "News 12k", "Common 2,500"],
      "pitch": ["と⭧もだち"],
      "notes": [],
      "typeofspeech": "(noun)",
      "def": ["friend, companion"],
      "pic": [
        "https://iserve.renshuu.org/img/wpics/15586.png",
        "https://iserve.renshuu.org/img/wpics/26256.jpg",
        "https://iserve.renshuu.org/img/wpics/48239.jpg",
        "https://iserve.renshuu.org/img/wpics/1524.jpg",
        "https://iserve.renshuu.org/img/wpics/42552.jpg",
        "https://iserve.renshuu.org/img/wpics/37639.jpg",
        "https://iserve.renshuu.org/img/wpics/23818.jpg",
        "https://iserve.renshuu.org/img/wpics/45415.jpg",
        "https://iserve.renshuu.org/img/wpics/40379.png",
        "https://iserve.renshuu.org/img/wpics/29941.jpg",
        "https://iserve.renshuu.org/img/wpics/48579.jpg",
        "https://iserve.renshuu.org/img/wpics/44988.jpg",
        "https://iserve.renshuu.org/img/wpics/39897.jpg",
      ],
    }).toTokenDefinitionData();
  }
}

import 'package:jpnese2u/apis/renshuu_api/api.dart';
import 'package:jpnese2u/repositories/translate_repo/interface.dart';

class RenshuuRepo implements ITranstlateRepo {
  const RenshuuRepo(this._api);

  final RenshuuApi _api;

  @override
  Future<String> translate(String text) async {
    final res = await _api.wordSearch(value: text, pg: '0');
    if (res.data.isEmpty) {
      return '';
    }

    return res.data.first.meaning;
  }
}

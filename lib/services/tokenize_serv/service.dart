import 'package:kuromoji/kuromoji.dart';

import 'package:jpnese2u/services/tokenize_serv/interface.dart';

class TokenizeService implements ITokenizeService {
  Tokenizer? _tokenizer;

  Tokenizer _getTokenizer() {
    _tokenizer ??= Tokenizer.buildSync();
    return _tokenizer!;
  }

  @override
  List<UnknownToken> tokenize(String text) {
    return _getTokenizer().tokenize(text);
  }
}

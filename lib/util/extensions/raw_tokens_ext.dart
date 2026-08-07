import 'package:jpnese2u/services/tokenize_serv/mecab/addons.dart';
import 'package:jpnese2u/services/tokenize_serv/mecab/model.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/services/tokenize_serv/sudachi/addons.dart';
import 'package:jpnese2u/services/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/constant/constant.dart';

extension ListRawTokensExt on List<RawToken> {
  List<CaptureSentenceData> toSentences() {
    final groups = <CaptureSentenceData>[];
    var buffer = <RawToken>[];
    var pendingFlush = false;

    for (final token in this) {
      if (pendingFlush && !kSentenceEnders.contains(token.surface)) {
        groups.add(_makeGroup(groups.length, buffer));
        buffer = [];
        pendingFlush = false;
      }

      if (pendingFlush && kSentenceEnders.contains(token.surface)) {
        if (buffer.last is SudachiToken) {
          buffer[buffer.length - 1] = (buffer.last as SudachiToken).copyWith
              .surface(buffer.last.surface + token.surface);
        } else if (buffer.last is UnidicToken) {
          buffer[buffer.length - 1] = (buffer.last as UnidicToken).copyWith
              .surface(buffer.last.surface + token.surface);
        } else if (buffer.last is IpadicToken) {
          buffer[buffer.length - 1] = (buffer.last as IpadicToken).copyWith
              .surface(buffer.last.surface + token.surface);
        }
      } else {
        buffer.add(token);
      }

      pendingFlush = kSentenceEnders.contains(token.surface);
    }

    if (buffer.isNotEmpty) groups.add(_makeGroup(groups.length, buffer));

    return groups;
  }

  CaptureSentenceData _makeGroup(int id, List<RawToken> raw) =>
      CaptureSentenceData(
        id: id,
        text: raw.map((t) => t.surface).join(),
        tokens: [
          for (final (index, token) in raw.indexed)
            if (token is SudachiToken)
              token.toCaptureTokenData(index)
            else if (token is UnidicToken)
              token.toCaptureTokenData(index)
            else if (token is IpadicToken)
              token.toCaptureTokenData(index),
        ],
      );
}

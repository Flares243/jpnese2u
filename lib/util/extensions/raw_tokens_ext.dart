import 'package:jpnese2u/services/tokenize_serv/model.dart';
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
        buffer[buffer.length - 1] = switch (buffer.last) {
          UnidicToken unidicToken => unidicToken.copyWith.surface(
            unidicToken.surface + token.surface,
          ),
          IpadicToken ipadicToken => ipadicToken.copyWith.surface(
            ipadicToken.surface + token.surface,
          ),
        };
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
            switch (token) {
              UnidicToken token => CaptureTokenData.fromUnidic(index, token),
              IpadicToken token => CaptureTokenData.fromIpadic(index, token),
            },
        ],
      );
}

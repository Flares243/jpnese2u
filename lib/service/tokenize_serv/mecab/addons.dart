import 'package:jpnese2u/service/tokenize_serv/mecab/model.dart';
import 'package:mecab_for_dart/mecab_dart.dart';

extension MecabUnidicTokenExt on UnidicToken {
  static UnidicToken fromMecab(int tokenId, TokenNode rawToken) {
    final features = rawToken.features;
    final surface = rawToken.surface;

    // Safely retrieves feature array elements, defaulting to '*' when missing
    String f(int i) => features.length > i ? features[i] : '*';

    final pos = features.isNotEmpty ? features[0] : 'OTHER';
    final base = f(7);

    return UnidicToken(
      tokenId: tokenId,
      surface: surface,
      pos: pos,
      posSub: f(1),
      posSub2: f(2),
      posSub3: f(3),
      conjugationType: f(4),
      conjugationForm: f(5),
      lemmaReading: f(6),
      baseForm: (base == '*' || base.isEmpty) ? surface : base,
      orth: f(8),
      pronunciation: f(9),
      orthBase: f(10),
      pronBase: f(11),
      goshu: f(12),
      iType: f(13),
      iForm: f(14),
      fType: f(15),
      fForm: f(16),
    );
  }
}

extension MecabIpadicTokenExt on IpadicToken {
  static IpadicToken fromMecab(int tokenId, TokenNode rawToken) {
    final features = rawToken.features;
    final surface = rawToken.surface;

    // Safely retrieves feature array elements, defaulting to '*' when missing
    String f(int i) => features.length > i ? features[i] : '*';

    final pos = features.isNotEmpty ? features[0] : 'OTHER';
    final base = f(6);

    return IpadicToken(
      tokenId: tokenId,
      surface: surface,
      pos: pos,
      posSub: f(1),
      posSub2: f(2),
      posSub3: f(3),
      conjugationType: f(4),
      conjugationForm: f(5),
      baseForm: (base == '*' || base.isEmpty) ? surface : base,
      reading: f(7),
      pronunciation: f(8),
    );
  }
}

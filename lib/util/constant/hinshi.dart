import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/ui/capture_info/model.dart';

enum Hinshi {
  noun(
    jp: '名詞',
    abbreviation: 'NOUN',
    isContentWord: true,
  ),
  pronoun(
    jp: '代名詞',
    abbreviation: 'PRON',
    isContentWord: true,
  ),
  verb(
    jp: '動詞',
    abbreviation: 'VERB',
    isContentWord: true,
  ),
  adjI(
    jp: '形容詞',
    abbreviation: 'ADJ-I',
    isContentWord: true,
  ),
  adjNa(
    jp: '形状詞',
    abbreviation: 'ADJ-NA',
    isContentWord: true,
  ),
  prenominal(
    jp: '連体詞',
    abbreviation: 'RENTAI',
    isContentWord: true,
  ),
  adverb(
    jp: '副詞',
    abbreviation: 'ADV',
    isContentWord: true,
  ),
  conjunction(
    jp: '接続詞',
    abbreviation: 'CONJ',
    isContentWord: true,
  ),
  interjection(
    jp: '感動詞',
    abbreviation: 'INTJ',
    isContentWord: true,
  ),
  auxiliary(
    jp: '助動詞',
    abbreviation: 'AUX',
    isContentWord: false,
  ),
  particle(
    jp: '助詞',
    abbreviation: 'PRT',
    isContentWord: false,
  ),
  prefix(
    jp: '接頭詞',
    abbreviation: 'PREF',
    isContentWord: false,
  ),
  suffix(
    jp: '接尾辞',
    abbreviation: 'SUFF',
    isContentWord: false,
  ),
  symbol(
    jp: '記号',
    abbreviation: 'PUNCT',
    isContentWord: false,
  ),
  auxSymbol(
    jp: '補助記号',
    abbreviation: 'PUNCT',
    isContentWord: false,
  ),
  whitespace(
    jp: '空白',
    abbreviation: 'SPACE',
    isContentWord: false,
  ),
  unknown(
    jp: '',
    abbreviation: 'UNKNOWN',
    isContentWord: false,
  ),
  ;

  final String jp;
  final String abbreviation;
  final bool isContentWord;

  const Hinshi({
    required this.jp,
    required this.abbreviation,
    required this.isContentWord,
  });

  static Hinshi? fromJp(String jp) {
    for (final pos in Hinshi.values) {
      if (pos.jp == jp) return pos;
    }

    return null;
  }
}

extension HinshiExtension on Hinshi {
  PosStyle get posStyle => switch (this) {
    Hinshi.noun => PosStyle(
      bg: AppColor.xffeef2ff,
      borderColor: AppColor.xffc7d2fe,
      headerColor: AppColor.xff312e81,
    ),
    Hinshi.particle => PosStyle(
      bg: AppColor.xfff8fafc,
      borderColor: AppColor.xffe2e8f0,
      headerColor: AppColor.xff0f172a,
    ),
    Hinshi.verb => PosStyle(
      bg: AppColor.xfffff7ed,
      borderColor: AppColor.xfff59e0b,
      headerColor: AppColor.xff92400e,
    ),
    Hinshi.adjI => PosStyle(
      bg: AppColor.x66fef9c3,
      borderColor: AppColor.xfffacc15,
      headerColor: AppColor.xff854d0e,
    ),
    Hinshi.adjNa => PosStyle(
      bg: AppColor.x66ecfccb,
      borderColor: AppColor.xffa3e635,
      headerColor: AppColor.xff365314,
    ),
    Hinshi.adverb => PosStyle(
      bg: AppColor.xfff0fdfa,
      borderColor: AppColor.xff5eead4,
      headerColor: AppColor.xff134e4a,
    ),
    Hinshi.conjunction => PosStyle(
      bg: AppColor.xffecfeff,
      borderColor: AppColor.xff67e8f9,
      headerColor: AppColor.xff164e63,
    ),
    Hinshi.interjection => PosStyle(
      bg: AppColor.xfffff1f2,
      borderColor: AppColor.xfffda4af,
      headerColor: AppColor.xff9f1239,
    ),
    Hinshi.auxiliary => PosStyle(
      bg: AppColor.xfff1f5f9,
      borderColor: AppColor.xffcbd5e1,
      headerColor: AppColor.xff475569,
    ),
    Hinshi.symbol => PosStyle(
      bg: AppColor.xfff9fafb,
      borderColor: AppColor.xffd1d5db,
      headerColor: AppColor.xff374151,
    ),
    Hinshi.auxSymbol => PosStyle(
      bg: AppColor.xfff9fafb,
      borderColor: AppColor.xffd1d5db,
      headerColor: AppColor.xff374151,
    ),
    Hinshi.pronoun => PosStyle(
      bg: AppColor.xffede9fe,
      borderColor: AppColor.xffa78bfa,
      headerColor: AppColor.xff4c1d95,
    ),
    Hinshi.prenominal => PosStyle(
      bg: AppColor.xfffdf4ff,
      borderColor: AppColor.xffe879f9,
      headerColor: AppColor.xff701a75,
    ),
    Hinshi.prefix => PosStyle(
      bg: AppColor.xffecfdf5,
      borderColor: AppColor.xff6ee7b7,
      headerColor: AppColor.xff065f46,
    ),
    Hinshi.suffix => PosStyle(
      bg: AppColor.xfff0f9ff,
      borderColor: AppColor.xff7dd3fc,
      headerColor: AppColor.xff0c4a6e,
    ),
    Hinshi.whitespace => PosStyle(
      bg: AppColor.xfffafafa,
      borderColor: AppColor.xffe4e4e7,
      headerColor: AppColor.xff71717a,
    ),
    Hinshi.unknown => PosStyle(
      bg: AppColor.xfffafafa,
      borderColor: AppColor.xffe4e4e7,
      headerColor: AppColor.xff71717a,
    ),
  };
}

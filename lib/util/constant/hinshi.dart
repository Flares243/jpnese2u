import 'package:flutter/painting.dart';

import 'package:jpnese2u/theme/app_color.dart';

enum Hinshi {
  verb(
    jp: '動詞',
    abbreviation: 'VERB',
    isContentWord: true,
  ),
  noun(
    jp: '名詞',
    abbreviation: 'NOUN',
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
  pronoun(
    jp: '代名詞',
    abbreviation: 'PRON',
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
  prenominal(
    jp: '連体詞',
    abbreviation: 'RENTAI',
    isContentWord: true,
  ),
  prefix(
    jp: '接頭詞',
    abbreviation: 'PREF',
    isContentWord: false,
  ),
  modernPrefix(
    jp: '接頭辞',
    abbreviation: 'PREF',
    isContentWord: false,
  ),
  suffix(
    jp: '接尾辞',
    abbreviation: 'SUFF',
    isContentWord: false,
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

class PosStyle {
  final Color bg;
  final Color borderColor;
  final Color headerColor;

  const PosStyle({
    required this.bg,
    required this.borderColor,
    required this.headerColor,
  });
}

extension HinshiExtension on Hinshi {
  PosStyle get posStyle => switch (this) {
    Hinshi.verb => const PosStyle(
      bg: AppColor.xFFFFF7ED,
      borderColor: AppColor.xE2E5BB72,
      headerColor: AppColor.xFF92400E,
    ),
    Hinshi.noun => const PosStyle(
      bg: AppColor.xFFEEF2FF,
      borderColor: AppColor.xFFB0BEFF,
      headerColor: AppColor.xFF312E81,
    ),
    Hinshi.adjI => const PosStyle(
      bg: AppColor.x48FEF9C3,
      borderColor: AppColor.xE0FACC15,
      headerColor: AppColor.xFF854D0E,
    ),
    Hinshi.adjNa => const PosStyle(
      bg: AppColor.x66ECFCCB,
      borderColor: AppColor.xFFA3E635,
      headerColor: AppColor.xFF365314,
    ),
    Hinshi.pronoun => const PosStyle(
      bg: AppColor.xE8EDE9FE,
      borderColor: AppColor.xC2A78BFA,
      headerColor: AppColor.xFF4C1D95,
    ),
    Hinshi.adverb => const PosStyle(
      bg: AppColor.xFFF0FDFA,
      borderColor: AppColor.xFF5EEAD4,
      headerColor: AppColor.xFF134E4A,
    ),
    Hinshi.conjunction => const PosStyle(
      bg: AppColor.xD4EFF6FF,
      borderColor: AppColor.x813B83F6,
      headerColor: AppColor.xFF1E3A8A,
    ),
    Hinshi.interjection => const PosStyle(
      bg: AppColor.xFFFFF1F2,
      borderColor: AppColor.xFFFDA4AF,
      headerColor: AppColor.xFF9F1239,
    ),
    Hinshi.prenominal => const PosStyle(
      bg: AppColor.x4DF5C6FF,
      borderColor: AppColor.xD2E879F9,
      headerColor: AppColor.xFF701A75,
    ),
    Hinshi.prefix || Hinshi.modernPrefix => const PosStyle(
      bg: AppColor.xFFECFDF5,
      borderColor: AppColor.xFF6EE7B7,
      headerColor: AppColor.xFF065F46,
    ),
    Hinshi.suffix => const PosStyle(
      bg: AppColor.xFFFDF4F9,
      borderColor: AppColor.xB4F472B5,
      headerColor: AppColor.xFF831843,
    ),
    Hinshi.auxiliary => const PosStyle(
      bg: AppColor.xFFF1F5F9,
      borderColor: AppColor.xFFCBD5E1,
      headerColor: AppColor.xFF475569,
    ),
    Hinshi.particle => const PosStyle(
      bg: AppColor.xFFF8FAFC,
      borderColor: AppColor.xFFBDC2C8,
      headerColor: AppColor.xFF0F172A,
    ),
    Hinshi.symbol => const PosStyle(
      bg: AppColor.xFFF9FAFB,
      borderColor: AppColor.xFFD1D5DB,
      headerColor: AppColor.xFF374151,
    ),
    Hinshi.auxSymbol => const PosStyle(
      bg: AppColor.xFFF9FAFB,
      borderColor: AppColor.xFFD1D5DB,
      headerColor: AppColor.xFF374151,
    ),
    Hinshi.whitespace => const PosStyle(
      bg: AppColor.xFFFAFAFA,
      borderColor: AppColor.xFFE4E4E7,
      headerColor: AppColor.xFF71717A,
    ),
    Hinshi.unknown => const PosStyle(
      bg: AppColor.xFFFAFAFA,
      borderColor: AppColor.xFFE4E4E7,
      headerColor: AppColor.xFF71717A,
    ),
  };
}

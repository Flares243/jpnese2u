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
    jp: '接頭辞',
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

  const Hinshi({
    required this.jp,
    required this.abbreviation,
    required this.isContentWord,
  });

  final String jp;
  final String abbreviation;
  final bool isContentWord;

  static Hinshi? fromJp(String jp) {
    for (final pos in Hinshi.values) {
      if (pos.jp == jp) return pos;
    }

    return null;
  }
}

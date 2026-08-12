class TokenDefinitionData {
  final String? kanji;
  final String? hiragana;
  final String? typeOfSpeech;
  final List<String>? definitions;
  final List<String>? pitch;
  final List<TokenDefinitionAlternate>? alternates;

  const TokenDefinitionData({
    this.kanji,
    this.hiragana,
    this.typeOfSpeech,
    this.definitions,
    this.pitch,
    this.alternates,
  });
}

class TokenDefinitionAlternate {
  final String? id;
  final String? term;

  const TokenDefinitionAlternate({
    this.id,
    this.term,
  });
}

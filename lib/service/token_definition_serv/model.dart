class TokenDefinitionAlternate {
  final String? id;
  final String? term;

  const TokenDefinitionAlternate({this.id, this.term});
}

class TokenDefinitionData {
  final int tokenId;
  final String surface;
  final String? kanjiForm;
  final String? hiraganaForm;
  final String? typeOfSpeech;
  final List<String>? definitions;
  final List<String>? pitch;
  final List<TokenDefinitionAlternate>? alternates;

  const TokenDefinitionData({
    required this.tokenId,
    required this.surface,
    this.kanjiForm,
    this.hiraganaForm,
    this.typeOfSpeech,
    this.definitions,
    this.pitch,
    this.alternates,
  });
}

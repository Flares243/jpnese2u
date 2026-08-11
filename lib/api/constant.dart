enum HeaderKeys {
  authorization(key: 'Authorization'),
  ;

  const HeaderKeys({required this.key});

  final String key;
}

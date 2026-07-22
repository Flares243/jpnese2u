import 'dart:io';

import 'package:flutter/services.dart';

import 'package:archive/archive.dart';
import 'package:mecab_for_dart/mecab_dart.dart';

import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/services/tokenize_serv/constant.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/extensions/list_ext.dart';

class TokenizeService implements ITokenizeService {
  TokenizeService({
    required this.appDirectories,
  });

  final AppDirectories appDirectories;

  Mecab? _tokenizer;
  DictionaryType _dictionaryType = DictionaryType.ipadic;

  @override
  Future<void> init(DictionaryType dictType) async {
    _dictionaryType = dictType;

    final dictPath = await _prepareDictionary(_dictionaryType);
    var mecab = await Mecab.create(dictDir: dictPath);

    _tokenizer = mecab;
  }

  @override
  Future<List<RawToken>> tokenize(String text) async {
    if (text.isEmpty) return [];

    final tokenizer = _tokenizer;
    if (tokenizer == null) {
      throw Exception('Tokenizer is not initialized. Call init() first.');
    }

    final tokens = tokenizer.parse(text);

    return switch (_dictionaryType) {
      DictionaryType.unidic =>
        tokens.map((t) => UnidicToken.fromMecab(t)).toList(),
      DictionaryType.ipadic =>
        tokens.map((t) => IpadicToken.fromMecab(t)).toList(),
    };
  }

  Future<String> _prepareDictionary(DictionaryType dictType) async {
    final appSupportDir = appDirectories.applicationSupportDirectory;

    final dictPath = [appSupportDir.path, dictType.name].toPath;
    final mecabrcFile = File([dictPath, 'mecabrc'].toPath);

    if (await mecabrcFile.exists()) {
      return dictPath;
    }

    await appSupportDir.create(recursive: true);

    final byteData = switch (dictType) {
      DictionaryType.unidic => await rootBundle.load(Assets.dictionary.unidic),
      DictionaryType.ipadic => await rootBundle.load(Assets.dictionary.ipadic),
    };

    final bytes = byteData.buffer.asUint8List();

    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;

      if (filename.contains('__MACOSX') ||
          filename
              .split('/')
              .any((part) => part.startsWith('._') || part == '.DS_Store')) {
        continue;
      }

      if (file.isFile) {
        final data = file.content;
        final outFile = File([appSupportDir.path, filename].toPath);

        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(data);
      }
    }

    return dictPath;
  }
}

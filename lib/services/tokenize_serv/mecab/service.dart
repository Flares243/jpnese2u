import 'dart:io';

import 'package:flutter/services.dart';

import 'package:archive/archive.dart';
import 'package:jpnese2u/services/tokenize_serv/mecab/addons.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';

import 'package:mecab_for_dart/mecab_dart.dart';

import 'package:jpnese2u/services/tokenize_serv/constant.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/util/app_dirents.dart';
import 'package:jpnese2u/util/extensions/list_ext.dart';

class MecabTokenizeService implements ITokenizeServ {
  final AppDirents appDirents;
  final DictionaryType dictionaryType;

  Mecab? _tokenizer;

  MecabTokenizeService({
    required this.appDirents,
    this.dictionaryType = .ipadic,
  });

  @override
  Future<bool> init() async {
    final dictPath = await _prepareDictionary(dictionaryType);
    var mecab = await Mecab.create(dictDir: dictPath);

    _tokenizer = mecab;

    return true;
  }

  @override
  bool get isAvailable => _tokenizer != null;

  @override
  Future<List<RawToken>> tokenize(String text) async {
    if (text.isEmpty) return [];

    final tokenizer = _tokenizer;
    if (tokenizer == null) {
      throw Exception('Tokenizer is not initialized. Call init() first.');
    }

    final tokens = tokenizer.parse(text);

    return switch (dictionaryType) {
      DictionaryType.unidic =>
        tokens.map(MecabUnidicTokenExt.fromMecab).toList(),
      DictionaryType.ipadic =>
        tokens.map(MecabIpadicTokenExt.fromMecab).toList(),
      _ => throw Exception('Unsupported dictionary type: $dictionaryType'),
    };
  }

  Future<String> _prepareDictionary(DictionaryType dictType) async {
    final appSupportDir = appDirents.appSupportDir;

    final dictPath = [appSupportDir.path, dictType.name].toPath;
    final mecabrcFile = File([dictPath, 'mecabrc'].toPath);

    if (await mecabrcFile.exists()) {
      return dictPath;
    }

    await appSupportDir.create(recursive: true);

    final byteData = switch (dictType) {
      DictionaryType.unidic => await rootBundle.load(''),
      DictionaryType.ipadic => await rootBundle.load(''),
      _ => throw Exception('Unsupported dictionary type: $dictType'),
    };

    final bytes = byteData.buffer.asUint8List();

    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;

      if (file.isFile) {
        final data = file.content;
        final outFile = File([appSupportDir.path, filename].toPath);

        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(data);
      }
    }

    return dictPath;
  }

  @override
  Future<void> dispose() async {
    _tokenizer?.dispose();
  }
}

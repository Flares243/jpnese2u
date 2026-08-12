import 'dart:io';

import 'package:flutter/services.dart';

import 'package:archive/archive.dart';
import 'package:jpnese2u/service/tokenize_serv/mecab/addons.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';

import 'package:mecab_for_dart/mecab_dart.dart';

import 'package:jpnese2u/service/tokenize_serv/constant.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/extension/list_ext.dart';

class MecabTokenizeService implements ITokenizeServ {
  final AppDirent _appDirents;
  final DictionaryType _dictionaryType;

  Mecab? _tokenizer;

  MecabTokenizeService({
    required this._appDirents,
    this._dictionaryType = .ipadic,
  });

  @override
  Future<bool> init() async {
    final dictPath = await _prepareDictionary(_dictionaryType);
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

    return switch (_dictionaryType) {
      DictionaryType.unidic => tokens.indexed.map((e) {
        final (id, token) = e;
        return MecabUnidicTokenExt.fromMecab(id, token);
      }).toList(),
      DictionaryType.ipadic => tokens.indexed.map((e) {
        final (id, token) = e;
        return MecabIpadicTokenExt.fromMecab(id, token);
      }).toList(),
      _ => throw Exception('Unsupported dictionary type: $_dictionaryType'),
    };
  }

  Future<String> _prepareDictionary(DictionaryType dictType) async {
    final appSupportDir = _appDirents.appSupportDir;

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

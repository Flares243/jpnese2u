import 'dart:async';

import 'package:flutter/services.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/addons.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/util/app_dirent.dart';

import 'package:jpnese2u/util/async_guard.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';
import 'package:sudachi_dart/sudachi_dart.dart';

class SudachiTokenizeServ implements ITokenizeServ {
  SudachiDictionary? _dictionary;
  SudachiTokenizer? _tokenizer;

  SudachiTokenizeServ();

  @override
  bool get isAvailable => _dictionary != null && _tokenizer != null;

  @override
  Future<bool> init() async {
    final sudachiConfigFile = AppDirent.getInstance.sudachiConfigFile;

    if (!await sudachiConfigFile.exists()) {
      final configData = await rootBundle.loadString(
        Assets.sudachi.defaultSudachi,
      );
      await sudachiConfigFile.writeAsString(configData, flush: true);
    }

    _dictionary = await _initDictionary();
    if (_dictionary == null) return false;

    _tokenizer = await _initTokenizer();
    if (_tokenizer == null) return false;

    return true;
  }

  @override
  Future<List<RawToken>> tokenize(String text) async {
    final tokens = await asyncGuard(() async {
      final result = await _tokenizer!.tokenize(text, mode: .b);

      for (var element in result) {
        print(
          'surface: ${element.surface}, partOfSpeech: ${element.partOfSpeech}, normalizedForm: ${element.normalizedForm}, dictionaryForm: ${element.dictionaryForm}, readingForm: ${element.readingForm}',
        );
      }

      return result.mergeJapanesePredicates().indexed.map((e) {
        final (id, morpheme) = e;
        return SudachiToken.fromMorpheme(id, morpheme);
      }).toList();
    });

    return tokens.fold(
      onData: (data) => data,
      orElse: () => [],
    );
  }

  @override
  Future<void> dispose() async {
    _tokenizer?.dispose();
    _tokenizer = null;
    _dictionary?.dispose();
    _dictionary = null;
  }

  Future<SudachiDictionary?> _initDictionary() async {
    final snapshot = await asyncGuard(() async {
      final dictionary = SudachiDictionary();
      await dictionary.init(
        configPath: sudachiBaseConfig.configPath,
        dictionaryPath: sudachiBaseConfig.dictionaryPath,
      );

      return dictionary;
    });

    return snapshot.data;
  }

  Future<SudachiTokenizer?> _initTokenizer() async {
    final snapshot = await asyncGuard(() async {
      final tokenizer = SudachiTokenizer();
      await tokenizer.init(_dictionary!);
      return tokenizer;
    });

    return snapshot.data;
  }
}

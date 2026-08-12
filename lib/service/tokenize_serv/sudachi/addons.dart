import 'dart:io';

import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:path/path.dart' as path;

const kSudachiConfigFileName = 'sudachi.json';
const kSudachiDictionaryFileName = 'sudachi.dic';

extension SudachiAppDirentsExt on AppDirent {
  File get sudachiConfigFile => File(
    path.join(appSupportDir.path, kSudachiConfigFileName),
  );

  File get sudachiDictionaryFile => File(
    path.join(appSupportDir.path, kSudachiDictionaryFileName),
  );
}

extension SudachiCaptureTokenDataExt on SudachiToken {
  CaptureTokenData toCaptureTokenData([int? id]) => CaptureTokenData(
    id: id ?? tokenId,
    surface: surface,
    pos: pos,
    reading: readingForm,
  );
}

SudachiConfig get sudachiBaseConfig => SudachiConfig(
  configPath: AppDirent.getInstance.sudachiConfigFile.path,
  dictionaryPath: AppDirent.getInstance.sudachiDictionaryFile.path,
);

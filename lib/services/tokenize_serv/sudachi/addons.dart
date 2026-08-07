import 'dart:io';

import 'package:jpnese2u/services/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/app_dirents.dart';
import 'package:path/path.dart' as path;

const kSudachiConfigFileName = 'sudachi.json';
const kSudachiDictionaryFileName = 'sudachi.dic';

extension SudachiAppDirentsExt on AppDirents {
  File get sudachiConfigFile => File(
    path.join(appSupportDir.path, kSudachiConfigFileName),
  );

  File get sudachiDictionaryFile => File(
    path.join(appSupportDir.path, kSudachiDictionaryFileName),
  );
}

extension SudachiCaptureTokenDataExt on SudachiToken {
  CaptureTokenData toCaptureTokenData(int index) => CaptureTokenData(
    id: index,
    surface: surface,
    pos: pos,
    reading: readingForm,
  );
}

SudachiConfig get sudachiBaseConfig => SudachiConfig(
  configPath: AppDirents.getInstance.sudachiConfigFile.path,
  dictionaryPath: AppDirents.getInstance.sudachiDictionaryFile.path,
);

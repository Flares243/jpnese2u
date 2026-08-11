import 'dart:io';

import 'package:jpnese2u/main.dart';
import 'package:path_provider/path_provider.dart';

class AppDirent {
  static AppDirent get getInstance => getIt<AppDirent>();

  AppDirent();

  late final Directory temporaryDir;
  late final Directory appSupportDir;
  late final Directory appDocumentsDir;

  Future<void> init() async {
    await _initTemporaryDir();
    await _initApplicationSupportDir();
    await _initApplicationDocumentsDirectory();
  }

  Future<void> _initTemporaryDir() async {
    final temporaryDirectory = await getTemporaryDirectory();
    final temporaryDirectoryExists = await temporaryDirectory.exists();
    if (!temporaryDirectoryExists) {
      await temporaryDirectory.create(recursive: true);
    }
    temporaryDir = temporaryDirectory;
  }

  Future<void> _initApplicationSupportDir() async {
    final applicationSupportDirectory = await getApplicationSupportDirectory();
    final applicationSupportDirectoryExists = await applicationSupportDirectory
        .exists();
    if (!applicationSupportDirectoryExists) {
      await applicationSupportDirectory.create(recursive: true);
    }
    appSupportDir = applicationSupportDirectory;
  }

  Future<void> _initApplicationDocumentsDirectory() async {
    final applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final applicationDocumentsDirectoryExists =
        await applicationDocumentsDirectory.exists();
    if (!applicationDocumentsDirectoryExists) {
      await applicationDocumentsDirectory.create(recursive: true);
    }
    appDocumentsDir = applicationDocumentsDirectory;
  }
}

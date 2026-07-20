import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDirectories {
  AppDirectories();

  late final Directory temporaryDirectory;
  late final Directory applicationSupportDirectory;

  Future<void> init() async {
    final temporaryDirectory = await getTemporaryDirectory();
    this.temporaryDirectory = temporaryDirectory;

    final applicationSupportDirectory = await getApplicationSupportDirectory();
    this.applicationSupportDirectory = applicationSupportDirectory;
  }
}

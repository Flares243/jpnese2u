import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/models/capture_info.dart';
import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/ui/windows/capture_info/capture_info_window.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:window_manager/window_manager.dart';

class WindowFactoryServ {
  WindowFactoryServ();

  Future<void> initCaptureInfoWindow(CaptureInfo state) async {
    final args = ScreenshotWindowArguments(
      type: WindowType.screenshot,
      captureInfo: state,
    );

    await WindowController.create(
      WindowConfiguration(arguments: jsonEncode(args.toJson())),
    );
  }

  static void showCaptureInfoWindow(WindowController windowController) async {
    final screenshotArgs = ScreenshotWindowArguments.fromJson(
      jsonDecode(windowController.arguments) as Map<String, dynamic>,
    );

    windowManager.waitUntilReadyToShow(
      WindowOptions(size: Size(800, 600)),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );

    final appDirectories = AppDirectories();
    await appDirectories.init();

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AppDirectories>(
            create: (_) => appDirectories,
          ),
          RepositoryProvider<CaptureInfo>(
            create: (_) => screenshotArgs.captureInfo,
          ),
        ],
        child: CaptureInfoWindow(),
      ),
    );
  }
}

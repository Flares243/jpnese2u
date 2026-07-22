import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/models/capture_info.dart';
import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/theme/app_theme.dart';
import 'package:jpnese2u/ui/capture_info/view.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/constant/constant.dart';

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
      WindowOptions(size: kDefaultWindowSize),
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: CaptureInfoScreen(),
        ),
      ),
    );
  }
}

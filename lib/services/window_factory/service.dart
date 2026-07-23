import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/services/window_factory/model.dart';
import 'package:jpnese2u/theme/app_theme.dart';
import 'package:jpnese2u/ui/capture_translate/view.dart';
import 'package:jpnese2u/util/constant/constant.dart';

class WindowFactoryServ {
  const WindowFactoryServ();

  Future<bool> routing() async {
    final windowController = await WindowController.fromCurrentEngine();

    if (windowController.arguments.isNotEmpty) {
      final windowArgs = WindowArguments.fromJson(
        jsonDecode(windowController.arguments) as Map<String, dynamic>,
      );
      final windowType = windowArgs.type;

      switch (windowType) {
        case WindowType.screenshot:
          _showCaptureTranslateWindow(windowController);
          return true;
      }
    }

    return false;
  }

  Future<void> showCaptureTranslateWindow(CapturedData data) async {
    final args = CaptureTranslateWindowArguments(
      type: WindowType.screenshot,
      capturedData: data,
    );

    await WindowController.create(
      WindowConfiguration(arguments: jsonEncode(args.toJson())),
    );
  }

  void _showCaptureTranslateWindow(
    WindowController windowController,
  ) async {
    final screenshotArgs = CaptureTranslateWindowArguments.fromJson(
      jsonDecode(windowController.arguments) as Map<String, dynamic>,
    );

    windowManager.waitUntilReadyToShow(
      WindowOptions(size: kDefaultWindowSize, center: true),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );

    runApp(
      RepositoryProvider(
        create: (_) => windowController,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: CaptureTranslateScreen(
            capturedData: screenshotArgs.capturedData,
          ),
        ),
      ),
    );
  }
}

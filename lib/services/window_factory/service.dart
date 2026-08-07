import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/services/download_serv/service.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/sudachi/service.dart';

import 'package:jpnese2u/ui/capture_translate/deps_provider.dart';
import 'package:jpnese2u/ui/settings/deps_provider.dart';
import 'package:jpnese2u/ui/settings/view.dart';
import 'package:jpnese2u/util/app_dirents.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/services/window_factory/model.dart';
import 'package:jpnese2u/theme/app_theme.dart';
import 'package:jpnese2u/ui/capture_translate/view.dart';
import 'package:jpnese2u/util/constant/constant.dart';

class WindowFactoryServ {
  static WindowFactoryServ get getInstance => getIt<WindowFactoryServ>();

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
        case WindowType.settings:
          _showSettingsWindow(windowController);
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

  Future<void> showSettingsWindow() async {
    final args = WindowArguments(type: WindowType.settings);

    await WindowController.create(
      WindowConfiguration(arguments: jsonEncode(args.toJson())),
    );
  }

  void _showCaptureTranslateWindow(WindowController windowController) async {
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

    final appDirents = AppDirents();
    final ocrServ = IOCRService.platformInstance();
    final tokenizer = SudachiTokenizeServ(appDirents: appDirents);

    getIt
      ..registerSingleton<AppDirents>(appDirents)
      ..registerSingleton<IOCRService>(ocrServ)
      ..registerSingleton<ITokenizeServ>(tokenizer);

    await appDirents.init();
    await tokenizer.init();

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: CaptureTranslateDepsProvider(
          capturedData: screenshotArgs.capturedData,
          windowController: windowController,
          child: CaptureTranslateScreen(),
        ),
      ),
    );
  }

  void _showSettingsWindow(WindowController windowController) async {
    windowManager.waitUntilReadyToShow(
      const WindowOptions(size: Size(420, 520), center: true),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );

    final appDirents = AppDirents();
    final permissionServ = IPermissionServ.platformInstance();

    getIt
      ..registerSingleton<AppDirents>(appDirents)
      ..registerSingleton<IPermissionServ>(permissionServ)
      ..registerSingleton<DownloaderServ>(
        DownloaderServ(appDirents: appDirents),
        dispose: (param) => param.dispose(),
      );

    await appDirents.init();
    await permissionServ.requestScreenRecord();

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: SettingsDepsProvider(
          child: const SettingsScreen(),
        ),
      ),
    );
  }
}

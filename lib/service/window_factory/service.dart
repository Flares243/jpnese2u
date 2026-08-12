import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jpnese2u/api/renshuu_api/api.dart';
import 'package:jpnese2u/api/renshuu_api/dio.dart';
import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/repository/shared_pref_repo/secure_storage.dart';
import 'package:jpnese2u/service/capture_serv/interface.dart';
import 'package:jpnese2u/service/capture_serv/service.dart';
import 'package:jpnese2u/service/download_serv/service.dart';
import 'package:jpnese2u/service/ocr_serv/interface.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/renshuu/service.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/service.dart';
import 'package:jpnese2u/service/user_session/service.dart';
import 'package:jpnese2u/ui/root_tray/view.dart';

import 'package:jpnese2u/ui/setting/view.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/service/window_factory/constant.dart';
import 'package:jpnese2u/service/window_factory/model.dart';
import 'package:jpnese2u/theme/app_theme.dart';
import 'package:jpnese2u/ui/capture_translate/view.dart';
import 'package:jpnese2u/util/constant/constant.dart';

class WindowFactoryServ {
  static WindowFactoryServ get getInstance => getIt<WindowFactoryServ>();

  const WindowFactoryServ();

  Future<void> routing() async {
    final windowController = await WindowController.fromCurrentEngine();

    if (windowController.arguments.isNotEmpty) {
      final windowArgs = WindowArguments.fromJson(
        jsonDecode(windowController.arguments) as Map<String, dynamic>,
      );
      final windowType = windowArgs.type;

      switch (windowType) {
        case WindowType.screenshot:
          _showCaptureTranslateWindow(windowController);

        case WindowType.settings:
          _showSettingsWindow(windowController);
      }
    } else {
      _showRootTray();
    }
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
    final args = const WindowArguments(type: WindowType.settings);

    await WindowController.create(
      WindowConfiguration(arguments: jsonEncode(args.toJson())),
    );
  }

  Future<void> _showRootTray() async {
    windowManager.waitUntilReadyToShow(null, windowManager.hide);

    final appDirents = AppDirent();
    final permissionServ = IPermissionServ.platformInstance();
    final tokenizer = SudachiTokenizeServ();

    getIt
      ..registerSingleton<AppDirent>(appDirents)
      ..registerSingleton<IPermissionServ>(permissionServ)
      ..registerSingleton<ITokenizeServ>(
        tokenizer,
        dispose: (param) => param.dispose(),
      )
      ..registerSingleton<ICaptureService>(
        CaptureServ(appDirents: appDirents),
      );

    await appDirents.init();
    await permissionServ.requestScreenRecord();
    await tokenizer.init();

    await RootTray().initialize();
  }

  void _showCaptureTranslateWindow(WindowController windowController) async {
    final screenshotArgs = CaptureTranslateWindowArguments.fromJson(
      jsonDecode(windowController.arguments) as Map<String, dynamic>,
    );

    windowManager.waitUntilReadyToShow(
      const WindowOptions(size: kDefaultWindowSize, center: true),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );

    final appDirents = AppDirent();
    final ocrServ = IOCRService.platformInstance();
    final tokenizer = SudachiTokenizeServ();

    final secureSharedPrefRepo = const SecureSharedPrefRepo(
      storage: FlutterSecureStorage(),
    );
    final userSessionService = UserSessionService(
      secureSharedPrefRepo: secureSharedPrefRepo,
    );

    getIt
      ..registerSingleton<AppDirent>(appDirents)
      ..registerSingleton<IOCRService>(ocrServ)
      ..registerSingleton<ITokenizeServ>(
        tokenizer,
        dispose: (param) => param.dispose(),
      )
      ..registerSingleton<UserSessionService>(userSessionService);

    await appDirents.init();
    await tokenizer.init();
    await userSessionService.init();

    final tokenDefinitionServ = RenshuuTokenDefinitionServ(
      api: RenshuuApi(
        RenshuuDio(
          renshuuApiKey: userSessionService.userSession.renshuuApiKey!,
        ),
      ),
    );

    getIt.registerSingleton<ITokenDefinitionServ>(tokenDefinitionServ);

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: CaptureTranslateScreen(
          capturedData: screenshotArgs.capturedData,
          windowController: windowController,
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

    final appDirents = AppDirent();
    final permissionServ = IPermissionServ.platformInstance();

    final secureSharedPrefRepo = const SecureSharedPrefRepo(
      storage: FlutterSecureStorage(),
    );
    final userSessionService = UserSessionService(
      secureSharedPrefRepo: secureSharedPrefRepo,
    );

    getIt
      ..registerSingleton<AppDirent>(appDirents)
      ..registerSingleton<IPermissionServ>(permissionServ)
      ..registerSingleton<DownloaderServ>(
        DownloaderServ(appDirents: appDirents),
        dispose: (param) => param.dispose(),
      )
      ..registerSingleton<UserSessionService>(userSessionService);

    await appDirents.init();
    await permissionServ.requestScreenRecord();
    await userSessionService.init();

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SettingScreen(),
      ),
    );
  }
}

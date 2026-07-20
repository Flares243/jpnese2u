import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/services/window_serv/constant.dart';
import 'package:jpnese2u/ui/my_app.dart';
import 'package:jpnese2u/ui/root_deps.dart';
import 'package:jpnese2u/ui/windows/screenshot/screenshot_window.dart';
import 'package:jpnese2u/util/app_directories.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  final windowController = await WindowController.fromCurrentEngine();

  if (windowController.arguments.isNotEmpty) {
    final windowArgs = WindowArguments.fromJson(
      jsonDecode(windowController.arguments) as Map<String, dynamic>,
    );
    final windowType = windowArgs.type;

    switch (windowType) {
      case WindowType.screenshot:
        _showScreenshotWindow(windowController);
        return;
    }
  }

  await windowManager.hide();

  runApp(RootDependencies(child: const MyApp()));
}

void _showScreenshotWindow(WindowController windowController) async {
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
        RepositoryProvider<ScreenshotState>(
          create: (_) => screenshotArgs.screenshotData,
        ),
      ],
      child: ScreenshotWindow(),
    ),
  );
}

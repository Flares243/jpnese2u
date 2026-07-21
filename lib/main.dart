import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/ui/my_app.dart';
import 'package:jpnese2u/ui/root_deps.dart';

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
        WindowFactoryServ.showCaptureInfoWindow(windowController);
        return;
    }
  }

  const options = WindowOptions(
    size: Size(900, 700),
    center: true,
    titleBarStyle: .normal,
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.hide();
    await windowManager.setSkipTaskbar(true);
  });

  runApp(RootDependencies(child: const MyApp()));
}

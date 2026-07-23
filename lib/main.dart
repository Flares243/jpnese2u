import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/ui/my_app.dart';
import 'package:jpnese2u/ui/root_deps.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final windowFactoryServ = WindowFactoryServ();
  final isRouted = await windowFactoryServ.routing();

  if (isRouted) return;

  windowManager.waitUntilReadyToShow(null, () async {
    await windowManager.hide();
  });

  runApp(
    RootDependencies(
      windowFactoryServ: windowFactoryServ,
      child: const MyApp(),
    ),
  );
}

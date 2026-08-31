import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:jpnese2u/service/window_factory/service.dart';
import 'package:window_manager/window_manager.dart';

final getIt = GetIt.instance;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();

  await windowManager.ensureInitialized();

  final windowFactoryServ = const WindowFactoryServ();
  getIt.registerSingleton<WindowFactoryServ>(windowFactoryServ);

  await windowFactoryServ.routing();
}

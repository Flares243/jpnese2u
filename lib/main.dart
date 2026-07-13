import 'package:flutter/widgets.dart';

import 'package:window_manager/window_manager.dart';

import 'package:jpnese2u/ui/app.dart';
import 'package:jpnese2u/ui/root_deps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  // await windowManager.hide();
  await windowManager.setTitleBarStyle(
    TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  runApp(RootDependencies(child: MyApp()));
}

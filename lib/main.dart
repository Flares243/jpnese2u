import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/capture_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/sudachi/service.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/ui/root_tray/view.dart';
import 'package:jpnese2u/util/app_dirents.dart';
import 'package:window_manager/window_manager.dart';

final getIt = GetIt.instance;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  final windowFactoryServ = WindowFactoryServ();
  getIt.registerSingleton<WindowFactoryServ>(windowFactoryServ);

  final handled = await windowFactoryServ.routing();
  if (handled) return;

  windowManager.waitUntilReadyToShow(null, windowManager.hide);

  final appDirents = AppDirents();
  final permissionServ = IPermissionServ.platformInstance();
  final tokenizer = SudachiTokenizeServ(appDirents: appDirents);

  getIt
    ..registerSingleton<AppDirents>(appDirents)
    ..registerSingleton<IPermissionServ>(permissionServ)
    ..registerSingleton<ITokenizeServ>(tokenizer)
    ..registerSingleton<ICaptureService>(
      CaptureServ(appDirents: appDirents),
    );

  await appDirents.init();
  await permissionServ.requestScreenRecord();
  await tokenizer.init();

  await RootTray().initialize();
}

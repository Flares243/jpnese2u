import 'package:flutter/widgets.dart';

import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/constant.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
import 'package:jpnese2u/services/window_serv/entities_controller.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isInitialized = false;

  IPermissionServ? _permissionServ;
  TrayServ? _trayServ;
  WindowEntitiesCtrller? _windowEntitiesCtrller;
  ITokenizeService? _tokenizeServ;
  AppDirectories? _appDirectories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _permissionServ = context.iPermissionServ;
      _trayServ = context.trayServ;
      _windowEntitiesCtrller = context.windowEntitiesCtrller;
      _tokenizeServ = context.iTokenizeServ;
      _appDirectories = context.appDirectories;

      _init();
    }
  }

  Future<void> _init() async {
    await _appDirectories?.init();
    await _permissionServ?.requestScreenRecord();

    await _tokenizeServ?.init(DictionaryType.ipadic);
    _windowEntitiesCtrller?.init();

    await _trayServ?.init();

    _isInitialized = true;
  }

  @override
  void dispose() {
    _trayServ?.dispose();
    _windowEntitiesCtrller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

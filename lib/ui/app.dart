import 'package:flutter/widgets.dart';

import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _permissionServ = context.permissionServ;
      _trayServ = context.trayServ;

      _init();
    }
  }

  @override
  void dispose() {
    _trayServ?.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _permissionServ?.requestScreenRecord();
    await _trayServ?.init();

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

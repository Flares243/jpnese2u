import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/capture_serv/service.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/ocr_serv/macos.dart';
import 'package:jpnese2u/services/ocr_serv/winos.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/macos_service.dart';
import 'package:jpnese2u/services/permission_serv/winos_service.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/service.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/constant/constant.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class RootDependencies extends StatelessWidget {
  const RootDependencies({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDirectories>(
          create: (_) => AppDirectories(),
        ),
        RepositoryProvider<WindowFactoryServ>(
          create: (_) => WindowFactoryServ(),
        ),
        RepositoryProvider<IPermissionServ>(
          create: _getPermissionServ,
        ),
        RepositoryProvider<IOCRService>(
          create: _getOCRServ,
        ),
        RepositoryProvider<ITokenizeService>(
          create: (context) => TokenizeService(
            appDirectories: context.appDirectories,
          ),
        ),
        RepositoryProvider<ICaptureService>(
          create: (context) => CaptureServ(
            appDirectories: context.appDirectories,
            ocrServ: context.iOCRServ,
            tokenizeServ: context.iTokenizeServ,
          ),
        ),
        RepositoryProvider<TrayServ>(
          create: (context) => TrayServ(
            permissionServ: context.iPermissionServ,
            captureServ: context.iCaptureServ,
            windowFactoryServ: context.windowFactoryServ,
          ),
        ),
      ],
      child: child,
    );
  }

  IOCRService _getOCRServ(_) {
    if (kIsMacOS) {
      return MacOSOCRService();
    }

    if (kIsWindows) {
      return WinOSOCRService();
    }

    throw UnimplementedError();
  }

  IPermissionServ _getPermissionServ(_) {
    if (kIsMacOS) {
      return MacOSPermissionServ();
    }

    if (kIsWindows) {
      return WinOSPermissionServ();
    }

    throw UnimplementedError();
  }
}

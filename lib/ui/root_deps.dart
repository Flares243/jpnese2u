import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/ocr_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/macos_service.dart';
import 'package:jpnese2u/services/permission_serv/winos_service.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/service.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
import 'package:jpnese2u/services/window_serv/entities_controller.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/constant/constant.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class RootDependencies extends StatelessWidget {
  const RootDependencies({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenshotCubit>(
      create: (_) => ScreenshotCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AppDirectories>(
            create: (_) => AppDirectories(),
          ),
          RepositoryProvider<IPermissionServ>(
            create: (_) {
              if (kIsMacOS) {
                return MacOSPermissionServ();
              }

              if (kIsWindows) {
                return WinOSPermissionServ();
              }

              throw UnimplementedError();
            },
          ),
          RepositoryProvider<IOCRService>(
            create: (_) => OCRService(),
          ),
          RepositoryProvider<WindowEntitiesCtrller>(
            create: (context) => WindowEntitiesCtrller(
              screenshotCubit: context.read<ScreenshotCubit>(),
            ),
          ),
          RepositoryProvider<ITokenizeService>(
            create: (context) => TokenizeService(
              appDirectories: context.appDirectories,
            ),
          ),
          RepositoryProvider<TrayServ>(
            create: (context) => TrayServ(
              appDirectories: context.appDirectories,
              permissionServ: context.iPermissionServ,
              screenshotCubit: context.read<ScreenshotCubit>(),
              ocrServ: context.iOCRServ,
              tokenizeServ: context.iTokenizeServ,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

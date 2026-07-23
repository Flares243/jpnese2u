import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/capture_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class RootDependencies extends StatelessWidget {
  const RootDependencies({
    super.key,
    required this.child,
    required this.windowFactoryServ,
  });

  final Widget child;
  final WindowFactoryServ windowFactoryServ;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDirectories>(
          create: (_) => AppDirectories(),
        ),
        RepositoryProvider<IPermissionServ>(
          create: (_) => IPermissionServ(),
        ),
        RepositoryProvider<ICaptureService>(
          create: (context) => CaptureServ(
            appDirectories: context.appDirectories,
          ),
        ),
        RepositoryProvider<WindowFactoryServ>(
          create: (_) => windowFactoryServ,
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
}

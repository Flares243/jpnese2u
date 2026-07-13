import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/services/ocr_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/service.dart';
import 'package:jpnese2u/services/tokenize_serv/service.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';

class RootDependencies extends StatelessWidget {
  const RootDependencies({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenshotCubit>(
      create: (_) => ScreenshotCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IPermissionServ>(
            create: (_) => PermissionServ(),
          ),
          RepositoryProvider<OCRService>(
            create: (_) => OCRService(),
          ),
          RepositoryProvider<TokenizeService>(
            create: (_) => TokenizeService(),
          ),
          RepositoryProvider<TrayServ>(
            create: (context) => TrayServ(
              permissionServ: context.read<IPermissionServ>(),
              screenshotCubit: context.read<ScreenshotCubit>(),
              ocrServ: context.read<OCRService>(),
              tokenizeServ: context.read<TokenizeService>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/util/app_directories.dart';

extension BuildContextExt on BuildContext {
  IPermissionServ get iPermissionServ => read<IPermissionServ>();
  ITokenizeService get iTokenizeServ => read<ITokenizeService>();
  IOCRService get iOCRServ => read<IOCRService>();
  ICaptureService get iCaptureServ => read<ICaptureService>();

  TrayServ get trayServ => read<TrayServ>();
  WindowFactoryServ get windowFactoryServ => read<WindowFactoryServ>();
  AppDirectories get appDirectories => read<AppDirectories>();
}

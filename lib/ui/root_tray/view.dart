import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jpnese2u/service/capture_serv/interface.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/service/user_session/service.dart';
import 'package:jpnese2u/service/window_factory/constant.dart';
import 'package:jpnese2u/service/window_factory/service.dart';
import 'package:jpnese2u/ui/root_tray/constant.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/util/extension/generic_ext.dart';
import 'package:tray_manager/tray_manager.dart';

class RootTray with TrayListener {
  Future<void> initialize() async {
    trayManager.addListener(this);

    await trayManager.setIcon(Assets.images.trayIcon.path);
    await trayManager.setToolTip('Japanese2U');

    await _loadContextMenu();

    kRootTrayChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case RootTrayMethod.reloadTokenizer:
          await ITokenizeServ.getInstance.init();
          _loadContextMenu();
          break;

        case RootTrayMethod.reloadUserSession:
          await UserSessionService.getInstance.init();
          _loadContextMenu();
          break;

        case RootTrayMethod.reloadTray:
          _loadContextMenu();
          break;
      }
    });
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  Future<void> _loadContextMenu() async {
    final permissionServ = IPermissionServ.getInstance;
    final tokenizerServ = ITokenizeServ.getInstance;
    final userSessionServ = UserSessionService.getInstance;

    final screenRecordPermission = await permissionServ.checkScreenRecord();
    final canRecordScreen = screenRecordPermission == .granted;
    final haveRenshuuApiKey = userSessionServ.userSession.renshuuApiKey
        .onNull('')
        .isNotEmpty;

    final requirements =
        canRecordScreen && tokenizerServ.isAvailable && haveRenshuuApiKey;

    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(
            key: MenuItemEnum.capture.name,
            label: MenuItemEnum.capture.label,
            disabled: !requirements,
            onClick: (_) => _onCapture(),
          ),
          MenuItem(
            key: MenuItemEnum.settings.name,
            label: MenuItemEnum.settings.label,
            onClick: (_) => WindowFactoryServ.getInstance.showSettingsWindow(),
          ),
          if (!kReleaseMode)
            MenuItem(
              key: MenuItemEnum.debug.name,
              label: MenuItemEnum.debug.label,
              onClick: (_) {
                // const FlutterSecureStorage().deleteAll();

                print('Can Record Screen: $canRecordScreen');
                print('Tokenizer Available: ${tokenizerServ.isAvailable}');
                print(
                  'UserSession: ${UserSessionService.getInstance.userSession.toJson()}',
                );
              },
            ),
          MenuItem.separator(),
          MenuItem(
            key: MenuItemEnum.exit.name,
            label: MenuItemEnum.exit.label,
            onClick: (_) => _onExit(),
          ),
        ],
      ),
    );
  }

  Future<void> _onCapture() async {
    final capturedData = await ICaptureService.getInstance.capture();
    if (capturedData == null) return;

    WindowFactoryServ.getInstance.showCaptureTranslateWindow(capturedData);
  }

  Future<void> _onExit() async {
    trayManager.removeListener(this);

    await ServicesBinding.instance.exitApplication(AppExitType.required);
    exit(0);
  }
}

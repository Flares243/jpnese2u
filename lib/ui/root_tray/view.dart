import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:jm_dict/jm_dict.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/service/capture_serv/interface.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/service/user_session/service.dart';
import 'package:jpnese2u/service/window_factory/constant.dart';
import 'package:jpnese2u/service/window_factory/service.dart';
import 'package:jpnese2u/ui/root_tray/constant.dart';
import 'package:tray_manager/tray_manager.dart';

class RootTray with TrayListener {
  HotKey? _captureHotKey;

  Future<void> initialize() async {
    trayManager.addListener(this);

    await trayManager.setIcon(Assets.images.trayIcon.path);
    await trayManager.setToolTip('Japanese2U');

    await _loadContextMenu();
    await _initCommunicateTunnel();
    await _initGlobalHotkey();
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  Future<void> _initCommunicateTunnel() async {
    await kRootTrayChannel.setMethodCallHandler((call) async {
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

  Future<void> _initGlobalHotkey() async {
    _captureHotKey = HotKey(
      key: PhysicalKeyboardKey.f2,
      modifiers: [.meta],
      scope: .system,
    );

    await hotKeyManager.register(
      _captureHotKey!,
      keyUpHandler: (_) => _onCapture(),
    );
  }

  Future<void> _loadContextMenu() async {
    final canCapture = await _canPerformCapture;

    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(
            key: MenuItemEnum.capture.name,
            label: MenuItemEnum.capture.label,
            disabled: !canCapture,
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
              onClick: (_) async {
                final dict = JMDict();
                await dict.initFromAsset(
                  assetPath: Assets.dictionaries.jMdictENG,
                );
                dict.removeCachedFiles();
                dict.clearObjectBoxData();
                dict.close();

                final screenRecordPermission = await IPermissionServ.getInstance
                    .checkScreenRecord();
                print(
                  'Can Record Screen: ${screenRecordPermission == .granted}',
                );
                print(
                  'Tokenizer Available: ${ITokenizeServ.getInstance.isAvailable}',
                );
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
    if (!await _canPerformCapture) return;

    final capturedData = await ICaptureService.getInstance.capture();
    if (capturedData == null) return;

    WindowFactoryServ.getInstance.showCaptureTranslateWindow(capturedData);
  }

  Future<void> _onExit() async {
    if (_captureHotKey != null) {
      await hotKeyManager.unregister(_captureHotKey!);
      _captureHotKey = null;
    }

    trayManager.removeListener(this);

    await ServicesBinding.instance.exitApplication(AppExitType.required);
    exit(0);
  }

  Future<bool> get _canPerformCapture async {
    final permissionServ = IPermissionServ.getInstance;
    final tokenizerServ = ITokenizeServ.getInstance;

    final screenRecordPermission = await permissionServ.checkScreenRecord();
    final canRecordScreen = screenRecordPermission == .granted;

    return canRecordScreen && tokenizerServ.isAvailable;
  }
}

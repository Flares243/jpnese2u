import 'dart:io';

import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/download_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/window_factory/constant.dart';
import 'package:jpnese2u/services/window_factory/service.dart';
import 'package:jpnese2u/ui/root_tray/constant.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
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
      }
    });
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  Future<void> _loadContextMenu() async {
    final permissionServ = IPermissionServ.getInstance;
    final tokenizer = ITokenizeServ.getInstance;

    final screenRecordPermission = await permissionServ.checkScreenRecord();
    final canRecordScreen = screenRecordPermission == .granted;

    final requirements = canRecordScreen && tokenizer.isAvailable;

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
          MenuItem(
            key: MenuItemEnum.debug.name,
            label: MenuItemEnum.debug.label,
            onClick: (_) {
              print(
                tokenizer.isAvailable
                    ? 'Sudachi tokenizer is available'
                    : 'Sudachi tokenizer is not available',
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

  void _onExit() {
    DownloaderServ.getInstance.dispose();
    trayManager.removeListener(this);
    exit(0);
  }
}

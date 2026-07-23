import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tray_manager/tray_manager.dart';

import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/constant.dart';
import 'package:jpnese2u/services/window_factory/service.dart';

class TrayServ with TrayListener {
  const TrayServ({
    required this.permissionServ,
    required this.captureServ,
    required this.windowFactoryServ,
  });

  final IPermissionServ permissionServ;
  final ICaptureService captureServ;
  final WindowFactoryServ windowFactoryServ;

  Future<void> init() async {
    trayManager.addListener(this);

    await trayManager.setIcon(Assets.images.trayIcon.path);
    await trayManager.setToolTip('Japanese2U');

    _setContextMenu(null);
  }

  void dispose() {
    trayManager.removeListener(this);
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayMenuItemClick(MenuItem menuItem) async {
    final clickedMenuEnum = MenuItemEnum.fromName(menuItem.key);
    if (clickedMenuEnum == null) return;

    switch (clickedMenuEnum) {
      case MenuItemEnum.capture:
        _onCapture();
        break;

      case MenuItemEnum.debug:
        final controllers = await WindowController.getAll();

        for (var controller in controllers) {
          print(
            'Window ID: ${controller.windowId}, Arguments: ${controller.arguments}',
          );
        }
        break;

      case MenuItemEnum.exit:
        _onExit();
        break;
    }
  }

  void _setContextMenu(_) async {
    final screenRecordPermission = await permissionServ.checkScreenRecord();

    print('Screen record permission: $screenRecordPermission');

    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(
            key: MenuItemEnum.capture.name,
            label: MenuItemEnum.capture.label,
            toolTip: screenRecordPermission != PermissionStatus.granted
                ? 'Screen record permission is not granted'
                : null,
            disabled: screenRecordPermission != PermissionStatus.granted,
          ),
          MenuItem(
            key: MenuItemEnum.debug.name,
            label: MenuItemEnum.debug.label,
          ),
          MenuItem.separator(),
          MenuItem(
            key: MenuItemEnum.exit.name,
            label: MenuItemEnum.exit.label,
          ),
        ],
      ),
    );
  }

  Future<void> _onCapture() async {
    final capturedData = await captureServ.capture();
    if (capturedData == null) return;

    windowFactoryServ.showCaptureTranslateWindow(capturedData);
  }

  void _onExit() {
    exit(0);
  }
}

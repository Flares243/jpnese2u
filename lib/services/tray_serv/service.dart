import 'dart:io';

import 'package:kuromoji/kuromoji.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:tray_manager/tray_manager.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/constant.dart';
import 'package:jpnese2u/util/merged_stream.dart';

class TrayServ with TrayListener {
  TrayServ({
    required this.permissionServ,
    required this.screenshotCubit,
    required this.ocrServ,
    required this.tokenizeServ,
  }) {
    _menuChangeStream = MergedStream([
      screenshotCubit.stream,
    ]);
  }

  final IPermissionServ permissionServ;
  final ScreenshotCubit screenshotCubit;
  final IOCRService ocrServ;
  final ITokenizeService tokenizeServ;

  late final MergedStream _menuChangeStream;

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

      case MenuItemEnum.edit:
        break;

      case MenuItemEnum.save:
        break;

      case MenuItemEnum.exit:
        _onExit();
        break;
    }
  }

  Future<void> init() async {
    trayManager.addListener(this);

    await trayManager.setIcon(Assets.images.trayIcon.path);

    _setContextMenu(null);
    _menuChangeStream.stream.listen(_setContextMenu);
  }

  void _setContextMenu(_) async {
    final screenRecordPermission = await permissionServ.checkScreenRecord();

    print('Screen record permission: ${screenshotCubit.state}');

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
            key: MenuItemEnum.edit.name,
            label: MenuItemEnum.edit.label,
            disabled: screenshotCubit.state == null,
          ),
          MenuItem(
            key: MenuItemEnum.save.name,
            label: MenuItemEnum.save.label,
            disabled: screenshotCubit.state == null,
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
    final captureData = await screenCapturer.capture();

    if (captureData == null) return;

    String? text;
    List<UnknownToken> tokens = [];

    final imageBytes = captureData.imageBytes;

    if (imageBytes != null) {
      text = await ocrServ.textFromBytes(imageBytes);
    }

    if (text != null) {
      tokens = await tokenizeServ.tokenize(text);
    }

    screenshotCubit.setState(
      ScreenshotState(
        data: captureData,
        text: text,
        tokens: tokens,
      ),
    );
  }

  void _onExit() {
    exit(0);
  }

  void dispose() {
    _menuChangeStream.dispose();
    trayManager.removeListener(this);
  }
}

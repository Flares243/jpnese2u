import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:tray_manager/tray_manager.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/gen/assets.gen.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/services/tray_serv/constant.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/constant/constant.dart';
import 'package:jpnese2u/util/extensions/list.dart';
import 'package:jpnese2u/util/merged_stream.dart';

class TrayServ with TrayListener {
  TrayServ({
    required this.screenshotCubit,
    required this.permissionServ,
    required this.ocrServ,
    required this.tokenizeServ,
    required this.appDirectories,
  }) {
    _stateChangeStream = MergedStream([
      screenshotCubit.stream,
    ]);
  }

  final ScreenshotCubit screenshotCubit;
  final IPermissionServ permissionServ;
  final IOCRService ocrServ;
  final ITokenizeService tokenizeServ;
  final AppDirectories appDirectories;

  late final MergedStream _stateChangeStream;

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

  Future<void> init() async {
    trayManager.addListener(this);

    await trayManager.setIcon(Assets.images.trayIcon.path);

    _setContextMenu(null);
    _stateChangeStream.stream.listen(_setContextMenu);
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
          MenuItem.separator(),
          MenuItem(
            key: MenuItemEnum.debug.name,
            label: MenuItemEnum.debug.label,
          ),
          MenuItem(
            key: MenuItemEnum.exit.name,
            label: MenuItemEnum.exit.label,
          ),
        ],
      ),
    );
  }

  Future<void> _onCapture() async {
    final tempDirPath = appDirectories.temporaryDirectory.path;

    final captureData = await screenCapturer.capture(
      copyToClipboard: false,
      imagePath: [tempDirPath, kTempScreenshotFileName].toPath,
    );

    if (captureData == null) return;

    String? text;
    List<RawToken> tokens = [];

    final imageBytes = captureData.imageBytes;

    if (imageBytes != null) {
      text = await ocrServ.textFromBytes(imageBytes);
    }

    if (text != null) {
      tokens = await tokenizeServ.tokenize(text);
      if (tokens.isNotEmpty) tokens.removeLast();
    }

    final captureState = ScreenshotState(
      captureData: captureData,
      text: text,
      tokens: tokens,
    );

    screenshotCubit.setState(captureState);
  }

  void _onExit() {
    exit(0);
  }

  void dispose() {
    _stateChangeStream.dispose();
    trayManager.removeListener(this);
  }
}

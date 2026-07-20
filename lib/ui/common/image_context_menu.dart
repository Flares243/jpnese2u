import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';

class ImageContextMenu extends StatefulWidget {
  const ImageContextMenu({
    super.key,
    required this.child,
    required this.imageBytes,
  });

  final Widget child;
  final Uint8List imageBytes;

  @override
  State<ImageContextMenu> createState() => ImageContextMenuState();
}

class ImageContextMenuState extends State<ImageContextMenu> {
  final _menuController = ContextMenuController();

  void _onSecondaryTapUp(TapUpDetails details) {
    _menuController.show(
      context: context,
      contextMenuBuilder: (context) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: TextSelectionToolbarAnchors(
            primaryAnchor: details.globalPosition,
          ),
          buttonItems: [
            ContextMenuButtonItem(
              label: 'Copy',
              onPressed: () async {
                ContextMenuController.removeAny();

                final windowController =
                    await WindowController.fromCurrentEngine();

                final imageFile = File(
                  '${(await getTemporaryDirectory()).path}/${windowController.windowId}.png',
                );

                await imageFile.writeAsBytes(widget.imageBytes);
                await Pasteboard.writeFiles([imageFile.path]);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _menuController.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: _onSecondaryTapUp,
      child: widget.child,
    );
  }
}

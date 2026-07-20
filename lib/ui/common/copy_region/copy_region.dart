import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';

import 'package:pasteboard/pasteboard.dart';

class CopyRegion extends StatefulWidget {
  const CopyRegion({
    super.key,
    required this.child,
    this.content,
  });

  final Widget child;
  final CopyContent? content;

  @override
  State<CopyRegion> createState() => _CopyRegionState();
}

class _CopyRegionState extends State<CopyRegion> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    if (widget.content == null) return widget.child;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Stack(
        children: [
          widget.child,
          if (_hovering)
            Positioned(
              top: 8,
              right: 8,
              child: CopyButton(content: widget.content!),
            ),
        ],
      ),
    );
  }
}

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.content});

  final CopyContent content;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    switch (widget.content) {
      case CopyText(:final text):
        Pasteboard.writeText(text);

      case CopyFile(:final path, bytes: final fileBytes):
        var filePath = path;

        if (fileBytes != null) {
          final file = File(path);
          if (!file.parent.existsSync()) {
            file.parent.create(recursive: true);
          }
          await file.writeAsBytes(fileBytes);

          filePath = file.path;
        }

        await Pasteboard.writeFiles([filePath]);
    }

    setState(() => _copied = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: _copy,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            _copied ? Icons.check : Icons.copy,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

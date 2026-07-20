import 'package:flutter/widgets.dart';

class CloseContextMenuRegion extends StatelessWidget {
  const CloseContextMenuRegion({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ContextMenuController.removeAny,
      child: child,
    );
  }
}

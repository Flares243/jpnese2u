import 'package:flutter/cupertino.dart';

/// A button wrapper that disables itself and shows a loading indicator while
/// [onPressed] is running. Pass [onPressed] as null to disable without loading.
class AsyncButton extends StatefulWidget {
  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.builder,
  });

  final Future<void> Function()? onPressed;
  final Widget child;

  /// Build the actual button, e.g. `(ctx, onPressed, child) => TextButton(...)`.
  /// [onPressed] is null while loading or when the widget's [onPressed] is null.
  final Widget Function(
    BuildContext context,
    VoidCallback? onPressed,
    Widget child,
  )
  builder;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _loading = false;

  Future<void> _handlePress() async {
    setState(() => _loading = true);

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _loading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 8),
              widget.child,
            ],
          )
        : widget.child;

    final onPressed = (!_loading && widget.onPressed != null)
        ? _handlePress
        : null;

    return widget.builder(context, onPressed, child);
  }
}

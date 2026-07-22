import 'package:flutter/widgets.dart';

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({
    super.key,
    required this.condition,
    required this.wrapper,
    required this.child,
  });

  final bool condition;
  final Widget Function(Widget child) wrapper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return condition ? wrapper(child) : child;
  }
}

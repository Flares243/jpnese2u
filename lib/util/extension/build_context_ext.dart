import 'package:flutter/widgets.dart';

extension BuildContextExt on BuildContext {
  BuildContext? get onMounted => mounted ? this : null;
}

import 'package:flutter/widgets.dart';

extension StatefulExt<T extends StatefulWidget> on State<T> {
  BuildContext? get mountedContext => mounted ? context : null;
}

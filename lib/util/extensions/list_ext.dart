import 'dart:io';

extension ListExt on List<String> {
  String get toPath => join(Platform.pathSeparator);
}

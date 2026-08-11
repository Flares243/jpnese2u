import 'package:jpnese2u/util/constant/hinshi.dart';

extension StringExt on String {
  bool get isPunctuation =>
      this == Hinshi.symbol.jp || this == Hinshi.auxSymbol.jp;

  String removeNewLines() => replaceAll('\n', '');
}

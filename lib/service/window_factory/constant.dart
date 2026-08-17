import 'package:desktop_multi_window/desktop_multi_window.dart';

enum WindowType { screenshot, settings }

const kRootTrayChannel = WindowMethodChannel(
  'jpnese2u.root_tray',
  mode: ChannelMode.unidirectional,
);

class RootTrayMethod {
  static const reloadTokenizer = 'reloadTokenizer';
  static const reloadUserSession = 'reloadUserSession';
  static const reloadTray = 'reloadTray';
}

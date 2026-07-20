import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/services/window_serv/constant.dart';

class WindowEntitiesCtrller {
  WindowEntitiesCtrller({
    required this.screenshotCubit,
  });

  final ScreenshotCubit screenshotCubit;

  StreamSubscription? _stateChangeSubs;

  void init() {
    _stateChangeSubs = screenshotCubit.stream.listen(_onScreenshotStateChange);
  }

  Future<void> _onScreenshotStateChange(ScreenshotState? state) async {
    if (state == null) return;

    final args = ScreenshotWindowArguments(
      type: WindowType.screenshot,
      screenshotData: state,
    );

    await WindowController.create(
      WindowConfiguration(arguments: jsonEncode(args.toJson())),
    );
  }

  void dispose() {
    _stateChangeSubs?.cancel();
    _stateChangeSubs = null;
  }
}

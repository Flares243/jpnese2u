import 'dart:async';

class MergedStream {
  MergedStream(List<Stream<dynamic>> streams) {
    _controller = StreamController<void>.broadcast();

    for (final stream in streams) {
      _subscriptions.add(
        stream.listen(
          (_) => _controller.add(null),
          onError: _controller.addError,
        ),
      );
    }
  }

  late final StreamController<void> _controller;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Stream<void> get stream => _controller.stream;

  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await _controller.close();
  }
}

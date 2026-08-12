import 'package:flutter/widgets.dart';

extension AsyncSnapshotExtension<T> on AsyncSnapshot<T> {
  R fold<R>({
    R Function(Object error, StackTrace? stackTrace)? onError,
    R Function(T data)? onData,
    R Function()? onWaiting,
    R Function()? onNothing,
    required R Function() orElse,
  }) {
    if (hasError && onError != null) return onError(error!, stackTrace);
    if (hasData && onData != null) return onData(data as T);
    if (connectionState == .waiting && onWaiting != null) return onWaiting();
    if (!hasError && !hasData && onNothing != null) return onNothing();
    return orElse();
  }

  R? foldOrNull<R>({
    R? Function(Object error, StackTrace? stackTrace)? onError,
    R? Function(T data)? onData,
    R? Function()? onWaiting,
    R? Function()? onNothing,
  }) {
    if (hasError && onError != null) return onError(error!, stackTrace);
    if (hasData && onData != null) return onData(data as T);
    if (connectionState == .waiting && onWaiting != null) return onWaiting();
    if (!hasError && !hasData && onNothing != null) return onNothing();
    return null;
  }
}

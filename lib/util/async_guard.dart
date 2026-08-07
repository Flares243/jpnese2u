import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:jpnese2u/util/ignored_exception.dart';

FutureOr<AsyncSnapshot<ValueT>> asyncGuard<ValueT>(
  FutureOr<ValueT> Function() future, [
  bool Function(Object error)? test,
]) async {
  try {
    return AsyncSnapshot.withData(.done, await future());
  } on IgnoredException catch (_) {
    return AsyncSnapshot.nothing();
  } on DioException catch (err, st) {
    if (CancelToken.isCancel(err)) {
      return AsyncSnapshot.nothing();
    }

    if (test == null || test(err)) {
      return AsyncSnapshot.withError(.done, err, st);
    }

    Error.throwWithStackTrace(err, st);
  } catch (err, st) {
    if (test == null || test(err)) {
      print('[asyncGuard] error: $err, stackTrace: $st');
      return AsyncSnapshot.withError(.done, err, st);
    }

    Error.throwWithStackTrace(err, st);
  }
}

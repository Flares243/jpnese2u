extension GenericExtension<T> on T? {
  T onNull(T fallback) {
    if (this == null) {
      return fallback;
    }

    return this as T;
  }
}

extension GenericIterableExtension<T> on Iterable<T> {
  Iterable<T> separator(T separator) => expand((item) sync* {
    yield separator;
    yield item;
  }).skip(1);
}

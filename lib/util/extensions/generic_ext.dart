extension GenericExtension<T> on T? {
  T onNull(T fallback) {
    if (this == null) {
      return fallback;
    }

    return this as T;
  }
}

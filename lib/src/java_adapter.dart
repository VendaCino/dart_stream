part of '../dart_stream.dart';

typedef Runnable = void Function();
typedef Consumer<T> = void Function(T);
typedef BiConsumer<T1, T2> = void Function(T1, T2);
typedef Predicate<T> = bool Function(T t);
typedef JFunction<T, R> = R Function(T t);
typedef BiFunction<T, U, R> = R Function(T t,U u);
typedef BinaryOperator<T> = T Function(T t,T u);
typedef Supplier<T> = T Function();

extension JavaMap<K, V> on Map<K, V> {
  void put(K key, V value) {
    this[key] = value;
  }

  V get(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

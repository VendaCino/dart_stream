part of '../dart_stream.dart';

typedef JRunnable = void Function();
typedef JConsumer<T> = void Function(T);
typedef JBiConsumer<T1, T2> = void Function(T1, T2);
typedef JPredicate<T> = bool Function(T t);
typedef JFunction<T, R> = R Function(T t);
typedef JBiFunction<T, U, R> = R Function(T t,U u);
typedef JBinaryOperator<T> = T Function(T t,T u);
typedef JSupplier<T> = T Function();

extension _JavaMap<K, V> on Map<K, V> {
  void put(K key, V value) {
    this[key] = value;
  }

  V get(K key) {
    return containsKey(key) ? this[key] : null;
  }
}

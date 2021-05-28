part of '../dart_stream.dart';

mixin Collector<T, A, R> {
  Supplier<A> supplier;
  BiConsumer<A, T> accumulator;
  JFunction<A, R> finisher;
}

class _Collector<T, A, R> implements Collector<T, A, R>{

  @override
  Supplier<A> supplier;

  @override
  BiConsumer<A, T> accumulator;

  @override
  JFunction<A, R> finisher;

  _Collector(this.supplier, this.accumulator, this.finisher);
}

class Collectors {
  static Collector<T, List<T>, List<T>> toList<T>(){
    return _Collector(() => List.empty(growable: true), (l,r ) {l.add(r);return l; }, (t) => t);
  }

}
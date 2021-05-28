import 'package:dart_stream/dart_stream.dart';

class Obj2 {
  int a;
  int b;

  Obj2(this.a, this.b);
}

class SimpleCollector<T, A, R> implements Collector<T, A, R>{

  @override
  Supplier<A> supplier;

  @override
  BiConsumer<A, T> accumulator;

  @override
  JFunction<A, R> finisher;

  SimpleCollector({this.supplier, this.accumulator, this.finisher});
}
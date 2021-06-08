import 'package:dart_stream/dart_stream.dart';

class Obj2 {
  int a;
  int b;

  Obj2(this.a, this.b);
}

class Obj1 {
  int a;

  Obj1(this.a);
}

class Obj3 {
  int a;
  int b;
  int c;

  Obj3(this.a, this.b, this.c);
}

class Obj4 {
  int a;
  int b;
  int c;
  int d;

  Obj4(this.a, this.b, this.c, this.d);
}

class SimpleCollector<T, A, R> implements Collector<T, A, R>{

  @override
  JSupplier<A> supplier;

  @override
  JBiFunction<A, T, A> accumulator;

  @override
  JFunction<A, R> finisher;

  SimpleCollector({this.supplier, this.accumulator, this.finisher});
}
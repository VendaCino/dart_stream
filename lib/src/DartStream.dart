part of '../dart_stream.dart';

mixin DartStream<T> {
  static DartStream<R> of<R>(List<R> list){
    return Head<R,R>.source(ArrayIterator<R>(list), 0);
  }

  static DartStream<R> one<R>(R e){
    return Head<R,R>.source(ValueIterator<R>(e), 0);
  }

  static DartStream<R> empty<R>(){
    return Head<R,R>.source(EmptyIterator<R>(), 0);
  }

  static DartStream<int> range(int start,int end){
    var list = List.filled(end-start, 0);
    for(int i=0;i<list.length;++i) list[i]=i+start;
    return Head<int,int>.source(ArrayIterator<int>(list), 0);
  }
  // -----Operation-------

  DartStream<T> filter(Predicate<T> predicate);

  DartStream<R> map<R>(JFunction<T, R> mapper);

  DartStream<R> flatMap<R>(JFunction<T, DartStream<R>> mapper);

  DartStream<T> distinct();

  DartStream<T> sorted([Comparator<T> comparator]);

  DartStream<T> peek(Consumer<T> action);

  DartStream<T> limit(int maxSize);

  DartStream<T> skip(int n);

// -----Terminal Operation-------
  List<T> toList();

  T reduce0(BinaryOperator<T> accumulator);

  R reduce<R>(R identity, BiFunction<R, T, R> accumulator);

  R collect<R,A>(Collector<T,A,R> collector);

  T min([Comparator<T> comparator]);

  T max([Comparator<T> comparator]);

  int count();

  bool anyMatch(Predicate<T> predicate);

  bool allMatch(Predicate<T> predicate);

  bool noneMatch(Predicate<T> predicate);

  T findFirst();

  T findAny();

  void forEach(Consumer<T> action);
}

extension ExtendDartStream<T> on DartStream<T>{
  DartStream<T> slice(int start,int end){
    assert (end >= start);
    return skip(start).limit(end-start);
  }
  Map<K, U> toMap<K,U>(JFunction<T, K> keyMapper,
      JFunction<T, U> valueMapper, [BinaryOperator<U> mergeFunction, Supplier<Map<K, U>> mapSupplier]){
    return collect(Collectors.toMap(keyMapper,valueMapper,mergeFunction,mapSupplier));
  }
}

extension StringDartStream<T> on DartStream<String>{
  String joining([String delimiter]){
    return collect<String,String>(Collectors.joining(delimiter));
  }
}

extension NumberDartStream<T extends num> on DartStream<T>{
  T sum(){
    return reduce<num>(0, (t, u) => t+u);
  }
  double average(){
    List<double> a = [0.0,0.0];
    var r = reduce<List<double>>(a, (t, u) {
      return [t[0]+1,t[1]+u];
    });
    if(r[0]==0) return null;
    else return r[1]/r[0];
  }
}

extension ToStreamList<T> on List<T>{
  DartStream<T> toStream(){
    return DartStream.of(this);
  }
}
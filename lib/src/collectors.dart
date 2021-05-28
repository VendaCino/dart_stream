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

  static Collector<String, String, String> joining([String delimiter]) {
    return _Collector<String, String, String>(()=>null, (l,r){
      if(l==null) return r;
      return delimiter==null?l+r:l+delimiter+r;
    },(t)=>t==null?"":t);
  }

  static Collector<T, Map<K, U>, Map<K, U>> toMap<T, K, U>(JFunction<T, K> keyMapper,
      JFunction<T, U> valueMapper, [BinaryOperator<U> mergeFunction, Supplier<Map<K, U>> mapSupplier]) {
    if (mapSupplier == null) mapSupplier = () => HashMap<K, U>();
    if (mergeFunction == null) mergeFunction = (v1, v2) => throw Exception("Duplicated key");
    BiConsumer<Map<K, U>, T> accumulator = (map, element) {
      var key = keyMapper(element);
      var value = valueMapper(element);
      if (!map.containsKey(key))
        map.put(key, value);
      else
        map.put(key, mergeFunction(map.get(key), value));
      return map;
    };
    return _Collector(mapSupplier, accumulator, (t) => t);
  }
}
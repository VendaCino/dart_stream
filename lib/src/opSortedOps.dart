part of '../dart_stream.dart';

class _SortedOp<T> extends _DsPipeline<T, T> {
  static final Comparator<dynamic> natureComparator=(dynamic o1,dynamic o2){
    if(o1 is num && o2 is num) return o1-o2;
    else return 0;
  };

  final Comparator<T> comparator;
  final bool isNaturalSort;
  _SortedOp(_AbstractPipeline previousStage, this.comparator, this.isNaturalSort) : super.op(previousStage, _StreamOpFlag.IS_ORDERED | _StreamOpFlag.IS_SORTED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_StreamOpFlag.SORTED.isKnown(flags) && isNaturalSort)
      return sink;
    else if (_StreamOpFlag.SIZED.isKnown(flags))
      return _SizedSortingSink<T>(sink, comparator);
    else
      return _SortingSink<T>(sink, comparator);
  }
}

abstract class _AbstractSortingSink<T> extends _ChainedSink<T, T> {
   final Comparator<T> comparator;
   bool cancellationRequestedCalled = false;

   _AbstractSortingSink(_Sink< T> downstream, this.comparator) :super(downstream, null);

  @override
  bool cancellationRequested() {
  cancellationRequestedCalled = true;
  return false;
  }
}

class _SizedSortingSink<T> extends _AbstractSortingSink<T>{
  List<T> array;
  int offset;

  _SizedSortingSink(_Sink<T> downstream, Comparator<T> comparator) : super(downstream, comparator);

  @override
  void begin(int size) {
    array = List.filled(size,null, growable: false);
  }

  @override
  void end() {
    array.sort(this.comparator);
    downstream.begin(offset);
    if (!cancellationRequestedCalled) {
      for (int i = 0; i < offset; i++)
        downstream.accept(array[i]);
    }
    else {
      for (int i = 0; i < offset && !downstream.cancellationRequested(); i++)
        downstream.accept(array[i]);
    }
    downstream.end();
    array = null;
  }

  @override
  void accept(T t) {
    array[offset++] = t;
  }
}

class _SortingSink<T> extends _AbstractSortingSink<T>{
  List<T> list;

  _SortingSink(_Sink<T> downstream, Comparator<T> comparator) : super(downstream, comparator);

  @override
  void begin(int size) {
    list = List.empty(growable: true);
  }

  @override
  void end() {
    list.sort(comparator);
    downstream.begin(list.length);
    if (!cancellationRequestedCalled) {
      list.forEach((e)=>downstream.accept(e));
    }
    else {
      for (T t in list) {
        if (downstream.cancellationRequested()) break;
        downstream.accept(t);
      }
    }
    downstream.end();
    list = null;
  }

  @override
  void accept(T t) {
    list.add(t);
  }
}
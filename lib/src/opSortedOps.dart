part of '../dart_stream.dart';

class SortedOp<T> extends DsPipeline<T, T> {
  static final Comparator<dynamic> natureComparator=(dynamic o1,dynamic o2){
    if(o1 is num && o2 is num) return o1-o2;
    else return 0;
  };

  final Comparator<T> comparator;
  final bool isNaturalSort;
  SortedOp(AbstractPipeline previousStage, this.comparator, this.isNaturalSort) : super.op(previousStage, StreamOpFlag.IS_ORDERED | StreamOpFlag.IS_SORTED);

  @override
  Sink<T> opWrapSink(int flags, Sink<T> sink) {
    if (StreamOpFlag.SORTED.isKnown(flags) && isNaturalSort)
      return sink;
    else if (StreamOpFlag.SIZED.isKnown(flags))
      return SizedSortingSink<T>(sink, comparator);
    else
      return SortingSink<T>(sink, comparator);
  }
}

abstract class AbstractSortingSink<T> extends ChainedSink<T, T> {
   final Comparator<T> comparator;
   bool cancellationRequestedCalled = false;

   AbstractSortingSink(Sink< T> downstream, this.comparator) :super(downstream, null);

  @override
  bool cancellationRequested() {
  cancellationRequestedCalled = true;
  return false;
  }
}

class SizedSortingSink<T> extends AbstractSortingSink<T>{
  List<T> array;
  int offset;

  SizedSortingSink(Sink<T> downstream, Comparator<T> comparator) : super(downstream, comparator);

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

class SortingSink<T> extends AbstractSortingSink<T>{
  List<T> list;

  SortingSink(Sink<T> downstream, Comparator<T> comparator) : super(downstream, comparator);

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
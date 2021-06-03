part of '../dart_stream.dart';

class _ShuffleOp<T> extends _DsPipeline<T, T> {

  _ShuffleOp(_AbstractPipeline previousStage) : super.op(previousStage, _StreamOpFlag.NOT_ORDERED | _StreamOpFlag.NOT_SORTED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_StreamOpFlag.SIZED.isKnown(flags))
      return _SizedShuffleSink<T>(sink);
    else
      return _ShuffleSink<T>(sink);
  }
}

class _SizedShuffleSink<T> extends _AbstractSortingSink<T>{
  List<T> array;
  int offset;

  _SizedShuffleSink(_Sink<T> downstream) : super(downstream, null);

  @override
  void begin(int size) {
    array = List.filled(size,null, growable: false);
  }

  @override
  void end() {
    array.shuffle();
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

class _ShuffleSink<T> extends _AbstractSortingSink<T>{
  List<T> list;

  _ShuffleSink(_Sink<T> downstream) : super(downstream, null);

  @override
  void begin(int size) {
    list = List.empty(growable: true);
  }

  @override
  void end() {
    list.shuffle();
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
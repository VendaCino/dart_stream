part of '../dart_stream.dart';

class _ReverseOp<T> extends _DsPipeline<T, T> {
  _ReverseOp(_AbstractPipeline previousStage)
      : super.op(previousStage,
            _StreamOpFlag.NOT_ORDERED | _StreamOpFlag.NOT_SORTED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_StreamOpFlag.SIZED.isKnown(flags))
      return _SizedReverseSink<T>(sink);
    else
      return _ReverseSink<T>(sink);
  }
}

class _SizedReverseSink<T> extends _AbstractSortingSink<T> {
  List<T> array;
  int offset;

  _SizedReverseSink(_Sink<T> downstream) : super(downstream, null);

  @override
  void begin(int size) {
    array = List.filled(size, null, growable: false);
  }

  @override
  void end() {
    downstream.begin(offset);
    if (!cancellationRequestedCalled) {
      for (int i = 0; i < offset; i++) downstream.accept(array[offset - 1 - i]);
    } else {
      for (int i = 0; i < offset && !downstream.cancellationRequested(); i++)
        downstream.accept(array[offset - 1 - i]);
    }
    downstream.end();
    array = null;
  }

  @override
  void accept(T t) {
    array[offset++] = t;
  }
}

class _ReverseSink<T> extends _AbstractSortingSink<T> {
  List<T> list;

  _ReverseSink(_Sink<T> downstream) : super(downstream, null);

  @override
  void begin(int size) {
    list = List.empty(growable: true);
  }

  @override
  void end() {
    downstream.begin(list.length);
    if (!cancellationRequestedCalled) {
      list.reversed.forEach((e) => downstream.accept(e));
    } else {
      for (T t in list.reversed) {
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

part of '../dart_stream.dart';

class SliceSink<T> extends ChainedSink<T, T> {
  SliceSink(Sink<T> downstream, int this.skip, int this.limit)
      : n = skip,
        m = limit >= 0 ? limit : 0x7fffffffffffffff,
        super(downstream, null);
  final int skip;
  final int limit;
  int n;
  int m;

  static int calcSize(int size, int skip, int limit) {
    return size >= 0 ? max(-1, min(size - skip, limit)) : -1;
  }

  @override
  void begin(int size) {
    downstream.begin(calcSize(size, skip, m));
  }

  @override
  void accept(T t) {
    if (n == 0) {
      if (m > 0) {
        m--;
        downstream.accept(t);
      }
    } else {
      n--;
    }
  }

  @override
  bool cancellationRequested() {
    return m == 0 || this.downstream.cancellationRequested();
  }
}

class SliceOp<T> extends DsPipeline<T, T> {
  final int _skip;
  final int _limit;

  static int flags(int limit) {
    return StreamOpFlag.NOT_SIZED | ((limit != -1) ? StreamOpFlag.IS_SHORT_CIRCUIT : 0);
  }

  SliceOp.op(AbstractPipeline previousStage, this._skip, this._limit)
      : super.op(previousStage, flags(_limit));

  @override
  Sink<T> opWrapSink(int flags, Sink<T> sink) {
    return SliceSink<T>(sink, _skip, _limit);
  }
}

part of '../dart_stream.dart';

class _TakeWhileOp<T> extends _DsPipeline<T, T> {
  final JPredicate<T> predicate;

  _TakeWhileOp(_AbstractPipeline previousStage, this.predicate)
      : super.op(previousStage, _OpFlag.NOT_SIZED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    return _TakeWhileSink<T>(sink, predicate);
  }
}

class _TakeWhileSink<T> extends _ChainedSink<T, T> {
  _TakeWhileSink(_Sink<T> downstream, this.predicate) : super(downstream, null);
  final JPredicate<T> predicate;
  bool stop = false;

  @override
  void begin(int size) {
    downstream.begin(-1);
  }

  @override
  void accept(T t) {
    if (!stop) {
      stop = !predicate(t);
      if (!stop) downstream.accept(t);
    }
  }

  @override
  bool cancellationRequested() {
    return stop || this.downstream.cancellationRequested();
  }
}

class _DropWhileOp<T> extends _DsPipeline<T, T> {
  final JPredicate<T> predicate;

  _DropWhileOp(_AbstractPipeline previousStage, this.predicate)
      : super.op(previousStage, _OpFlag.NOT_SIZED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    return _DropWhileSink<T>(sink, predicate);
  }
}

class _DropWhileSink<T> extends _ChainedSink<T, T> {
  _DropWhileSink(_Sink<T> downstream, this.predicate) : super(downstream, null);
  final JPredicate<T> predicate;
  bool start = false;

  @override
  void begin(int size) {
    downstream.begin(-1);
  }

  @override
  void accept(T t) {
    if (!start) {
      start = !predicate(t);
    }
    if (start) downstream.accept(t);
  }

  @override
  bool cancellationRequested() {
    return this.downstream.cancellationRequested();
  }
}

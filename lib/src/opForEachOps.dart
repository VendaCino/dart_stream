part of '../dart_stream.dart';

class _ForEachOp<T> extends _TerminalOp<T, Null>{
  final JConsumer<T> action;

  _ForEachOp(this.action);

  @override
  _TerminalSink<T, Null> makeSink() {
    return new _ForEachSink(action);
  }

}

class _ForEachSink<T> extends _TerminalSink<T,Null>{
  final JConsumer<T> action;

  _ForEachSink(this.action);
  @override
  void accept(T t) {
    action(t);
  }

  @override
  Null get() {
    return null;
  }

}
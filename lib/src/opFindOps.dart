part of '../dart_stream.dart';

class _FindOp<T> extends _TerminalOp<T, T> {

  @override
  int getOpFlag() {
    return _OpFlag.IS_SHORT_CIRCUIT ;
  }

  @override
  _TerminalSink<T, T> makeSink() {
    return new _FindSink();
  }
}

class _FindSink<T> extends _TerminalSink<T, T> {
  bool hasValue = false;
  T value;

  @override
  void accept(T value) {
    if (!hasValue) {
      hasValue = true;
      this.value = value;
    }
  }

  @override
  bool cancellationRequested() {
    return hasValue;
  }

  @override
  T get() {
    return hasValue ? value : null;
  }
}


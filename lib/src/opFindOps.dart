part of '../dart_stream.dart';

class _FindOp<T, O> implements _TerminalOp<T, O> {
  bool mustFindFirst = false;
  final JSupplier<_TerminalSink<T, O>> sinkSupplier;

  O emptyValue;

  _FindOp(this.sinkSupplier, [this.mustFindFirst = false, this.emptyValue]);

  @override
  O evaluate<P_IN>(
      _PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    O result = helper
        .wrapAndCopyInto<P_IN, _TerminalSink<T, O>>(
        sinkSupplier(), sourceIterator)
        .get();
    return result != null ? result : emptyValue;
  }

  @override
  int getOpFlag() {
    return _StreamOpFlag.IS_SHORT_CIRCUIT |
    (mustFindFirst ? 0 : _StreamOpFlag.NOT_ORDERED);
  }
}

abstract class _FindSink<T, O> extends _TerminalSink<T, O> {
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
}

class _DirFindSink<T> extends _FindSink<T, T> {
  @override
  T get() {
    return hasValue ? value : null;
  }
}

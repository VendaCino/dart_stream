part of '../dart_stream.dart';

class FindOp<T, O> implements TerminalOp<T, O> {
  bool mustFindFirst = false;
  final Supplier<TerminalSink<T, O>> sinkSupplier;

  O emptyValue;

  FindOp(this.sinkSupplier, [this.mustFindFirst = false, this.emptyValue]);

  @override
  O evaluate<P_IN>(
      PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    O result = helper
        .wrapAndCopyInto<P_IN, TerminalSink<T, O>>(
        sinkSupplier(), sourceIterator)
        .get();
    return result != null ? result : emptyValue;
  }

  @override
  int getOpFlag() {
    return StreamOpFlag.IS_SHORT_CIRCUIT |
    (mustFindFirst ? 0 : StreamOpFlag.NOT_ORDERED);
  }
}

abstract class FindSink<T, O> extends TerminalSink<T, O> {
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

class DirFindSink<T> extends FindSink<T, T> {
  @override
  T get() {
    return hasValue ? value : null;
  }
}

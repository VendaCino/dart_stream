part of '../dart_stream.dart';

class _ForEachOp<T>
    extends  _TerminalSink<T, Null> implements _TerminalOp<T, Null>{
  final JConsumer<T> action;

  _ForEachOp(this.action);

  @override
  void accept(T t) {
    action(t);
  }

  @override
  Null evaluate<P_IN>(_PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    return helper.wrapAndCopyInto<P_IN,_TerminalSink<T, Null>>(this, sourceIterator).get();
  }

  @override
  Null get() {
    return null;
  }

  @override
  int getOpFlag() {
    return 0;
  }

}
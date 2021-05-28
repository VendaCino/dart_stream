part of '../dart_stream.dart';

class ForEachOp<T>
    extends  TerminalSink<T, Null> implements TerminalOp<T, Null>{
  final Consumer<T> action;

  ForEachOp(this.action);

  @override
  void accept(T t) {
    action(t);
  }

  @override
  Null evaluate<P_IN>(PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    return helper.wrapAndCopyInto<P_IN,TerminalSink<T, Null>>(this, sourceIterator).get();
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
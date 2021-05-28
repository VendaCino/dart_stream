part of '../dart_stream.dart';

typedef WrapSinkFunction<E_IN, E_OUT> = Sink<E_IN> Function(int, Sink<E_OUT>);

class StatelessOp<E_IN, E_OUT> extends DsPipeline<E_IN, E_OUT> {
  final WrapSinkFunction wrapSinkFunction;

  StatelessOp.op(
      AbstractPipeline previousStage, int opFlags, this.wrapSinkFunction)
      : super.op(previousStage, opFlags);

  @override
  Sink<E_IN> opWrapSink(int flags, Sink<E_OUT> sink) {
    return wrapSinkFunction(flags,sink);
  }
}

mixin TerminalOp<E_IN, R> {
  R evaluate<P_IN>(
      PipelineHelper<E_IN> helper, BaseIterator<P_IN> sourceIterator);

  int getOpFlag();
}

abstract class TerminalSink<T, O> extends Sink<T> {
  O get();
}







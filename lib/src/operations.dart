part of '../dart_stream.dart';

typedef _WrapSinkFunction<E_IN, E_OUT> = _Sink<E_IN> Function(int, _Sink<E_OUT>);

class _StatelessOp<E_IN, E_OUT> extends _DsPipeline<E_IN, E_OUT> {
  final _WrapSinkFunction wrapSinkFunction;

  _StatelessOp.op(
      _AbstractPipeline previousStage, int opFlags, this.wrapSinkFunction)
      : super.op(previousStage, opFlags);

  @override
  _Sink<E_IN> opWrapSink(int flags, _Sink<E_OUT> sink) {
    return wrapSinkFunction(flags,sink);
  }
}

mixin _TerminalOp<E_IN, R> {
  R evaluate<P_IN>(
      _PipelineHelper<E_IN> helper, BaseIterator<P_IN> sourceIterator);

  int getOpFlag();
}

abstract class _TerminalSink<T, O> extends _Sink<T> {
  O get();
}







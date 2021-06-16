part of '../dart_stream.dart';


abstract class _Sink<T>{
  void begin(int size) {}
  void end() {}
  bool cancellationRequested() {return false;}
  void accept(T t);

}

class _ChainedSink<T, E_OUT> extends _Sink<T> {
  final _Sink<E_OUT> downstream;
  final JBiConsumer<T,_ChainedSink<T, E_OUT>>? consumer;

  _ChainedSink(this.downstream, this.consumer);

  void begin(int size) {
    this.downstream.begin(size);
  }

  void end() {
    this.downstream.end();
  }

  bool cancellationRequested() {
    return this.downstream.cancellationRequested();
  }

  @override
  void accept(T t) {
    consumer!(t,this);
  }
}
class _NotSizedChainedSink<T,E_OUT>extends _ChainedSink<T, E_OUT>{
  _NotSizedChainedSink(_Sink<E_OUT> downstream, JBiConsumer<T, _ChainedSink<T, E_OUT>> consumer) : super(downstream, consumer);
  @override
  void begin(int size) => this.downstream.begin(-1);
}

class _FlatMapChainedSink<T, E_OUT> extends _ChainedSink<T, E_OUT> {
  final JBiConsumer<T,_FlatMapChainedSink<T, E_OUT>> consumerNotSized;
  _FlatMapChainedSink(_Sink<E_OUT> downstream, this.consumerNotSized)
      : super(downstream, null);
  bool cancellationRequestedCalled = false;

  @override
  void begin(int size) => this.downstream.begin(-1);

  bool cancellationRequested() {
    cancellationRequestedCalled = true;
    return downstream.cancellationRequested();
  }

  @override
  void accept(T t) {
    consumerNotSized(t,this);
  }

}
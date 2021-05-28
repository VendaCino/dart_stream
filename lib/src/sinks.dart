part of '../dart_stream.dart';


abstract class Sink<T>{
  void begin(int size) {}
  void end() {}
  bool cancellationRequested() {return false;}
  void accept(T t);

}

class ChainedSink<T, E_OUT> extends Sink<T> {
  final Sink<E_OUT> downstream;
  final BiConsumer<T,ChainedSink<T, E_OUT>> consumer;

  ChainedSink(this.downstream, this.consumer);

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
    consumer(t,this);
  }
}
class NotSizedChainedSink<T,E_OUT>extends ChainedSink<T, E_OUT>{
  NotSizedChainedSink(Sink<E_OUT> downstream, BiConsumer<T, ChainedSink<T, E_OUT>> consumer) : super(downstream, consumer);
  @override
  void begin(int size) => this.downstream.begin(-1);
}

class FlatMapChainedSink<T, E_OUT> extends ChainedSink<T, E_OUT> {
  final BiConsumer<T,FlatMapChainedSink<T, E_OUT>> consumerNotSized;
  FlatMapChainedSink(Sink<E_OUT> downstream, this.consumerNotSized)
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
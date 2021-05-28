part of '../dart_stream.dart';


class ReduceOp<T, R, S extends TerminalSink<T, R>> implements TerminalOp<T, R> {

  final Supplier<S> sinkSupplier;

  ReduceOp(this.sinkSupplier);

  @override
  R evaluate<P_IN>(PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    return helper.wrapAndCopyInto(sinkSupplier(), sourceIterator).get();
  }

  @override
  int getOpFlag() {
    return 0;
  }
}

class HasSeedReducingSink<T,R> extends TerminalSink<T, R>{
  R state;
  R seed;
  final BiFunction<R, T, R> reducer;

  HasSeedReducingSink(this.seed, this.reducer);

  R get() {
    return state;
  }

  void begin(int size){
    state = seed;
  }

  @override
  void accept(T t) {
    state = reducer(state,t);
  }

}

class NoSeedReducingSink<T> extends TerminalSink<T, T>{
  T state;
  bool empty = true;
  final BinaryOperator<T> operator;

  NoSeedReducingSink(this.operator);

  T get() {
    return state;
  }

  void begin(int size){
    state = null;
    empty = true;
  }

  @override
  void accept(T t) {
    if (empty) {
      empty = false;
      state = t;
    } else {
      state = operator(state, t);
    }
  }

}
part of '../dart_stream.dart';


class _ReduceOp<T, R, S extends _TerminalSink<T, R>> extends _TerminalOp<T, R> {
  final R seed;
  final JBiFunction<R, T, R> reducer;

  _ReduceOp(this.reducer, [this.seed]);

  @override
  _TerminalSink<T, R> makeSink() {
    if(seed!=null) return new _HasSeedReducingSink<T, R>(seed, reducer);
    else return new _NoSeedReducingSink<R>(reducer as JBinaryOperator<R>) as _TerminalSink<T, R>;
  }
}

class _HasSeedReducingSink<T, R> extends _TerminalSink<T, R> {
  R state;
  R seed;
  final JBiFunction<R, T, R> reducer;

  _HasSeedReducingSink(this.seed, this.reducer);

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

class _NoSeedReducingSink<T> extends _TerminalSink<T, T>{
  T state;
  bool empty = true;
  final JBinaryOperator<T> operator;

  _NoSeedReducingSink(this.operator);

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
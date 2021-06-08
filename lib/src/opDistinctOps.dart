part of '../dart_stream.dart';

class _DistinctOp<T> extends _DsPipeline<T, T> {
  _DistinctOp(_AbstractPipeline previousStage) : super.op(previousStage,  _OpFlag.IS_DISTINCT);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_OpFlag.DISTINCT.isKnown(flags)) {
      return sink;
    } else if (_OpFlag.SORTED.isKnown(flags)){
      return _DistinctSinkSorted(sink);
    } else {
      return _DistinctSinkNotSorted(sink);
    }
  }

}

class _DistinctSinkSorted<T> extends _ChainedSink<T,T>{
  _DistinctSinkSorted(_Sink<T> downstream) : super(downstream, null);
  bool seenNull = false;
  T lastSeen;

  @override
   void begin(int size) {
    seenNull = false;
    lastSeen = null;
    downstream.begin(-1);
  }

  @override
   void end() {
    seenNull = false;
    lastSeen = null;
    downstream.end();
  }

  @override
   void accept(T t) {
    if (t == null) {
      if (!seenNull) {
        seenNull = true;
        downstream.accept(lastSeen = null);
      }
    } else if (lastSeen == null || t!=(lastSeen)) {
      downstream.accept(lastSeen = t);
    }
  }
  
}

class _DistinctSinkNotSorted<T> extends _ChainedSink<T,T>{
  _DistinctSinkNotSorted(_Sink<T> downstream) : super(downstream, null);
  Set<T> seen;
  T lastSeen;

  @override
  void begin(int size) {
    seen = HashSet();
    downstream.begin(-1);
  }

  @override
  void end() {
    seen = null;
    downstream.end();
  }

  @override
  void accept(T t) {
    if (!seen.contains(t)) {
      seen.add(t);
      downstream.accept(t);
    }
  }

}
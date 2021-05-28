part of '../dart_stream.dart';

class DistinctOp<T> extends DsPipeline<T, T> {
  DistinctOp(AbstractPipeline previousStage) : super.op(previousStage, StreamOpFlag.IS_ORDERED | StreamOpFlag.IS_SORTED);

  @override
  Sink<T> opWrapSink(int flags, Sink<T> sink) {
    if (StreamOpFlag.DISTINCT.isKnown(flags)) {
      return sink;
    } else if (StreamOpFlag.SORTED.isKnown(flags)){
      return DistinctSinkSorted(sink);
    } else {
      return DistinctSinkNotSorted(sink);
    }
  }

}

class DistinctSinkSorted<T> extends ChainedSink<T,T>{
  DistinctSinkSorted(Sink<T> downstream) : super(downstream, null);
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

class DistinctSinkNotSorted<T> extends ChainedSink<T,T>{
  DistinctSinkNotSorted(Sink<T> downstream) : super(downstream, null);
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
part of '../dart_stream.dart';

abstract class _PipelineHelper<E_OUT> {
  S wrapAndCopyInto<P_IN, S extends _Sink<E_OUT>>(S sink, BaseIterator<P_IN> spliterator);
}

abstract class _AbstractPipeline<E_IN, E_OUT> extends _PipelineHelper<E_OUT> {
  static const String MSG_STREAM_LINKED = "stream has already been operated upon or closed";

  bool linkedOrConsumed = false;
  BaseIterator<dynamic> sourceIterator;
  int combinedFlags;
  int depth;
  final _AbstractPipeline previousStage;
  _AbstractPipeline nextStage;


  _AbstractPipeline.op(this.previousStage, int opFlags){
    if (previousStage.linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    previousStage.linkedOrConsumed = true;
    previousStage.nextStage = this;
    sourceIterator = previousStage.sourceIterator;

    this.combinedFlags = _StreamOpFlag.combineOpFlags(opFlags, previousStage.combinedFlags);
    this.depth = previousStage.depth + 1;
  }

  _AbstractPipeline.source(this.sourceIterator,int sourceFlags)
      :previousStage=null, depth=0,combinedFlags=0x0;

  _Sink<E_IN> opWrapSink(int flags,_Sink<E_OUT> sink);

  R evaluate<R>(_TerminalOp<E_OUT, R> terminalOp) {
    if (linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    linkedOrConsumed = true;

    var terminalFlags = terminalOp.getOpFlag();
    if(terminalFlags!=0) combinedFlags = _StreamOpFlag.combineOpFlags(terminalFlags, combinedFlags);
    return terminalOp.evaluate(this, sourceIterator);
  }

  _Sink<P_IN> wrapSink<P_IN>(_Sink<E_OUT> inSink) {
    assert(inSink != null);
    _Sink sink = inSink;
    for (_AbstractPipeline p = this; p.depth > 0; p = p.previousStage) {
      sink = p.opWrapSink(p.previousStage.combinedFlags, sink);
    }
    return sink as _Sink<P_IN>;
  }

  S wrapAndCopyInto<P_IN, S extends _Sink<E_OUT>>(S sink, BaseIterator<P_IN> spliterator){
    copyInto(wrapSink(sink), spliterator);
    return sink;
  }

  void copyInto<P_IN> (_Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {

    if (!_StreamOpFlag.SHORT_CIRCUIT.isKnown(combinedFlags)) {
      wrappedSink.begin(spliterator.getExactSizeIfKnown());
      spliterator.forEachRemaining((t)=>wrappedSink.accept(t));
      wrappedSink.end();
    }
    else {
      copyIntoWithCancel(wrappedSink, spliterator);
    }
  }

  void copyIntoWithCancel<P_IN> (_Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {
    _AbstractPipeline p = this;
    while (p.depth > 0) {
      p = p.previousStage;
    }
    wrappedSink.begin(spliterator.getExactSizeIfKnown());
    p.forEachWithCancel(spliterator, wrappedSink);
    wrappedSink.end();
  }

  void forEachWithCancel(BaseIterator<E_OUT> it, _Sink<E_OUT> sink) {
    while(!it.done) {
      if(sink.cancellationRequested()){
        return;
      }
      var now = it.next();
      if (!it.toNil) sink.accept(now);
      else break;
    }
  }
}

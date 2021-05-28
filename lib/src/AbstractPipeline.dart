part of '../dart_stream.dart';

abstract class PipelineHelper<E_OUT> {
  S wrapAndCopyInto<P_IN, S extends Sink<E_OUT>>(S sink, BaseIterator<P_IN> spliterator);
}

abstract class AbstractPipeline<E_IN, E_OUT> extends PipelineHelper<E_OUT> {
  static const String MSG_STREAM_LINKED = "stream has already been operated upon or closed";
  static const String MSG_CONSUMED = "source already consumed or closed";

  bool linkedOrConsumed = false;
  BaseIterator<dynamic> sourceIterator;
  int combinedFlags;
  int depth;
  final AbstractPipeline previousStage;
  AbstractPipeline nextStage;


  AbstractPipeline.op(this.previousStage, int opFlags){
    if (previousStage.linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    previousStage.linkedOrConsumed = true;
    previousStage.nextStage = this;
    sourceIterator = previousStage.sourceIterator;

    this.combinedFlags = StreamOpFlag.combineOpFlags(opFlags, previousStage.combinedFlags);
    this.depth = previousStage.depth + 1;
  }

  AbstractPipeline.source(this.sourceIterator,int sourceFlags)
      :previousStage=null, depth=0,combinedFlags=0x0;

  Sink<E_IN> opWrapSink(int flags,Sink<E_OUT> sink);

  R evaluate<R>(TerminalOp<E_OUT, R> terminalOp) {
    if (linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    linkedOrConsumed = true;

    var terminalFlags = terminalOp.getOpFlag();
    if(terminalFlags!=0) combinedFlags = StreamOpFlag.combineOpFlags(terminalFlags, combinedFlags);
    return terminalOp.evaluate(this, sourceIterator);
  }

  Sink<P_IN> wrapSink<P_IN>(Sink<E_OUT> inSink) {
    assert(inSink != null);
    Sink sink = inSink;
    for (AbstractPipeline p = this; p.depth > 0; p = p.previousStage) {
      sink = p.opWrapSink(p.previousStage.combinedFlags, sink);
    }
    return sink as Sink<P_IN>;
  }

  S wrapAndCopyInto<P_IN, S extends Sink<E_OUT>>(S sink, BaseIterator<P_IN> spliterator){
    copyInto(wrapSink(sink), spliterator);
    return sink;
  }

  void copyInto<P_IN> (Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {

    if (!StreamOpFlag.SHORT_CIRCUIT.isKnown(combinedFlags)) {
      wrappedSink.begin(spliterator.getExactSizeIfKnown());
      spliterator.forEachRemaining((t)=>wrappedSink.accept(t));
      wrappedSink.end();
    }
    else {
      copyIntoWithCancel(wrappedSink, spliterator);
    }
  }

  void copyIntoWithCancel<P_IN> (Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {
    AbstractPipeline p = this;
    while (p.depth > 0) {
      p = p.previousStage;
    }
    wrappedSink.begin(spliterator.getExactSizeIfKnown());
    p.forEachWithCancel(spliterator, wrappedSink);
    wrappedSink.end();
  }

  void forEachWithCancel(BaseIterator<E_OUT> it, Sink<E_OUT> sink) {
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

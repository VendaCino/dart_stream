part of '../dart_stream.dart';

abstract class _AbstractPipeline<E_IN, E_OUT> {
  static const String MSG_STREAM_LINKED = "stream has already been operated upon or closed";

  bool linkedOrConsumed = false;
  late BaseIterator<dynamic> sourceIterator;
  late int combinedOpFlag;
  late int depth;
  final _AbstractPipeline? previousStage;
  _AbstractPipeline? nextStage;


  _AbstractPipeline.op(this.previousStage, int opFlags){
    if (previousStage!.linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    previousStage!.linkedOrConsumed = true;
    previousStage!.nextStage = this;
    sourceIterator = previousStage!.sourceIterator;

    this.combinedOpFlag = _OpFlag.combineOpFlags(opFlags, previousStage!.combinedOpFlag);
    this.depth = previousStage!.depth + 1;
  }

  _AbstractPipeline.source(this.sourceIterator,int sourceFlags)
      :previousStage=null, depth=0, combinedOpFlag=sourceFlags;

  _Sink<E_IN> opWrapSink(int flags,_Sink<E_OUT> sink);

  R evaluate<R>(_TerminalOp<E_OUT, R> terminalOp) {
    if (linkedOrConsumed) throw new Exception(MSG_STREAM_LINKED);
    linkedOrConsumed = true;

    var terminalFlags = terminalOp.getOpFlag();
    if(terminalFlags!=0) combinedOpFlag = _OpFlag.combineOpFlags(terminalFlags, combinedOpFlag);

    var finalSink = terminalOp.makeSink();
    var sink = this._wrapSink(finalSink);
    _copyInto(sink,sourceIterator);

    return finalSink.get();
  }

  _Sink<P_IN> _wrapSink<P_IN>(_Sink<E_OUT> inSink) {
    assert(inSink != null);
    _Sink sink = inSink;
    for (_AbstractPipeline p = this; p.depth > 0; p = p.previousStage!) {
      sink = p.opWrapSink(p.previousStage!.combinedOpFlag, sink);
    }
    return sink as _Sink<P_IN>;
  }

  void _copyInto<P_IN> (_Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {
    if (!_OpFlag.SHORT_CIRCUIT.isKnown(combinedOpFlag)) {
      wrappedSink.begin(spliterator.getExactSizeIfKnown());
      spliterator.forEachRemaining((t)=>wrappedSink.accept(t));
      wrappedSink.end();
    } else {
      _copyIntoWithCancel(wrappedSink, spliterator);
    }
  }

  void _copyIntoWithCancel<P_IN> (_Sink<P_IN> wrappedSink, BaseIterator<P_IN> spliterator) {
    _AbstractPipeline p = this;
    while (p.depth > 0) {
      p = p.previousStage!;
    }
    wrappedSink.begin(spliterator.getExactSizeIfKnown());
    p._forEachWithCancel(spliterator, wrappedSink);
    wrappedSink.end();
  }

  void _forEachWithCancel(BaseIterator<E_OUT> it, _Sink<E_OUT> sink) {
    while(!it.done) {
      if(sink.cancellationRequested()){
        return;
      }
      sink.accept(it.next());
    }
  }
}

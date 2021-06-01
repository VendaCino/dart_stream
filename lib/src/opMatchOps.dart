part of '../dart_stream.dart';


enum _MatchKind{
  ANY,ALL,NONE
}
abstract class _BooleanTerminalSink<T> extends _Sink<T> {
  static final Map<_MatchKind,bool> shortCircuitResult =
  HashMap.fromIterables([_MatchKind.ANY,_MatchKind.ALL,_MatchKind.NONE], [true,false,false]);
  static final Map<_MatchKind,bool> stopOnPredicateMatches =
  HashMap.fromIterables([_MatchKind.ANY,_MatchKind.ALL,_MatchKind.NONE], [true,false,true]);

  bool stop = false;
  bool value = false;

  _BooleanTerminalSink(_MatchKind matchKind):value = !shortCircuitResult[matchKind];

  @override
  bool cancellationRequested() {return stop;}

  bool getAndClearState() {
    return value;
  }

}

class _MatchOp<T> implements _TerminalOp<T, bool>{
  final _MatchKind matchKind;
  final JSupplier<_BooleanTerminalSink<T>> sinkSupplier;

  _MatchOp(this.matchKind, this.sinkSupplier);

  @override
  bool evaluate<P_IN>(_PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    return helper.wrapAndCopyInto(sinkSupplier(), sourceIterator).getAndClearState();
  }

  @override
  int getOpFlag() {
    return _StreamOpFlag.IS_SHORT_CIRCUIT | _StreamOpFlag.NOT_ORDERED;
  }
}

class _DirMatchSink<T> extends _BooleanTerminalSink<T>{
  final _MatchKind matchKind;
  final JPredicate<T> predicate;
  _DirMatchSink(this.matchKind, this.predicate) : super(matchKind);


  @override
  void accept(T t) {
    if (!stop && predicate(t) == _BooleanTerminalSink.stopOnPredicateMatches[matchKind]) {
      stop = true;
      value = _BooleanTerminalSink.shortCircuitResult[matchKind];
    }
  }

}
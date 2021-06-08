part of '../dart_stream.dart';

enum _MatchKind{
  ANY,ALL,NONE
}

class _MatchOp<T> extends _TerminalOp<T, bool> {
  final _MatchKind matchKind;
  final JPredicate<T> predicate;

  _MatchOp(this.matchKind, this.predicate);

  @override
  int getOpFlag() {
    return _OpFlag.IS_SHORT_CIRCUIT;
  }

  @override
  _TerminalSink<T, bool> makeSink() {
    return _MatchOpSink(matchKind, predicate);
  }
}

class _MatchOpSink<T> extends _TerminalSink<T,bool>{
  final _MatchKind matchKind;
  final JPredicate<T> predicate;
  _MatchOpSink(this.matchKind, this.predicate) : value = !shortCircuitResult[matchKind];
  bool stop = false;
  bool value = false;

  static final Map<_MatchKind,bool> shortCircuitResult =
  HashMap.fromIterables([_MatchKind.ANY,_MatchKind.ALL,_MatchKind.NONE], [true,false,false]);
  static final Map<_MatchKind,bool> stopOnPredicateMatches =
  HashMap.fromIterables([_MatchKind.ANY,_MatchKind.ALL,_MatchKind.NONE], [true,false,true]);

  @override
  bool cancellationRequested() {return stop;}

  @override
  bool get() {
    return value;
  }

  @override
  void accept(T t) {
    if (!stop && predicate(t) == stopOnPredicateMatches[matchKind]) {
      stop = true;
      value = shortCircuitResult[matchKind];
    }
  }

}
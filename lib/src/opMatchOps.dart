part of '../dart_stream.dart';


enum MatchKind{
  ANY,ALL,NONE
}
abstract class BooleanTerminalSink<T> extends Sink<T> {
  static final Map<MatchKind,bool> shortCircuitResult =
  HashMap.fromIterables([MatchKind.ANY,MatchKind.ALL,MatchKind.NONE], [true,false,false]);
  static final Map<MatchKind,bool> stopOnPredicateMatches =
  HashMap.fromIterables([MatchKind.ANY,MatchKind.ALL,MatchKind.NONE], [true,false,true]);

  bool stop = false;
  bool value = false;

  BooleanTerminalSink(MatchKind matchKind):value = !shortCircuitResult[matchKind];

  @override
  bool cancellationRequested() {return stop;}

  bool getAndClearState() {
    return value;
  }

}

class MatchOp<T> implements TerminalOp<T, bool>{
  final MatchKind matchKind;
  final Supplier<BooleanTerminalSink<T>> sinkSupplier;

  MatchOp(this.matchKind, this.sinkSupplier);

  @override
  bool evaluate<P_IN>(PipelineHelper<T> helper, BaseIterator<P_IN> sourceIterator) {
    return helper.wrapAndCopyInto(sinkSupplier(), sourceIterator).getAndClearState();
  }

  @override
  int getOpFlag() {
    return StreamOpFlag.IS_SHORT_CIRCUIT | StreamOpFlag.NOT_ORDERED;
  }
}

class DirMatchSink<T> extends BooleanTerminalSink<T>{
  final MatchKind matchKind;
  final Predicate<T> predicate;
  DirMatchSink(this.matchKind, this.predicate) : super(matchKind);


  @override
  void accept(T t) {
    if (!stop && predicate(t) == BooleanTerminalSink.stopOnPredicateMatches[matchKind]) {
      stop = true;
      value = BooleanTerminalSink.shortCircuitResult[matchKind];
    }
  }

}
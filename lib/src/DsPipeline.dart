part of '../dart_stream.dart';

abstract class _DsPipeline<P_IN, P_OUT> extends _AbstractPipeline<P_IN, P_OUT>
    implements DartStream<P_OUT> {
  _DsPipeline.source(BaseIterator sourceIterator, int sourceFlags)
      : super.source(sourceIterator, sourceFlags);

  _DsPipeline.op(_AbstractPipeline previousStage, int opFlags) : super.op(previousStage, opFlags);

  @override
  bool allMatch(JPredicate<P_OUT> predicate) {
    return evaluate(_MatchOp<P_OUT>(_MatchKind.ALL, predicate));
  }

  @override
  bool anyMatch(JPredicate<P_OUT> predicate) {
    return evaluate(_MatchOp<P_OUT>(_MatchKind.ANY, predicate));
  }

  @override
  bool noneMatch(JPredicate<P_OUT> predicate) {
    return evaluate(_MatchOp<P_OUT>(_MatchKind.NONE, predicate));
  }

  @override
  R collect<R, A>(Collector<P_OUT, A, R> collector) {
    A container = reduce<A>(collector.supplier(), collector.accumulator);
    if (collector.finisher != null)
      return collector.finisher!(container);
    else
      return container as R;
  }

  @override
  int count() {
    return reduce<int>(0, (t, u) => t + 1);
  }

  @override
  DartStream<P_OUT> distinct() {
    return _DistinctOp(this);
  }

  @override
  DartStream<P_OUT> filter(JPredicate<P_OUT> predicate) {
    return _StatelessOp(this, _OpFlag.NOT_SIZED, (flag,sink ) =>
        _NotSizedChainedSink<P_OUT,P_OUT>(sink,(t,_this){
          if (predicate(t)) _this.downstream.accept(t);
        }));
  }

  @override
  P_OUT? findAny() {
    return evaluate(_FindOp<P_OUT>());
  }

  @override
  P_OUT? findFirst() {
    return evaluate(_FindOp<P_OUT>());
  }

  @override
  DartStream<R> flatMap<R>(JFunction<P_OUT, DartStream<R>> mapper) {
    return _StatelessOp<P_OUT, R>(
        this, _OpFlag.NOT_SORTED | _OpFlag.NOT_DISTINCT | _OpFlag.NOT_SIZED,
        (flag, sink) {
      return new _FlatMapChainedSink<P_OUT, R>(sink, (t, _this) {
        DartStream<R> result = mapper(t);
        if (result != null) {
          if (!_this.cancellationRequestedCalled) {
            result.forEach((e) => _this.downstream.accept(e));
          } else {
            if (result is _DsPipeline<P_OUT, R>) {
              var it = result.sourceIterator;
              while (!it.done) {
                if (_this.downstream.cancellationRequested()) return;
                sink.accept(it.next());
              }
            } else {
              result.forEach((e) {
                if (!_this.downstream.cancellationRequested()) _this.downstream.accept(e);
              });
            }
          }
        }
        return;
      });
    });
  }

  @override
  DartStream<R> map<R>(JFunction<P_OUT, R> mapper) {
    return _StatelessOp<P_OUT, R>(this, _OpFlag.NOT_SORTED | _OpFlag.NOT_DISTINCT,
        (flag, sink) {
      return new _ChainedSink<P_OUT, R>(sink, (t, _this) {
        _this.downstream.accept(mapper(t));
      });
    });
  }

  @override
  P_OUT? max([Comparator<P_OUT>? comparator]) {
    if(comparator==null) comparator = _SortedOp.natureComparator;
    return reduce0((a, b) => comparator!(a, b) >= 0 ? a : b);
  }

  @override
  P_OUT? min([Comparator<P_OUT>? comparator]) {
    if(comparator==null) comparator = _SortedOp.natureComparator;
    return reduce0((a, b) => comparator!(a, b) <= 0 ? a : b);
  }

  @override
  DartStream<P_OUT> peek(JConsumer<P_OUT> action) {
    return _StatelessOp<P_OUT, P_OUT>(this, 0, (flag, sink) {
      return new _ChainedSink<P_OUT, P_OUT>(sink, (t, _this) {
        action(t);
        _this.downstream.accept(t);
      });
    });
  }

  @override
  U reduce<U>(U identity, JBiFunction<U, P_OUT, U> accumulator) {
    return evaluate(_ReduceOp<P_OUT, U, _TerminalSink<P_OUT, U>>(accumulator,identity));
  }

  P_OUT? reduce0(JBinaryOperator<P_OUT> accumulator) {
    return evaluate(_ReduceNoSeedOp<P_OUT, _TerminalSink<P_OUT, P_OUT?>>(accumulator));
  }

  @override
  DartStream<P_OUT> limit(int maxSize) {
    return new _SliceOp(this, 0, maxSize > 0 ? maxSize : 0);
  }

  @override
  DartStream<P_OUT> skip(int n) {
    return new _SliceOp(this, n > 0 ? n : 0, -1);
  }

  @override
  DartStream<P_OUT> sorted([Comparator<P_OUT>? comparator]) {
    if (comparator != null) return _SortedOp(this, comparator, false);
    else return _SortedOp(this, _SortedOp.natureComparator, true);
  }

  @override
  List<P_OUT> toList() {
    return collect(Collectors.toList());
  }

  @override
  void forEach(JConsumer<P_OUT> action) {
    evaluate(_ForEachOp(action));
  }

  @override
  DartStream<P_OUT> shuffle(){
    return _ShuffleOp(this);
  }

  DartStream<P_OUT> reverse(){
    return _ReverseOp(this);
  }

  DartStream<P_OUT> takeWhile(JPredicate<P_OUT> predicate){
    return _TakeWhileOp(this, predicate);
  }

  DartStream<P_OUT> dropWhile(JPredicate<P_OUT> predicate){
    return _DropWhileOp(this, predicate);
  }

}

class _Head<P_IN, P_OUT> extends _DsPipeline<P_IN, P_OUT> {
  _Head.source(BaseIterator sourceIterator, int sourceFlags)
      : super.source(sourceIterator, sourceFlags);

  @override
  _Sink<P_IN> opWrapSink(int flags, _Sink<P_OUT> sink) {
    throw UnsupportedError('NotSupport');
  }
}

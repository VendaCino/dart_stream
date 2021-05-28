part of '../dart_stream.dart';

abstract class DsPipeline<P_IN, P_OUT> extends AbstractPipeline<P_IN, P_OUT>
    implements DartStream<P_OUT> {
  DsPipeline.source(BaseIterator sourceIterator, int sourceFlags)
      : super.source(sourceIterator, sourceFlags);

  DsPipeline.op(AbstractPipeline previousStage, int opFlags) : super.op(previousStage, opFlags);

  @override
  bool allMatch(Predicate<P_OUT> predicate) {
    return evaluate(
        MatchOp<P_OUT>(MatchKind.ALL, () => DirMatchSink<P_OUT>(MatchKind.ALL, predicate)));
  }

  @override
  bool anyMatch(Predicate<P_OUT> predicate) {
    return evaluate(
        MatchOp<P_OUT>(MatchKind.ANY, () => DirMatchSink<P_OUT>(MatchKind.ANY, predicate)));
  }

  @override
  bool noneMatch(Predicate<P_OUT> predicate) {
    return evaluate(
        MatchOp<P_OUT>(MatchKind.NONE, () => DirMatchSink<P_OUT>(MatchKind.NONE, predicate)));
  }

  @override
  R collect<R, A>(Collector<P_OUT, A, R> collector) {
    A container = reduce<A>(collector.supplier(), collector.accumulator);
    if (collector.finisher != null)
      return collector.finisher(container);
    else
      return container as R;
  }

  @override
  int count() {
    return reduce<int>(0, (t, u) => t + 1);
  }

  @override
  DartStream<P_OUT> distinct() {
    return DistinctOp(this);
  }

  @override
  DartStream<P_OUT> filter(Predicate<P_OUT> predicate) {
    return StatelessOp.op(this, StreamOpFlag.NOT_SIZED, (flag,sink ) =>
        NotSizedChainedSink<P_OUT,P_OUT>(sink,(t,_this){
          if (predicate(t)) _this.downstream.accept(t);
        }));
  }

  @override
  P_OUT findAny() {
    return evaluate(FindOp<P_OUT, P_OUT>(() => DirFindSink<P_OUT>(), false));
  }

  @override
  P_OUT findFirst() {
    return evaluate(FindOp<P_OUT, P_OUT>(() => DirFindSink<P_OUT>(), true));
  }

  @override
  DartStream<R> flatMap<R>(JFunction<P_OUT, DartStream<R>> mapper) {
    return StatelessOp<P_OUT, R>.op(
        this, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED,
        (flag, sink) {
      return new FlatMapChainedSink<P_OUT, R>(sink, (t, _this) {
        DartStream<R> result = mapper(t);
        if (result != null) {
          if (!_this.cancellationRequestedCalled) {
            result.forEach((e) => _this.downstream.accept(e));
          } else {
            if (result is DsPipeline<P_OUT, R>) {
              var it = result.sourceIterator;
              while (!it.done) {
                if (_this.downstream.cancellationRequested()) return;
                var now = it.next();
                if (!it.toNil)
                  sink.accept(now);
                else
                  break;
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
    return StatelessOp<P_OUT, R>.op(this, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT,
        (flag, sink) {
      return new ChainedSink<P_OUT, R>(sink, (t, _this) {
        _this.downstream.accept(mapper(t));
      });
    });
  }

  @override
  P_OUT max(Comparator<P_OUT> comparator) {
    return reduce0((a, b) => comparator(a, b) >= 0 ? a : b);
  }

  @override
  P_OUT min(Comparator<P_OUT> comparator) {
    return reduce0((a, b) => comparator(a, b) <= 0 ? a : b);
  }

  @override
  DartStream<P_OUT> peek(Consumer<P_OUT> action) {
    return StatelessOp<P_OUT, P_OUT>.op(this, 0, (flag, sink) {
      return new ChainedSink<P_OUT, P_OUT>(sink, (t, _this) {
        action(t);
        _this.downstream.accept(t);
      });
    });
  }

  @override
  U reduce<U>(U identity, BiFunction<U, P_OUT, U> accumulator) {
    return evaluate(ReduceOp<P_OUT, U, HasSeedReducingSink<P_OUT, U>>(
        () => HasSeedReducingSink<P_OUT, U>(identity, accumulator)));
  }

  P_OUT reduce0(BinaryOperator<P_OUT> accumulator) {
    return evaluate(ReduceOp<P_OUT, P_OUT, NoSeedReducingSink<P_OUT>>(
        () => NoSeedReducingSink<P_OUT>(accumulator)));
  }

  @override
  DartStream<P_OUT> limit(int maxSize) {
    return SliceOp.op(this, 0, maxSize);
  }

  @override
  DartStream<P_OUT> skip(int n) {
    return SliceOp.op(this, n, -1);
  }

  @override
  DartStream<P_OUT> sorted([Comparator<P_OUT> comparator]) {
    if (comparator != null) return SortedOp(this, comparator, false);
    else return SortedOp(this, SortedOp.natureComparator, true);
  }

  @override
  List<P_OUT> toList() {
    return collect(Collectors.toList());
  }

  @override
  void forEach(Consumer<P_OUT> action) {
    evaluate(ForEachOp(action));
  }
}

class Head<P_IN, P_OUT> extends DsPipeline<P_IN, P_OUT> {
  Head.source(BaseIterator sourceIterator, int sourceFlags)
      : super.source(sourceIterator, sourceFlags);

  @override
  Sink<P_IN> opWrapSink(int flags, Sink<P_OUT> sink) {
    throw UnsupportedError('NotSupport');
  }
}

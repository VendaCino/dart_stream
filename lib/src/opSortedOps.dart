part of '../dart_stream.dart';

class _SortedOp<T> extends _DsPipeline<T, T> {
  static final Comparator<dynamic> natureComparator=(dynamic o1,dynamic o2){
    if(o1 is num && o2 is num) return o1-o2;
    else return 0;
  };

  final Comparator<T> comparator;
  final bool isNaturalSort;
  _SortedOp(_AbstractPipeline previousStage, this.comparator, this.isNaturalSort) : super.op(previousStage,  isNaturalSort?_OpFlag.IS_SORTED:0);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_OpFlag.SORTED.isKnown(flags) && isNaturalSort)
      return sink;
    else if (_OpFlag.SIZED.isKnown(flags))
      return _SortedSink<T>(sink, comparator, true);
    else
      return _SortedSink<T>(sink, comparator, false);
  }
}

class _SortedSink<T> extends _ChainedSink<T, T> {
  final Comparator<T> comparator;
  final bool sized;
  bool cancellationRequestedCalled = false;
  List<T> list;
  int offset = 0;

  _SortedSink(_Sink<T> downstream, this.comparator, this.sized)
      : super(downstream, null);

  @override
  bool cancellationRequested() {
    cancellationRequestedCalled = true;
    return false;
  }

  @override
  void begin(int size) {
    if(sized) list = List.filled(size,null, growable: false);
    else list = List.empty(growable: true);
  }

  void onEndSort(){
    list.sort(this.comparator);
  }

  @override
  void end() {
    onEndSort();
    downstream.begin(list.length);
    if (!cancellationRequestedCalled) {
      list.forEach((e)=>downstream.accept(e));
    }
    else {
      for (T t in list) {
        if (downstream.cancellationRequested()) break;
        downstream.accept(t);
      }
    }
    downstream.end();
    list = null;
  }

  @override
  void accept(T t) {
    if(sized) list[offset++] = t;
    else list.add(t);
  }
}
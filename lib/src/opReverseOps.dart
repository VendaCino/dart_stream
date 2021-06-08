part of '../dart_stream.dart';

class _ReverseOp<T> extends _DsPipeline<T, T> {
  _ReverseOp(_AbstractPipeline previousStage)
      : super.op(previousStage, _OpFlag.NOT_SORTED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_OpFlag.SIZED.isKnown(flags))
      return _ReverseSink<T>(sink, true);
    else
      return _ReverseSink<T>(sink, false);
  }
}

class _ReverseSink<T> extends _SortedSink<T>{
  _ReverseSink(_Sink<T> downstream, bool sized) : super(downstream, null, sized);

  @override
  void onEndSort(){
  }

  @override
  void end() {
    downstream.begin(list.length);
    if (!cancellationRequestedCalled) {
      list.reversed.forEach((e) => downstream.accept(e));
    } else {
      for (T t in list.reversed) {
        if (downstream.cancellationRequested()) break;
        downstream.accept(t);
      }
    }
    downstream.end();
    list = null;
  }
}
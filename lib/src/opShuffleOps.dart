part of '../dart_stream.dart';

class _ShuffleOp<T> extends _DsPipeline<T, T> {

  _ShuffleOp(_AbstractPipeline previousStage) : super.op(previousStage, _OpFlag.NOT_SORTED);

  @override
  _Sink<T> opWrapSink(int flags, _Sink<T> sink) {
    if (_OpFlag.SIZED.isKnown(flags))
      return _ShuffleSink<T>(sink, true);
    else
      return _ShuffleSink<T>(sink, false);
  }
}

class _ShuffleSink<T> extends _SortedSink<T>{
  _ShuffleSink(_Sink<T> downstream, bool sized) : super(downstream, null, sized);

  @override
  void onEndSort(){
    list.shuffle();
  }
}

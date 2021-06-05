part of '../dart_stream.dart';

extension FutureDartStream<T> on DartStream<Future<T>> {
  Future<T> anyOf() {
    List<Future<T>> list = this.toList();
    return Future.any(list);
  }

  Future<List<T>> allOf() async {
    List<Future<T>> list = this.toList();
    List<T> outList = List.empty(growable: true);
    for (var i = 0; i < list.length; ++i) {
      outList.add(await list[i]);
    }
    return outList;
  }
}

library streamdart;

import 'dart:collection';
import 'dart:math';

part 'src/java_adapter.dart';


part 'src/Iterators.dart';
part 'src/DartStream.dart';
part 'src/DsPipeline.dart';
part 'src/operations.dart';
part 'src/sinks.dart';
part 'src/AbstractPipeline.dart';
part 'src/StreamOpFlag.dart';
part 'src/opMatchOps.dart';
part 'src/opFindOps.dart';
part 'src/opReduceOps.dart';
part 'src/opForEachOps.dart';
part 'src/opSliceOps.dart';
part 'src/opDistinctOps.dart';
part 'src/opSortedOps.dart';
part 'src/collectors.dart';



void main(){
  var head = _Head<int,int>.source(_ArrayIterator<int>([1,2,3]), 0);
  var findFirst = head.map((t) => t+1).findFirst();
  print(findFirst);

  print(DartStream.of([1,2,3]).map((t) => t-1).allMatch((t) => t>0));
  print(DartStream.of([1,2,3]).map((t) => t-1).sum());
  print(DartStream.of([1.5,2.5,3.5]).map((t) => t-1).sum());
  print(DartStream.of([1,2,3]).map((t) => t-1).average());

  print(DartStream.of([1,2,3]).map((t) => t-1).flatMap((t) => DartStream.of([t,t,t]))
      .limit(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1).flatMap((t) => DartStream.of([t,t,t]))
      .skip(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1).flatMap((t) => DartStream.of([t,t,t]))
      .filter((t) => t>0).skip(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1).flatMap((t) => DartStream.of([t,t,t]))
      .sorted((o1,o2)=>o2-o1).toList());

  print(DartStream.of([3,2,1]).map((t) => t-1).sorted().toList());
  print(DartStream.of([3,2,1]).map((t) => t-1).sorted().map((t) => t.toString()+"!").toList());
}
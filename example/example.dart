
import 'package:dart_stream/dart_stream.dart';

class Item {
  String name;
  int num;

  Item(this.name, this.num);
}
Future<void> main() async {
  print(DartStream.of([3,2,1]).map((t) => t-1).sorted().distinct().distinct().toList());
  print(DartStream.of([1,2,3]).map((t) => t-1).allMatch((t) => t>0));
  print(DartStream.of([1,2,3]).map((t) => t-1).sum());
  print(DartStream.of([1.5,2.5,3.5]).map((t) => t-1).sum());
  print(DartStream.of([1,2,3]).map((t) => t-1).average());

  print(DartStream.of([1,2,3]).map((t) => t-1)
      .flatMap((t) => DartStream.of([t,t,t]))
      .limit(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1)
      .flatMap((t) => DartStream.of([t,t,t]))
      .skip(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1)
      .flatMap((t) => DartStream.of([t,t,t]))
      .filter((t) => t>0).skip(6).toList());

  print(DartStream.of([1,2,3]).map((t) => t-1)
      .flatMap((t) => DartStream.of([t,t,t]))
      .sorted((o1,o2)=>o2-o1).toList());

  print(DartStream.of([3,2,1]).map((t) => t-1).sorted().toList());
  print(DartStream.of([3,2,1]).map((t) => t-1).sorted()
      .map((t) => t.toString()+"!").toList());


  var items = [Item("apple",1),Item("apple",2),Item("banana",3),Item("orange",4)];

  var names = items.toStream().filter((t) => t.num<3).map((t) => t.name).distinct().toList();
  print(names);

  print([1,2,3].toStream().shuffle().toList());
  var result = await [1,2,3].toStream()
      .map((t) => Future.delayed(Duration(seconds:4-t),()=>t))
      .anyOf();
  print(result);
}
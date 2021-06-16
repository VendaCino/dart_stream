import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';

class _Person {
  int? parentId;
  int? childId;
  String? type;
  List<_Person>? children;
  _Person? parent;

  _Person({this.parentId, this.childId, this.type, this.children, this.parent});
}

List<_Person> createParents(numParents, numChildren) {
  return DartStream.range(0, numParents).map((num) {
    return _Person(parentId: num, type: 'parent', children: []);
  }).peek((parent) {
    parent.children = DartStream.range(0, numChildren).map((num) {
      return _Person(childId: num, type: 'child', parent: parent);
    }).toList();
  }).toList();
}

void main() {
  test('filter - flatMap - map - distinct - filter - join', () {
    var names = DartStream.of<_Person>([])
        .filter((t) => t.type == 'parent')
        .flatMap((t) => t.children!.toStream())
        .map((t) => t.toString())
        .distinct()
        .filter((t) => t.startsWith("a"))
        .joining(", ");

    expect(names, equals(""));
  });
  test('filter - map - toArray', () {
    var numFilter = 0;
    var numMap = 0;

    var data = [1, 2, 3, 4];

    var result = DartStream.of(data).filter((num) {
      numFilter++;
      return num % 2 == 1;
    }).map((num) {
      numMap++;
      return "obj" + num.toString();
    }).toList();

    expect(result.length, equals(2));
    expect(result[0], equals('obj1'));
    expect(result[1], equals('obj3'));
    expect(numFilter, equals(4));
    expect(numMap, equals(2));

    // assert original data is untouched
    expect(data.length, equals(4));
    expect(data[0], equals(1));
    expect(data[1], equals(2));
    expect(data[2], equals(3));
    expect(data[3], equals(4));
  });
  test('parent / children 1', () {
    var parents = createParents(5, 3);

    expect(parents.length, equals(5));

    for (var i = 0; i < parents.length; i++) {
      var parent = parents[i];
      expect(parent.parentId, equals(i));
      expect(parent.type, equals('parent'));
      expect(parent.children!.length, equals(3));
      for (var j = 0; j < parent.children!.length; j++) {
        var child = parent.children![j];
        expect(child.childId, equals(j));
        expect(child.type, equals('child'));
        expect(child.parent, equals(parent));
      }
    }
  });
  test('parent / children 2', () {
    var parents = createParents(5, 3);

    var children = DartStream.of(parents).filter((p) {
      return p.parentId! > 2;
    }).flatMap((p) {
      return p.children!.toStream();
    }).toList();

    expect(children.length, equals(6));
    expect(children[0].childId, equals(0));
    expect(children[1].childId, equals(1));
    expect(children[2].childId, equals(2));
    expect(children[3].childId, equals(0));
    expect(children[4].childId, equals(1));
    expect(children[5].childId, equals(2));
  });
}

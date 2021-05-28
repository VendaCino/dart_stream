import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';

void main() {
  test('filter num array', () {
    var data = [1, 2, 3, 4];

    var result = DartStream.of(data).filter((num) {
      return num % 2 == 1;
    }).toList();

    expect(result.length, equals(2));
    expect(result[0], equals(1));
    expect(result[1], equals(3));

    // assert original data is untouched
    expect(data.length, equals(4));
    expect(data[0], equals(1));
    expect(data[1], equals(2));
    expect(data[2], equals(3));
    expect(data[3], equals(4));
  });
  test('filter object array', () {
    var data = [Obj1(1), Obj1(2), Obj1(3), Obj1(4)];

    var result = DartStream.of(data).filter((obj) {
      return obj.a % 2 == 1;
    }).toList();

    expect(result.length, equals(2));
    expect(result[0].a, equals(1));
    expect(result[1].a, equals(3));

    // assert original data is untouched
    expect(data.length, equals(4));
    expect(data[0].a, equals(1));
    expect(data[1].a, equals(2));
    expect(data[2].a, equals(3));
    expect(data[3].a, equals(4));
  });
  test('filter empty', () {
    var result = DartStream.of([]).filter((t) {
      return true;
    }).toList();

    expect(result.length, equals(0));
  });
  test('filter with null', () {
    var result = DartStream.of([1, null, null, 2]).filter((t) {
      return true;
    }).toList();

    expect(result.length, equals(4));
    expect(result[0], equals(1));
    expect(result[1], equals(null));
    expect(result[2], equals(null));
    expect(result[3], equals(2));
  });
  test('filter via regexp literal', () {
    var data = ["a1", "a2", "b3"];

    var result = DartStream.of(data).filter((e) => e.startsWith("a")).toList();

    expect(result.length, equals(2));
    expect(result[0], equals("a1"));
    expect(result[1], equals("a2"));

    // assert original data is untouched
    expect(data.length, equals(3));
    expect(data[0], equals("a1"));
    expect(data[1], equals("a2"));
    expect(data[2], equals("b3"));
  });
  test('filter via sample object (depth=1)', () {
    var data = [Obj2(1, 1), Obj2(2, 2), Obj2(1, 3)];

    var result = DartStream.of(data).filter((e) => e.a == 1).toList();

    expect(result.length, equals(2));
    expect(result[0].a, equals(1));
    expect(result[0].b, equals(1));
    expect(result[1].a, equals(1));
    expect(result[1].b, equals(3));
  });
}

import 'package:dart_stream/dart_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import './test_define.dart';

void main() {
  test('dropWhile num array', () {
    var data = [1, 2, 3, 2, 1];

    var result = DartStream.of(data).dropWhile((num) {
      return num < 3;
    }).toList();

    expect(result.length, equals(3));
    expect(result[0], equals(3));
    expect(result[1], equals(2));
    expect(result[2], equals(1));

    // assert original data is untouched
    expect(data.length, equals(5));
    expect(data[0], equals(1));
    expect(data[1], equals(2));
    expect(data[2], equals(3));
    expect(data[3], equals(2));
    expect(data[4], equals(1));
  });

  test('dropWhile empty', () {
    var result = DartStream.of<String>([]).dropWhile((t) {
      return true;
    }).toList();

    expect(result.length, equals(0));
  });
  test('dropWhile via regexp literal', () {
    var data = ["a1", "a2", "b3", "a4"];

    var result =
        DartStream.of(data).dropWhile((e) => e.startsWith("a")).toList();

    expect(result.length, equals(2));
    expect(result[0], equals("b3"));
    expect(result[1], equals("a4"));

    // assert original data is untouched
    expect(data.length, equals(4));
    expect(data[0], equals("a1"));
    expect(data[1], equals("a2"));
    expect(data[2], equals("b3"));
    expect(data[3], equals("a4"));
  });
  test('dropWhile via sample object (depth=1)', () {
    var data = [Obj2(1, 1), Obj2(1, 2), Obj2(2, 3), Obj2(1, 4)];

    var result = DartStream.of(data).dropWhile((e) => e.a == 1).toList();

    expect(result.length, equals(2));
    expect(result[0].a, equals(2));
    expect(result[0].b, equals(3));
    expect(result[1].a, equals(1));
    expect(result[1].b, equals(4));
  });
}

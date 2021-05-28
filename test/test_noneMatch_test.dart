import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';

void main() {
  test('noneMatch true', () {
    var result = DartStream.of([1, 2, 3, 4]).noneMatch((num) {
      return num < 0;
    });
    expect(result, equals(true));
  });
  test('noneMatch false', () {
    var result = DartStream.of([1, 2, 3, 4]).noneMatch((num) {
      return num > 3;
    });
    expect(result, equals(false));
  });
  test('noneMatch empty', () {
    var result = DartStream.of([]).noneMatch((num) {
      return num > 1;
    });
    expect(result, equals(true));
  });
  test('noneMatch regexp true', () {
    var result = DartStream.of(["a1", "a2", "a3"]).noneMatch((e) => e.startsWith("b"));
    expect(result, equals(true));
  });
  test('noneMatch regexp false', () {
    var result = DartStream.of(["b1", "a2", "b3"]).noneMatch((e) => e.startsWith("a"));
    expect(result, equals(false));
  });
  test('noneMatch regexp empty', () {
    var result = DartStream.of([]).noneMatch((e) => e.startsWith("a"));
    expect(result, equals(true));
  });
  test('noneMatch sample true', () {
    var result = DartStream.of([Obj2(1, 5), Obj2(2, 5), Obj2(3, 5)]).noneMatch((e) => e.a == 4);
    expect(result, equals(true));
  });
  test('noneMatch sample false', () {
    var result = DartStream.of([Obj2(1, 5), Obj2(2, 5), Obj2(3, 5)]).noneMatch((e) => e.a == 1);
    expect(result, equals(false));
  });
  test('noneMatch sample empty', () {
    var result = DartStream.of([]).noneMatch((e) => e.a == 1);
    expect(result, equals(true));
  });
}

import 'package:dart_stream/dart_stream.dart';
import 'package:flutter_test/flutter_test.dart';


class _Temp {
  int a;
  int b;

  _Temp(this.a, this.b);
}

void main() {
  test('allMatch true', () {
    var result = DartStream.of([1, 2, 3, 4]).allMatch((num) {
      return num > 0;
    });
    expect(result, equals(true));
  });
  test('allMatch false', () {
    var result = DartStream.of([1, 2, 3, 4]).allMatch((num) {
      return num > 1;
    });
    expect(result, equals(false));
  });
  test('allMatch empty', () {
    var result = DartStream.of([]).allMatch((num) {
      return num > 1;
    });
    expect(result, equals(true));
  });
  test('allMatch regexp true', () {
    var result = DartStream.of(["a1", "a2", "a3"]).allMatch((e) => e.startsWith("a"));
    expect(result, equals(true));
  });
  test('allMatch regexp false', () {
    var result = DartStream.of(["a1", "a2", "b3"]).allMatch((e) => e.startsWith("a"));
    expect(result, equals(false));
  });
  test('allMatch regexp empty', () {
    var result = DartStream.of([]).allMatch((e) => e.startsWith("a"));
    expect(result, equals(true));
  });

  test('allMatch sample true', () {
    var result = DartStream.of([_Temp(1, 5), _Temp(2, 5), _Temp(3, 5)]).allMatch((e) => e.b == 5);
    expect(result, equals(true));
  });
  test('allMatch sample false', () {
    var result = DartStream.of([_Temp(1, 5), _Temp(2, 5), _Temp(3, 5)]).allMatch((e) => e.a == 1);
    expect(result, equals(false));
  });
  test('allMatch sample empty', () {
    var result = DartStream.of([]).allMatch((_) => false);
    expect(result, equals(true));
  });
}

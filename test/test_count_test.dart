import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';

void main() {
  test('count', () {
    var result = DartStream.of([1, 2, 3, 4]).count();
    expect(result, equals(4));
  });
  test('count empty', () {
    var result = DartStream.of([]).count();
    expect(result, equals(0));
  });
}

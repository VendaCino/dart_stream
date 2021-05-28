import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';

void main() {
  test('peek 1', () {
    var poke = [];
    var result = DartStream.of([1, 2, 3, 4]).peek((num) {
      poke.add(num);
    }).toList();

    expect(result.length, equals(poke.length));
    expect(result[0], equals(poke[0]));
    expect(result[1], equals(poke[1]));
    expect(result[2], equals(poke[2]));
    expect(result[3], equals(poke[3]));
  });
  test('peek empty', () {
    var poke = [];
    var result = DartStream.of([]).peek((num) {
      poke.add(num);
    }).toList();

    expect(poke.length, equals(0));
    expect(result.length, equals(0));
  });
}

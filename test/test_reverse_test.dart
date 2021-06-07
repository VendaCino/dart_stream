import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';

void main() {
  test('reverse', () {
    var data = [1, 2, 3, 4];

    var result = DartStream.of(data).reverse().toList();

    expect(result.length, equals(4));
    expect(result[0], equals(4));
    expect(result[1], equals(3));
    expect(result[2], equals(2));
    expect(result[3], equals(1));

    // assert original data is untouched
    expect(data.length, equals(4));
    expect(data[0], equals(1));
    expect(data[1], equals(2));
    expect(data[2], equals(3));
    expect(data[3], equals(4));
  });

  test('reverse of slice', () {
    var data = [0, 0, 1, 1, 2, 2, 3, 4, 4, 4];

    var result = DartStream.of(data).skip(2).distinct().reverse().toList();

    expect(result.length, equals(4));
    expect(result[0], equals(4));
    expect(result[1], equals(3));
    expect(result[2], equals(2));
    expect(result[3], equals(1));

    // assert original data is untouched
    expect(data[0], equals(0));
    expect(data[1], equals(0));
    expect(data[2], equals(1));
    expect(data[3], equals(1));
  });
}

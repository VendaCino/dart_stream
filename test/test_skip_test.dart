
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('skip', () {

    var result = DartStream.of([1, 2, 3, 4])
        .skip(2)
        .toList();

    expect(result.length, equals( 2));
    expect(result[0], equals( 3));
    expect(result[1], equals( 4));

});
test('skip empty', () {

    var result = DartStream.of([])
        .skip(1)
        .toList();

    expect(result.length, equals( 0));

});
test('skip high', () {

    var result = DartStream.of([1, 2, 3, 4])
        .skip(10)
        .toList();

    expect(result.length, equals( 0));

});
test('skip zero', () {

    var result = DartStream.of([1, 2, 3, 4])
        .skip(0)
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

});
test( 'skip negative',() {

    var result = DartStream.of([1, 2, 3, 4])
        .skip(-1)
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

});

}

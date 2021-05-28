
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('limit', () {

    var result = DartStream.of([1, 2, 3, 4])
        .limit(2)
        .toList();

    expect(result.length, equals( 2));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));

});
test('limit empty', () {

    var result = DartStream.of([])
        .limit(1)
        .toList();

    expect(result.length, equals( 0));

});
test('limit high', () {

    var result = DartStream.of([1, 2, 3, 4])
        .limit(10)
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

});
test('limit zero', () {

    var result = DartStream.of([1, 2, 3, 4])
        .limit(0)
        .toList();

    expect(result.length, equals( 0));

});
test( 'limit negative',() {

    var result = DartStream.of([1, 2, 3, 4])
        .limit(-1)
        .toList();

    expect(result.length, equals( 0));

});

}
